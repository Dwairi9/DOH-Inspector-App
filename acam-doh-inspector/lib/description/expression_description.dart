import 'dart:convert';

class ExpressionDescription {
  final bool onLoad;
  final bool onSubmit;
  final bool onPopulate;
  final bool onAsitRowSubmit;
  final List<ExpressionField> expressionFields;
  final int viewId;
  final String? asiGroup;
  final String? asiSubgroup;
  ExpressionDescription({
    required this.onLoad,
    required this.onSubmit,
    required this.onPopulate,
    required this.onAsitRowSubmit,
    required this.expressionFields,
    required this.viewId,
    required this.asiGroup,
    required this.asiSubgroup,
  });

  ExpressionDescription copyWith({
    bool? onLoad,
    bool? onSubmit,
    bool? onPopulate,
    bool? onAsitRowSubmit,
    List<ExpressionField>? fields,
    int? viewId,
    String? asiGroup,
    String? asiSubgroup,
  }) {
    return ExpressionDescription(
      onLoad: onLoad ?? this.onLoad,
      onSubmit: onSubmit ?? this.onSubmit,
      onPopulate: onPopulate ?? this.onPopulate,
      onAsitRowSubmit: onAsitRowSubmit ?? this.onAsitRowSubmit,
      expressionFields: fields ?? expressionFields,
      viewId: viewId ?? this.viewId,
      asiGroup: asiGroup ?? this.asiGroup,
      asiSubgroup: asiSubgroup ?? this.asiSubgroup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'onLoad': onLoad,
      'onSubmit': onSubmit,
      'onPopulate': onPopulate,
      'onAsitRowSubmit': onAsitRowSubmit,
      'fields': expressionFields.map((x) => x.toMap()).toList(),
      'viewId': viewId,
      'asiGroup': asiSubgroup,
      'asiSubgroup': asiGroup,
    };
  }

  factory ExpressionDescription.fromMap(Map<String, dynamic> map) {
    return ExpressionDescription(
      onLoad: map['onLoad'],
      onSubmit: map['onSubmit'],
      onPopulate: map['onPopulate'],
      onAsitRowSubmit: map['onAsitRowSubmit'],
      expressionFields: List<ExpressionField>.from(map['fields']?.map((x) => ExpressionField.fromMap(x))),
      viewId: map['viewId']?.toInt(),
      asiGroup: map['asiGroup'],
      asiSubgroup: map['asiSubgroup'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressionDescription.fromJson(String source) => ExpressionDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExpressionDescription(onLoad: $onLoad, onSubmit: $onSubmit, fields: $expressionFields, viewId: $viewId, asiGroup: $asiGroup)';
  }
}

class ExpressionField {
  final String variableKey;
  final String subgroup;
  final String fieldName;
  ExpressionField({
    required this.variableKey,
    required this.subgroup,
    required this.fieldName,
  });

  ExpressionField copyWith({
    String? variableKey,
    String? subgroup,
    String? fieldName,
  }) {
    return ExpressionField(
      variableKey: variableKey ?? this.variableKey,
      subgroup: subgroup ?? this.subgroup,
      fieldName: fieldName ?? this.fieldName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'variableKey': variableKey,
      'subgroup': subgroup,
      'fieldName': fieldName,
    };
  }

  factory ExpressionField.fromMap(Map<String, dynamic> map) {
    return ExpressionField(
      variableKey: map['variableKey'],
      subgroup: map['subgroup'],
      fieldName: map['fieldName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressionField.fromJson(String source) => ExpressionField.fromMap(json.decode(source));

  @override
  String toString() => 'Field(variableKey: $variableKey, subgroup: $subgroup, fieldName: $fieldName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpressionField && other.variableKey == variableKey && other.subgroup == subgroup && other.fieldName == fieldName;
  }

  @override
  int get hashCode => variableKey.hashCode ^ subgroup.hashCode ^ fieldName.hashCode;
}
