import 'dart:convert';

class ExpressionFieldResult {
  final bool isNumericField;
  final bool blockSubmit;
  final bool isReturn;
  final int columnCount;
  final int columnIndex;
  final int rowIndex;
  final String type;
  final String value;
  final String expressionName;
  final String label;
  final String message;
  final String name;
  final String usage;
  final String variableKey;
  final String subgroup;
  final String fieldName;
  final String readOnly;
  final String hidden;
  final String required;
  ExpressionFieldResult({
    required this.isNumericField,
    required this.blockSubmit,
    required this.isReturn,
    required this.columnCount,
    required this.columnIndex,
    required this.rowIndex,
    required this.type,
    required this.value,
    required this.expressionName,
    required this.label,
    required this.message,
    required this.name,
    required this.usage,
    required this.variableKey,
    required this.subgroup,
    required this.fieldName,
    required this.readOnly,
    required this.hidden,
    required this.required,
  });

  ExpressionFieldResult copyWith({
    bool? isNumericField,
    bool? blockSubmit,
    bool? isReturn,
    int? columnCount,
    int? columnIndex,
    int? rowIndex,
    String? type,
    String? value,
    String? expressionName,
    String? label,
    String? message,
    String? name,
    String? usage,
    String? variableKey,
    String? subgroup,
    String? fieldName,
    String? readOnly,
    String? hidden,
    String? required,
  }) {
    return ExpressionFieldResult(
      isNumericField: isNumericField ?? this.isNumericField,
      blockSubmit: blockSubmit ?? this.blockSubmit,
      isReturn: isReturn ?? this.isReturn,
      columnCount: columnCount ?? this.columnCount,
      columnIndex: columnIndex ?? this.columnIndex,
      rowIndex: rowIndex ?? this.rowIndex,
      type: type ?? this.type,
      value: value ?? this.value,
      expressionName: expressionName ?? this.expressionName,
      label: label ?? this.label,
      message: message ?? this.message,
      name: name ?? this.name,
      usage: usage ?? this.usage,
      variableKey: variableKey ?? this.variableKey,
      subgroup: subgroup ?? this.subgroup,
      fieldName: fieldName ?? this.fieldName,
      readOnly: readOnly ?? this.readOnly,
      hidden: hidden ?? this.hidden,
      required: required ?? this.required,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isNumericField': isNumericField,
      'blockSubmit': blockSubmit,
      'isReturn': isReturn,
      'columnCount': columnCount,
      'columnIndex': columnIndex,
      'rowIndex': rowIndex,
      'type': type,
      'value': value,
      'expressionName': expressionName,
      'label': label,
      'message': message,
      'name': name,
      'usage': usage,
      'variableKey': variableKey,
      'subgroup': subgroup,
      'fieldName': fieldName,
      'readOnly': readOnly,
      'hidden': hidden,
      'required': required,
    };
  }

  factory ExpressionFieldResult.fromMap(Map<String, dynamic> map) {
    return ExpressionFieldResult(
      isNumericField: map['isNumericField'],
      blockSubmit: map['blockSubmit'],
      isReturn: map['isReturn'],
      columnCount: int.parse(map['columnCount']),
      columnIndex: int.parse(map['columnIndex']),
      rowIndex: int.parse(map['rowIndex']),
      type: map['type'],
      value: map['value'],
      expressionName: map['expressionName'] ?? "",
      label: map['label'] ?? "",
      message: map['message'] ?? "",
      name: map['name'] ?? "",
      usage: map['usage'] ?? "",
      variableKey: map['variableKey'] ?? "",
      subgroup: map['subgroup'] ?? "",
      fieldName: map['fieldName'] ?? "",
      readOnly: map['readOnly'] ?? "",
      hidden: map['hidden'] ?? "",
      required: map['required'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressionFieldResult.fromJson(String source) => ExpressionFieldResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExpressionFieldResult(isNumericField: $isNumericField, blockSubmit: $blockSubmit, isReturn: $isReturn, columnCount: $columnCount, columnIndex: $columnIndex, rowIndex: $rowIndex, type: $type, value: $value, expressionName: $expressionName, label: $label, message: $message, name: $name, usage: $usage, variableKey: $variableKey, subgroup: $subgroup, fieldName: $fieldName, readOnly: $readOnly, hidden: $hidden, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpressionFieldResult &&
        other.isNumericField == isNumericField &&
        other.blockSubmit == blockSubmit &&
        other.isReturn == isReturn &&
        other.columnCount == columnCount &&
        other.columnIndex == columnIndex &&
        other.rowIndex == rowIndex &&
        other.type == type &&
        other.value == value &&
        other.expressionName == expressionName &&
        other.label == label &&
        other.message == message &&
        other.name == name &&
        other.usage == usage &&
        other.variableKey == variableKey &&
        other.subgroup == subgroup &&
        other.fieldName == fieldName &&
        other.readOnly == readOnly &&
        other.hidden == hidden &&
        other.required == required;
  }

  @override
  int get hashCode {
    return isNumericField.hashCode ^
        blockSubmit.hashCode ^
        isReturn.hashCode ^
        columnCount.hashCode ^
        columnIndex.hashCode ^
        rowIndex.hashCode ^
        type.hashCode ^
        value.hashCode ^
        expressionName.hashCode ^
        label.hashCode ^
        message.hashCode ^
        name.hashCode ^
        usage.hashCode ^
        variableKey.hashCode ^
        subgroup.hashCode ^
        fieldName.hashCode ^
        readOnly.hashCode ^
        hidden.hashCode ^
        required.hashCode;
  }
}
