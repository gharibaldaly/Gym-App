import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'ai_config.dart';

class AiException implements Exception {
  final String message;
  final int? statusCode;
  AiException(this.message, {this.statusCode});

  bool get isAuth => statusCode == 401 || statusCode == 403;
  bool get isRetryable => statusCode == null || statusCode == 429 || statusCode == 529 || statusCode! >= 500;

  @override
  String toString() => 'AiException($statusCode): $message';
}

class AiNoKeyException extends AiException {
  AiNoKeyException() : super('No Claude API key configured');
}

class AiOfflineException extends AiException {
  AiOfflineException() : super('No internet connection');
}

class ClaudeUsage {
  int inputTokens;
  int outputTokens;
  int cacheReadTokens;
  int cacheWriteTokens;
  ClaudeUsage({this.inputTokens = 0, this.outputTokens = 0, this.cacheReadTokens = 0, this.cacheWriteTokens = 0});

  void mergeFromJson(Map<String, dynamic>? u) {
    if (u == null) return;
    int v(String k) => (u[k] as num?)?.toInt() ?? 0;
    if (u.containsKey('input_tokens')) inputTokens = v('input_tokens');
    if (u.containsKey('output_tokens')) outputTokens = v('output_tokens');
    if (u.containsKey('cache_read_input_tokens')) cacheReadTokens = v('cache_read_input_tokens');
    if (u.containsKey('cache_creation_input_tokens')) cacheWriteTokens = v('cache_creation_input_tokens');
  }
}

/// A complete Messages API response (raw content blocks kept for tool loops).
class ClaudeResponse {
  final String model;
  final List<Map<String, dynamic>> content;
  final String? stopReason;
  final ClaudeUsage usage;
  ClaudeResponse({required this.model, required this.content, required this.stopReason, required this.usage});

  String get text => content.where((b) => b['type'] == 'text').map((b) => b['text'] as String? ?? '').join();

  List<Map<String, dynamic>> get toolUses => content.where((b) => b['type'] == 'tool_use').toList();

  bool get isRefusal => stopReason == 'refusal';
}

/// Streaming events surfaced to callers.
sealed class ClaudeStreamEvent {}

class TextDelta extends ClaudeStreamEvent {
  final String text;
  TextDelta(this.text);
}

class StreamDone extends ClaudeStreamEvent {
  final ClaudeResponse response;
  StreamDone(this.response);
}

/// Thin raw-HTTP client for POST /v1/messages (no official Dart SDK exists).
class ClaudeClient {
  final String apiKey;
  final http.Client _http;
  final Duration timeout;

  ClaudeClient(this.apiKey, {http.Client? httpClient, this.timeout = const Duration(minutes: 5)})
    : _http = httpClient ?? http.Client();

  Map<String, String> _headers(Map<String, dynamic> body) {
    final betas = <String>[];
    if (body.containsKey('fallbacks')) betas.add(AiDefaults.fallbackBeta);
    return {
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'anthropic-version': AiDefaults.apiVersion,
      if (betas.isNotEmpty) 'anthropic-beta': betas.join(','),
    };
  }

  Future<ClaudeResponse> create(Map<String, dynamic> body) async {
    http.Response res;
    try {
      res = await _http
          .post(Uri.parse(AiDefaults.apiUrl), headers: _headers(body), body: jsonEncode(body))
          .timeout(timeout);
    } on SocketException {
      throw AiOfflineException();
    } on http.ClientException catch (e) {
      throw AiException('Network error: ${e.message}');
    } on TimeoutException {
      throw AiException('Request timed out');
    } on HandshakeException catch (e) {
      throw AiException('Network error: ${e.message}');
    } on HttpException catch (e) {
      throw AiException('Network error: ${e.message}');
    }
    final decoded = _decode(res.bodyBytes);
    if (res.statusCode != 200) {
      throw AiException(_errorMessage(decoded) ?? 'HTTP ${res.statusCode}', statusCode: res.statusCode);
    }
    final usage = ClaudeUsage()..mergeFromJson(decoded['usage'] as Map<String, dynamic>?);
    return ClaudeResponse(
      model: decoded['model'] as String? ?? body['model'] as String,
      content: ((decoded['content'] as List?) ?? const []).cast<Map<String, dynamic>>(),
      stopReason: decoded['stop_reason'] as String?,
      usage: usage,
    );
  }

  /// Streams a response (SSE). Yields text deltas and finally a [StreamDone]
  /// with the assembled content blocks (text + tool_use with parsed input).
  Stream<ClaudeStreamEvent> stream(Map<String, dynamic> body) async* {
    final req = http.Request('POST', Uri.parse(AiDefaults.apiUrl))
      ..headers.addAll(_headers(body))
      ..body = jsonEncode({...body, 'stream': true});
    http.StreamedResponse res;
    try {
      res = await _http.send(req).timeout(const Duration(seconds: 60));
    } on SocketException {
      throw AiOfflineException();
    } on http.ClientException catch (e) {
      throw AiException('Network error: ${e.message}');
    } on TimeoutException {
      throw AiException('Request timed out');
    }
    if (res.statusCode != 200) {
      final bytes = await res.stream.toBytes();
      throw AiException(_errorMessage(_decode(bytes)) ?? 'HTTP ${res.statusCode}', statusCode: res.statusCode);
    }

    final usage = ClaudeUsage();
    final blocks = <int, Map<String, dynamic>>{};
    final jsonBuf = <int, StringBuffer>{};
    String model = body['model'] as String;
    String? stopReason;

    final lines = res.stream.transform(utf8.decoder).transform(const LineSplitter());
    await for (final line in lines) {
      if (!line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data.isEmpty) continue;
      Map<String, dynamic> ev;
      try {
        ev = jsonDecode(data) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }
      switch (ev['type']) {
        case 'message_start':
          final m = ev['message'] as Map<String, dynamic>;
          model = m['model'] as String? ?? model;
          usage.mergeFromJson(m['usage'] as Map<String, dynamic>?);
        case 'content_block_start':
          final i = ev['index'] as int;
          blocks[i] = Map<String, dynamic>.from(ev['content_block'] as Map);
          if (blocks[i]!['type'] == 'tool_use') jsonBuf[i] = StringBuffer();
        case 'content_block_delta':
          final i = ev['index'] as int;
          final d = ev['delta'] as Map<String, dynamic>;
          switch (d['type']) {
            case 'text_delta':
              final t = d['text'] as String;
              blocks[i]?['text'] = '${blocks[i]?['text'] ?? ''}$t';
              yield TextDelta(t);
            case 'input_json_delta':
              jsonBuf[i]?.write(d['partial_json'] as String? ?? '');
            case 'thinking_delta':
              blocks[i]?['thinking'] = '${blocks[i]?['thinking'] ?? ''}${d['thinking'] ?? ''}';
            case 'signature_delta':
              blocks[i]?['signature'] = d['signature'];
          }
        case 'content_block_stop':
          final i = ev['index'] as int;
          if (jsonBuf.containsKey(i)) {
            final raw = jsonBuf[i].toString();
            try {
              blocks[i]?['input'] = raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw);
            } catch (_) {
              blocks[i]?['input'] = <String, dynamic>{};
              blocks[i]?['_invalid_json'] = true;
            }
          }
        case 'message_delta':
          final d = ev['delta'] as Map<String, dynamic>?;
          stopReason = d?['stop_reason'] as String? ?? stopReason;
          usage.mergeFromJson(ev['usage'] as Map<String, dynamic>?);
        case 'error':
          final err = ev['error'] as Map<String, dynamic>?;
          throw AiException(err?['message'] as String? ?? 'Stream error');
      }
    }
    final ordered = (blocks.keys.toList()..sort()).map((k) => blocks[k]!).toList();
    yield StreamDone(ClaudeResponse(model: model, content: ordered, stopReason: stopReason, usage: usage));
  }

  Map<String, dynamic> _decode(List<int> bytes) {
    try {
      return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  String? _errorMessage(Map<String, dynamic> j) => (j['error'] as Map<String, dynamic>?)?['message'] as String?;

  void close() => _http.close();
}
