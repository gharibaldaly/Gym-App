import 'package:flutter_test/flutter_test.dart';

/// Fails when [schema] uses a shape the Claude API rejects for tools and structured
/// outputs: an enum on a nullable type ("Enum value does not match declared type"),
/// a nullable array/object, or non-string enum values. One bad tool schema breaks
/// every request that sends it, so this is checked for every schema the app sends.
void expectApiSafeSchema(Object? schema, String name) {
  void walk(Object? node, String path) {
    if (node is Map) {
      final type = node['type'];
      if (type is List) {
        expect(node.containsKey('enum'), isFalse, reason: '$path: enum on nullable type');
        expect(type.where((t) => t == 'array' || t == 'object'), isEmpty, reason: '$path: nullable $type');
      }
      final values = node['enum'];
      if (values is List) {
        expect(values.every((v) => v is String), isTrue, reason: '$path: enum values must be strings');
        expect(type, 'string', reason: '$path: enum type');
      }
      node.forEach((k, v) => walk(v, '$path.$k'));
    } else if (node is List) {
      for (final (i, v) in node.indexed) {
        walk(v, '$path[$i]');
      }
    }
  }

  walk(schema, name);
}

/// Number of union-typed parameters ("type": [...] or anyOf) in [schemas]. The API
/// rejects a request whose tools / output schema have more than 16 of them in total.
int unionParamCount(Iterable<Object?> schemas) {
  var n = 0;
  void walk(Object? node) {
    if (node is Map) {
      if (node['type'] is List || node.containsKey('anyOf')) n++;
      node.values.forEach(walk);
    } else if (node is List) {
      node.forEach(walk);
    }
  }

  schemas.forEach(walk);
  return n;
}

const maxUnionParams = 16;
