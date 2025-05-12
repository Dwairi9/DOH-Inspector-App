class AccelaJsonParsing {
  static Map<String, Map<String, Object?>>? parseAsiValues(Map<dynamic, dynamic>? values) {
    if (values == null) return null;
    return Map<String, Map<String, Object?>>.from(values);
  }

  static Map<String, List<Map<String, Object?>>>? parseAsitValues(Map<dynamic, dynamic>? values) {
    if (values == null) return null;
    var tables = Map<String, dynamic>.from(values).map((key, value) {
      return MapEntry(key, List<Map<String, Object?>>.from(value?.map((x) {
        return Map<String, Object?>.from(x);
      })));
    });

    // return null;
    // var valueList = List<Map<String, Object>>.from(pageComponentData['transaction']?['values']?.map((x) {
    //   return Map<String, Object>.from(x);
    // }));
    return tables;
  }
}
