import 'dart:convert';

import 'package:aca_mobile_app/description/expression_description.dart';
import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:flutter/foundation.dart';

class AsiSubgroupCompleteDescription {
  final String group;
  final String subgroupDisp;
  final String subgroup;
  final String type;
  final List<UnifiedFieldDescription> unifiedFields;
  final String permission;
  final ExpressionDescription? expressionDescription;
  AsiSubgroupCompleteDescription({
    required this.group,
    required this.subgroupDisp,
    required this.subgroup,
    required this.type,
    required this.unifiedFields,
    required this.permission,
    required this.expressionDescription,
  });

  AsiSubgroupCompleteDescription copyWith({
    String? group,
    String? subgroupDisp,
    String? subgroup,
    String? type,
    String? permission,
    List<UnifiedFieldDescription>? unifiedFields,
    ExpressionDescription? expressionDescription,
  }) {
    return AsiSubgroupCompleteDescription(
      group: group ?? this.group,
      subgroupDisp: subgroupDisp ?? this.subgroupDisp,
      subgroup: subgroup ?? this.subgroup,
      type: type ?? this.type,
      permission: permission ?? this.permission,
      unifiedFields: unifiedFields ?? this.unifiedFields,
      expressionDescription: expressionDescription ?? this.expressionDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupCode': group,
      'subgroupDisp': subgroupDisp,
      'subgroup': subgroup,
      'type': type,
      'permission': permission,
      'unifiedFields': unifiedFields.map((x) => x.toMap()).toList(),
      'expressionDescription': expressionDescription?.toMap(),
    };
  }

  factory AsiSubgroupCompleteDescription.fromMap(Map<String, dynamic> map) {
    return AsiSubgroupCompleteDescription(
        group: map['group'] ?? '',
        subgroupDisp: map['subgroupDisp'] ?? '',
        subgroup: map['subgroup'] ?? '',
        type: map['type'] ?? '',
        permission: map['permission'] ?? '',
        unifiedFields: List<UnifiedFieldDescription>.from(map['unifiedFields']?.map((x) => UnifiedFieldDescription.fromMap(x))),
        expressionDescription: map['expressions'] == null ? null : ExpressionDescription.fromMap(map['expressions'] ?? {}));
  }

  String toJson() => json.encode(toMap());

  factory AsiSubgroupCompleteDescription.fromJson(String source) => AsiSubgroupCompleteDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AsiSubgroupCompleteDescription(group: $group, subgroupDisp: $subgroupDisp, subgroup: $subgroup, type: $type, unifiedFields: $unifiedFields)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AsiSubgroupCompleteDescription &&
        other.group == group &&
        other.subgroupDisp == subgroupDisp &&
        other.subgroup == subgroup &&
        other.type == type &&
        listEquals(other.unifiedFields, unifiedFields);
  }

  @override
  int get hashCode {
    return group.hashCode ^ subgroupDisp.hashCode ^ subgroup.hashCode ^ type.hashCode ^ unifiedFields.hashCode;
  }
}
