import 'dart:convert';

class OfflineExpressionField {
  final String fieldName;
  final String operation;
  final String fromField;
  final String toField;
  final Map<String, String> valueMap;
  OfflineExpressionField({
    required this.fieldName,
    required this.operation,
    required this.fromField,
    required this.toField,
    required this.valueMap,
  });

  OfflineExpressionField copyWith({
    String? fieldName,
    String? operation,
    String? fromField,
    String? toField,
    Map<String, String>? valueMap,
  }) {
    return OfflineExpressionField(
      fieldName: fieldName ?? this.fieldName,
      operation: operation ?? this.operation,
      fromField: fromField ?? this.fromField,
      toField: toField ?? this.toField,
      valueMap: valueMap ?? this.valueMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'operation': operation,
      'fromField': fromField,
      'toField': toField,
      'valueMap': valueMap,
    };
  }

  factory OfflineExpressionField.fromMap(Map<String, dynamic> map) {
    return OfflineExpressionField(
      fieldName: map['fieldName'] ?? '',
      operation: map['operation'] ?? '',
      fromField: map['fromField'] ?? '',
      toField: map['toField'] ?? '',
      valueMap: Map<String, String>.from(map['valueMap'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory OfflineExpressionField.fromJson(String source) => OfflineExpressionField.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Offlineexpressiondescription(operation: $operation, fromField: $fromField, toField: $toField, valueMap: $valueMap)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfflineExpressionField &&
        other.operation == operation &&
        other.fromField == fromField &&
        other.toField == toField &&
        other.valueMap == valueMap;
  }

  @override
  int get hashCode {
    return operation.hashCode ^ fromField.hashCode ^ toField.hashCode ^ valueMap.hashCode;
  }
}
