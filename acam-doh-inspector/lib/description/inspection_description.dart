import 'dart:convert';

import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/description/checklist_item_status_group_item.dart';
import 'package:aca_mobile_app/description/inspection_result_group_item.dart';

class InspectionDescription {
  InspectionDescription({
    required this.asiGroups,
    required this.asitGroups,
    required this.inspectionResultGroup,
    required this.checklistItemStatusGroups,
  });

  factory InspectionDescription.fromJson(String source) => InspectionDescription.fromMap(json.decode(source));

  factory InspectionDescription.fromMap(Map<String, dynamic> map) {
    return InspectionDescription(
      asiGroups: Map<String, List<AsiSubgroupCompleteDescription>>.from(map['asiGroups']?.map((k, v) => MapEntry<String, List<AsiSubgroupCompleteDescription>>(
          k, List<AsiSubgroupCompleteDescription>.from(v.map((x) => AsiSubgroupCompleteDescription.fromMap(x)))))),
      asitGroups: Map<String, List<AsiSubgroupCompleteDescription>>.from(map['asitGroups']?.map((k, v) =>
          MapEntry<String, List<AsiSubgroupCompleteDescription>>(
              k, List<AsiSubgroupCompleteDescription>.from(v.map((x) => AsiSubgroupCompleteDescription.fromMap(x)))))),
      inspectionResultGroup: List<InspectionResultGroupItem>.from(map['inspectionResultGroup']?.map((x) => InspectionResultGroupItem.fromMap(x))),
      checklistItemStatusGroups: Map<String, List<ChecklistItemStatusGroupItem>>.from(map['checklistItemStatusGroupMap']?.map((k, v) =>
          MapEntry<String, List<ChecklistItemStatusGroupItem>>(
              k, List<ChecklistItemStatusGroupItem>.from(v.map((x) => ChecklistItemStatusGroupItem.fromMap(x)))))),
    );
  }

  final Map<String, List<AsiSubgroupCompleteDescription>> asiGroups;
  final Map<String, List<AsiSubgroupCompleteDescription>> asitGroups;
  final Map<String, List<ChecklistItemStatusGroupItem>> checklistItemStatusGroups;
  final List<InspectionResultGroupItem> inspectionResultGroup;

  InspectionDescription copyWith({
    Map<String, List<AsiSubgroupCompleteDescription>>? asiGroups,
    Map<String, List<AsiSubgroupCompleteDescription>>? asitGroups,
    List<InspectionResultGroupItem>? inspectionResultGroup,
    Map<String, List<ChecklistItemStatusGroupItem>>? checklistItemStatusGroups,
  }) {
    return InspectionDescription(
      asiGroups: asiGroups ?? this.asiGroups,
      asitGroups: asitGroups ?? this.asitGroups,
      inspectionResultGroup: inspectionResultGroup ?? this.inspectionResultGroup,
      checklistItemStatusGroups: checklistItemStatusGroups ?? this.checklistItemStatusGroups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'asiGroups': asiGroups,
      'asitGroups': asitGroups,
      'inspectionResultGroup': inspectionResultGroup.map((x) => x.toMap()).toList(),
      'checklistItemStatusGroups': checklistItemStatusGroups,
    };
  }

  String toJson() => json.encode(toMap());
}
