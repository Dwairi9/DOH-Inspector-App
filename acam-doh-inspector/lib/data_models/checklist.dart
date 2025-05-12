import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'checklist_item.dart';

class Checklist {
  final String idNumber;
  final String activityNumber;
  final String guideTypeDisp;
  final String entityType;
  final String group;
  final String groupDisp;
  final String guideGroup;
  final String guideType;
  final String resId;
  bool isSaved = true;
  final List<ChecklistItem> checklistItems;
  Checklist({
    required this.idNumber,
    required this.activityNumber,
    required this.guideTypeDisp,
    required this.entityType,
    required this.group,
    required this.groupDisp,
    required this.guideGroup,
    required this.guideType,
    required this.resId,
    required this.checklistItems,
  });

  Checklist copyWith({
    String? idNumber,
    String? activityNumber,
    String? guideTypeDisp,
    String? entityType,
    String? group,
    String? groupDisp,
    String? guideGroup,
    String? guideType,
    String? resId,
    List<ChecklistItem>? checklistItems,
  }) {
    return Checklist(
      idNumber: idNumber ?? this.idNumber,
      activityNumber: activityNumber ?? this.activityNumber,
      guideTypeDisp: guideTypeDisp ?? this.guideTypeDisp,
      entityType: entityType ?? this.entityType,
      group: group ?? this.group,
      groupDisp: groupDisp ?? this.groupDisp,
      guideGroup: guideGroup ?? this.guideGroup,
      guideType: guideType ?? this.guideType,
      resId: resId ?? this.resId,
      checklistItems: checklistItems ?? this.checklistItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNumber': idNumber,
      'activityNumber': activityNumber,
      'guideTypeDisp': guideTypeDisp,
      'entityType': entityType,
      'group': group,
      'groupDisp': groupDisp,
      'guideGroup': guideGroup,
      'guideType': guideType,
      'resId': resId,
      'checklistItems': checklistItems.map((x) => x.toMap()).toList(),
    };
  }

  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      idNumber: map['idNumber'] ?? '',
      activityNumber: map['activityNumber'] ?? '',
      guideTypeDisp: map['guideTypeDisp'] ?? '',
      entityType: map['entityType'] ?? '',
      group: map['group'] ?? '',
      groupDisp: map['groupDisp'] ?? '',
      guideGroup: map['guideGroup'] ?? '',
      guideType: map['guideType'] ?? '',
      resId: map['resId'] ?? '',
      checklistItems: List<ChecklistItem>.from(map['checklistItems']?.map((x) => ChecklistItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Checklist.fromJson(String source) => Checklist.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Checklist(idNumber: $idNumber, activityNumber: $activityNumber, guideTypeDisp: $guideTypeDisp, entityType: $entityType, group: $group, guideGroup: $guideGroup, guideType: $guideType, resId: $resId, checklistItems: $checklistItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Checklist &&
        other.idNumber == idNumber &&
        other.activityNumber == activityNumber &&
        other.guideTypeDisp == guideTypeDisp &&
        other.entityType == entityType &&
        other.group == group &&
        other.guideGroup == guideGroup &&
        other.guideType == guideType &&
        other.resId == resId &&
        listEquals(other.checklistItems, checklistItems);
  }

  @override
  int get hashCode {
    return idNumber.hashCode ^
        activityNumber.hashCode ^
        guideTypeDisp.hashCode ^
        entityType.hashCode ^
        group.hashCode ^
        guideGroup.hashCode ^
        guideType.hashCode ^
        resId.hashCode ^
        checklistItems.hashCode;
  }
}
