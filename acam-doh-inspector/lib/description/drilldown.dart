import 'dart:convert';

import 'package:aca_mobile_app/description/dropdown_value_description.dart';

class DrillDownMapping {
  final String parentField;
  final String childField;
  final List<DrillDownValueMap> valueMap;
  DrillDownMapping({
    required this.parentField,
    required this.childField,
    required this.valueMap,
  });

  DrillDownMapping copyWith({
    String? parentField,
    String? childField,
    List<DrillDownValueMap>? valueMap,
  }) {
    return DrillDownMapping(
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
      valueMap: valueMap ?? this.valueMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentField': parentField,
      'childField': childField,
      'valueMap': valueMap.map((x) => x.toMap()).toList(),
    };
  }

  factory DrillDownMapping.fromMap(Map<String, dynamic> map) {
    return DrillDownMapping(
      parentField: map['parentField'] ?? '',
      childField: map['childField'] ?? '',
      valueMap: map['valueMap'] != null ? List<DrillDownValueMap>.from(map['valueMap']?.map((x) => DrillDownValueMap.fromMap(x))) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DrillDownMapping.fromJson(String source) => DrillDownMapping.fromMap(json.decode(source));

  @override
  String toString() => 'DrillDownMapping(parentField: $parentField, childField: $childField, valueMap: $valueMap)';
}

class DrillDownValueMap {
  final String parentValue;
  final List<DropDownValueDescription> childValues;
  DrillDownValueMap({
    required this.parentValue,
    required this.childValues,
  });

  DrillDownValueMap copyWith({
    String? parentValue,
    List<DropDownValueDescription>? childValues,
  }) {
    return DrillDownValueMap(
      parentValue: parentValue ?? this.parentValue,
      childValues: childValues ?? this.childValues,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentValue': parentValue,
      'childValues': childValues.map((x) => x.toMap()).toList(),
    };
  }

  factory DrillDownValueMap.fromMap(Map<String, dynamic> map) {
    return DrillDownValueMap(
      parentValue: map['parentValue'] ?? '',
      childValues: List<DropDownValueDescription>.from(map['childValues']?.map((x) => DropDownValueDescription.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DrillDownValueMap.fromJson(String source) => DrillDownValueMap.fromMap(json.decode(source));

  @override
  String toString() => 'ValueMap(parentValue: $parentValue, childValues: $childValues)';
}
