import 'dart:convert';

import 'package:aca_mobile_app/description/drilldown.dart';
import 'package:flutter/foundation.dart';

import 'dropdown_value_description.dart';

class UnifiedFieldDescription {
  final String fieldLabel;
  final String fieldLabelDisp;
  final String labelAlias;
  final String labelAliasDisp;
  final String alternativeLabel;
  final String alternativeLabelDisp;
  final int fieldType;
  final bool required;
  final String defaultValue;
  final String defaultValueDisp;
  final int order;
  final List<DropDownValueDescription> valueList;
  final String source;
  final String unit;
  final String unitDisp;
  final String fieldId;
  final String fieldIdentifier;
  final bool readOnly;
  final bool hidden;
  final int maxLength;
  final DrillDownMapping? drillDownMapping;

  UnifiedFieldDescription(
      {required this.fieldLabel,
      required this.fieldLabelDisp,
      this.labelAlias = '',
      this.labelAliasDisp = '',
      this.alternativeLabel = '',
      this.alternativeLabelDisp = '',
      this.defaultValue = '',
      this.defaultValueDisp = '',
      this.valueList = const [],
      this.fieldType = 1,
      this.required = false,
      this.readOnly = false,
      this.hidden = false,
      this.order = 0,
      this.source = '',
      this.unit = '',
      this.unitDisp = '',
      required this.fieldId,
      required this.fieldIdentifier,
      this.maxLength = 0,
      this.drillDownMapping});

  UnifiedFieldDescription copyWith({
    String? fieldLabel,
    String? fieldLabelDisp,
    String? labelAlias,
    String? labelAliasDisp,
    String? alternativeLabel,
    String? alternativeLabelDisp,
    int? fieldType,
    bool? required,
    String? defaultValue,
    String? defaultValueDisp,
    int? order,
    List<DropDownValueDescription>? valueList,
    String? source,
    String? unit,
    String? unitDisp,
    String? fieldId,
    String? fieldIdentifier,
    bool? readOnly,
    bool? hidden,
    int? maxLength,
    DrillDownMapping? drillDownMapping,
  }) {
    return UnifiedFieldDescription(
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldLabelDisp: fieldLabelDisp ?? this.fieldLabelDisp,
      labelAlias: labelAlias ?? this.labelAlias,
      labelAliasDisp: labelAliasDisp ?? this.labelAliasDisp,
      alternativeLabel: alternativeLabel ?? this.alternativeLabel,
      alternativeLabelDisp: alternativeLabelDisp ?? this.alternativeLabelDisp,
      fieldType: fieldType ?? this.fieldType,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
      defaultValueDisp: defaultValueDisp ?? this.defaultValueDisp,
      order: order ?? this.order,
      valueList: valueList ?? this.valueList,
      source: source ?? this.source,
      unit: unit ?? this.unit,
      unitDisp: unitDisp ?? this.unitDisp,
      fieldId: fieldId ?? this.fieldId,
      fieldIdentifier: fieldIdentifier ?? this.fieldIdentifier,
      readOnly: readOnly ?? this.readOnly,
      hidden: hidden ?? this.hidden,
      maxLength: maxLength ?? this.maxLength,
      drillDownMapping: drillDownMapping ?? this.drillDownMapping,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fieldLabel': fieldLabel,
      'fieldLabelDisp': fieldLabelDisp,
      'labelAlias': labelAlias,
      'labelAliasDisp': labelAliasDisp,
      'alternativeLabel': alternativeLabel,
      'alternativeLabelDisp': alternativeLabelDisp,
      'fieldType': fieldType,
      'required': required,
      'defaultValue': defaultValue,
      'defaultValueDisp': defaultValueDisp,
      'order': order,
      'valueList': valueList,
      'source': source,
      'unit': unit,
      'unitDisp': unitDisp,
      'fieldId': fieldId,
      'fieldIdentifier': fieldIdentifier,
      'readOnly': readOnly,
      'hidden': hidden,
      'maxLength': maxLength,
      'drillDownMapping': drillDownMapping,
    };
  }

  factory UnifiedFieldDescription.fromMap(Map<String, dynamic> map) {
    return UnifiedFieldDescription(
      fieldLabel: map['fieldLabel'] ?? '',
      fieldLabelDisp: map['fieldLabelDisp'] ?? '',
      labelAlias: map['labelAlias'] ?? '',
      labelAliasDisp: map['labelAliasDisp'] ?? '',
      alternativeLabel: map['alternativeLabel'] ?? '',
      alternativeLabelDisp: map['alternativeLabelDisp'] ?? '',
      fieldType: map['fieldType']?.round() ?? 1,
      required: map['required'] ?? false,
      defaultValue: map['defaultValue'] ?? '',
      defaultValueDisp: map['defaultValueDisp'] ?? '',
      order: map['order']?.round() ?? 0,
      valueList: DropDownValueDescription.getDropDownValueFromList(map['valueList']),
      source: map['source'] ?? '',
      unit: map['unit'] ?? '',
      unitDisp: map['unitDisp'] ?? '',
      fieldId: map['fieldId'] ?? '',
      fieldIdentifier: map['fieldIdentifier'] ?? '',
      readOnly: map['readOnly'] ?? false,
      hidden: map['hidden'] ?? false,
      maxLength: map['maxLength']?.toInt()?.round() ?? 0,
      drillDownMapping: map['drillDownMapping'] != null ? DrillDownMapping.fromMap(map['drillDownMapping']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UnifiedFieldDescription.fromJson(String source) => UnifiedFieldDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnifiedFieldDescription2(fieldLabel: $fieldLabel, fieldLabelDisp: $fieldLabelDisp, labelAlias: $labelAlias, labelAliasDisp: $labelAliasDisp, alternativeLabel: $alternativeLabel, alternativeLabelDisp: $alternativeLabelDisp, fieldType: $fieldType, required: $required, defaultValue: $defaultValue, defaultValueDisp: $defaultValueDisp, order: $order, valueList: $valueList, source: $source, fieldId: $fieldId, fieldIdentifier: $fieldIdentifier, readOnly: $readOnly, maxLength: $maxLength)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnifiedFieldDescription &&
        other.fieldLabel == fieldLabel &&
        other.fieldLabelDisp == fieldLabelDisp &&
        other.labelAlias == labelAlias &&
        other.labelAliasDisp == labelAliasDisp &&
        other.alternativeLabel == alternativeLabel &&
        other.alternativeLabelDisp == alternativeLabelDisp &&
        other.fieldType == fieldType &&
        other.required == required &&
        other.defaultValue == defaultValue &&
        other.defaultValueDisp == defaultValueDisp &&
        other.order == order &&
        listEquals(other.valueList, valueList) &&
        other.source == source &&
        other.fieldId == fieldId &&
        other.fieldIdentifier == fieldIdentifier &&
        other.readOnly == readOnly &&
        other.maxLength == maxLength;
  }

  @override
  int get hashCode {
    return fieldLabel.hashCode ^
        fieldLabelDisp.hashCode ^
        labelAlias.hashCode ^
        labelAliasDisp.hashCode ^
        alternativeLabel.hashCode ^
        alternativeLabelDisp.hashCode ^
        fieldType.hashCode ^
        required.hashCode ^
        defaultValue.hashCode ^
        defaultValueDisp.hashCode ^
        order.hashCode ^
        valueList.hashCode ^
        source.hashCode ^
        fieldId.hashCode ^
        fieldIdentifier.hashCode ^
        readOnly.hashCode ^
        maxLength.hashCode;
  }
}
// class UnifiedFieldDescription2 {
//   final String fieldLabel;
//   final String dispFieldLabel;
//   final List<DropDownValueDescription> valueList;
//   final int fieldType;
//   final bool required;
//   final bool readOnly;
//   final int order;
//   final String source;
//   final String fieldId;
//   final String fieldIdentifier;
// //   bool valid = false;
// //   String value = '';
//   UnifiedFieldDescription2({
//     required this.fieldLabel,
//     required this.dispFieldLabel,
//     this.valueList = const [],
//     this.fieldType = 1,
//     this.required = false,
//     this.readOnly = false,
//     this.order = 0,
//     this.source = '',
//     required this.fieldId,
//     required this.fieldIdentifier,
//   });

//   UnifiedFieldDescription2 copyWith({
//     required String fieldLabel,
//     required String dispFieldLabel,
//     required List<DropDownValueDescription> valueList,
//     required int fieldType,
//     required bool required,
//     required int order,
//   }) {
//     return UnifiedFieldDescription2(
//       fieldLabel: fieldLabel,
//       dispFieldLabel: dispFieldLabel,
//       valueList: valueList,
//       fieldType: fieldType,
//       required: required,
//       readOnly: readOnly,
//       order: order,
//       source: source,
//       fieldId: fieldId,
//       fieldIdentifier: fieldIdentifier,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'fieldLabel': fieldLabel,
//       'dispFieldLabel': dispFieldLabel,
//       'valueList': valueList,
//       'fieldType': fieldType,
//       'required': required,
//       'readOnly': readOnly,
//       'order': order,
//       'source': source,
//       'fieldId': fieldId,
//       'fieldIdentifier': fieldIdentifier,
//     };
//   }

//   factory UnifiedFieldDescription2.fromMap(Map<String, dynamic> map) {
//     return UnifiedFieldDescription2(
//       fieldLabel: map['fieldLabel'] ?? '',
//       dispFieldLabel: map['dispFieldLabel'] ?? '',
//       valueList: DropDownValueDescription.getDropDownValueFromList(map['valueList']),
//       fieldType: map['fieldType']?.round() ?? 1,
//       required: map['required'] ?? false,
//       readOnly: map['readOnly'] ?? false,
//       order: map['order']?.round() ?? 0,
//       source: map['source'] ?? '',
//       fieldId: map['fieldId'] ?? '',
//       fieldIdentifier: map['fieldIdentifier'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UnifiedFieldDescription2.fromJson(String source) => UnifiedFieldDescription2.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'UnifiedField(fieldLabel: $fieldLabel, dispFieldLabel: $dispFieldLabel, valueList: $valueList, fieldType: $fieldType, required: $required, readOnly: $readOnly, order: $order)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is UnifiedFieldDescription2 &&
//         other.fieldLabel == fieldLabel &&
//         other.dispFieldLabel == dispFieldLabel &&
//         listEquals(other.valueList, valueList) &&
//         other.fieldType == fieldType &&
//         other.required == required &&
//         other.readOnly == readOnly &&
//         other.order == order;
//   }

//   @override
//   int get hashCode {
//     return fieldLabel.hashCode ^ dispFieldLabel.hashCode ^ valueList.hashCode ^ fieldType.hashCode ^ required.hashCode ^ order.hashCode ^ readOnly.hashCode;
//   }
// }
