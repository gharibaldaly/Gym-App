/// Minimal JSON-schema helpers: tightening schemas for structured outputs and
/// validating model output before it is saved.
library;

/// Returns a copy of [schema] where every object has `additionalProperties: false`
/// (required by structured outputs).
Map<String, dynamic> strictSchema(Map<String, dynamic> schema) {
  dynamic walk(dynamic node) {
    if (node is Map) {
      final m = <String, dynamic>{};
      node.forEach((k, v) => m[k as String] = walk(v));
      if (m['type'] == 'object' && !m.containsKey('additionalProperties')) {
        m['additionalProperties'] = false;
      }
      return m;
    }
    if (node is List) return node.map(walk).toList();
    return node;
  }

  return walk(schema) as Map<String, dynamic>;
}

/// Validates [value] against a subset of JSON schema (type, properties, required,
/// items, enum, minItems). Returns a list of human-readable errors (empty = valid).
List<String> validateJson(dynamic value, Map<String, dynamic> schema, [String path = r'$']) {
  final errors = <String>[];
  final type = schema['type'];
  final types = type is List ? type.cast<String>() : (type == null ? <String>[] : [type as String]);

  bool matches(String t) => switch (t) {
    'object' => value is Map,
    'array' => value is List,
    'string' => value is String,
    'number' => value is num,
    'integer' => value is int || (value is num && value == value.roundToDouble()),
    'boolean' => value is bool,
    'null' => value == null,
    _ => true,
  };

  if (types.isNotEmpty && !types.any(matches)) {
    errors.add('$path: expected ${types.join('|')}, got ${value.runtimeType}');
    return errors;
  }
  final enumValues = schema['enum'];
  if (enumValues is List && !enumValues.contains(value)) {
    errors.add('$path: value "$value" not in enum');
  }
  if (value is Map) {
    final props = (schema['properties'] as Map?)?.cast<String, dynamic>() ?? const {};
    final required = (schema['required'] as List?)?.cast<String>() ?? const [];
    for (final r in required) {
      if (!value.containsKey(r)) errors.add('$path.$r: missing');
    }
    props.forEach((k, sub) {
      if (value.containsKey(k)) {
        errors.addAll(validateJson(value[k], (sub as Map).cast<String, dynamic>(), '$path.$k'));
      }
    });
  }
  if (value is List) {
    final minItems = schema['minItems'] as int?;
    if (minItems != null && value.length < minItems) errors.add('$path: needs at least $minItems items');
    final items = schema['items'];
    if (items is Map) {
      for (var i = 0; i < value.length; i++) {
        errors.addAll(validateJson(value[i], items.cast<String, dynamic>(), '$path[$i]'));
      }
    }
  }
  return errors;
}
