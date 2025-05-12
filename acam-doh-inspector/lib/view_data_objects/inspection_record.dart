import 'dart:convert';

import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/mobile_card.dart';
import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/utils/accela_json_parsing.dart';
import 'package:flutter/foundation.dart';

class InspectionRecord {
  final String customId;
  final String recordId;
  final String recordType;
  final String recordAlias;
  final String recordAliasDisp;
  final String module;
  final String status;
  final String statusDisp;
  final String appName;
  final String fileDate;
  final String auditDate;
  final String address;
  final bool editable;
  MobileCard? mobileCard;
  final List<Inspection> inspections;
  final Map<String, Map<String, Object?>> asiValues;
  final Map<String, List<Map<String, Object?>>> asitValues;
  final List<AsiSubgroupCompleteDescription> asiGroups;
  final List<AsiSubgroupCompleteDescription> asitGroups;
  List<Attachment> attachments;
  InspectionRecord({
    required this.customId,
    required this.recordId,
    required this.recordType,
    required this.recordAlias,
    required this.recordAliasDisp,
    required this.module,
    required this.status,
    required this.statusDisp,
    required this.appName,
    required this.address,
    required this.mobileCard,
    required this.inspections,
    required this.fileDate,
    required this.auditDate,
    required this.asiValues,
    required this.asitValues,
    required this.asiGroups,
    required this.asitGroups,
    required this.attachments,
    required this.editable,
  });

  InspectionRecord copyWith(
      {String? customId,
      String? recordId,
      String? recordType,
      String? recordAlias,
      String? recordAliasDisp,
      String? module,
      String? status,
      String? statusDisp,
      String? appName,
      String? fileDate,
      String? auditDate,
      String? address,
      bool? editable,
      MobileCard? mobileCard,
      Map<String, Map<String, Object?>>? asiValues,
      Map<String, List<Map<String, Object?>>>? asitValues,
      List<AsiSubgroupCompleteDescription>? asiGroups,
      List<AsiSubgroupCompleteDescription>? asitGroups,
      List<Inspection>? inspections,
      List<Attachment>? attachments}) {
    return InspectionRecord(
      customId: customId ?? this.customId,
      recordId: recordId ?? this.recordId,
      recordType: recordType ?? this.recordType,
      recordAlias: recordAlias ?? this.recordAlias,
      recordAliasDisp: recordAliasDisp ?? this.recordAliasDisp,
      module: module ?? this.module,
      status: status ?? this.status,
      statusDisp: statusDisp ?? this.statusDisp,
      appName: appName ?? this.appName,
      address: address ?? this.address,
      mobileCard: mobileCard ?? this.mobileCard,
      inspections: inspections ?? this.inspections,
      fileDate: fileDate ?? this.fileDate,
      auditDate: auditDate ?? this.auditDate,
      asiValues: asiValues ?? this.asiValues,
      asitValues: asitValues ?? this.asitValues,
      asiGroups: asiGroups ?? this.asiGroups,
      asitGroups: asitGroups ?? this.asitGroups,
      attachments: attachments ?? this.attachments,
      editable: editable ?? this.editable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customId': customId,
      'recordId': recordId,
      'recordType': recordType,
      'recordAlias': recordAlias,
      'recordAliasDisp': recordAliasDisp,
      'module': module,
      'status': status,
      'statusDisp': statusDisp,
      'appName': appName,
      'address': address,
      'fileDate': fileDate,
      'auditDate': auditDate,
      'inspections': inspections.map((x) => x.toMap()).toList(),
      'asiGroups': asiGroups,
      'asitGroups': asitGroups,
      'asiValues': asiValues,
      'asitValues': asitValues,
      'mobileCard': mobileCard,
      'editable': editable,
      'attachments': attachments.map((x) => x.toMap()).toList(),
    };
  }

  factory InspectionRecord.fromMap(Map<String, dynamic> map) {
    return InspectionRecord(
      customId: map['customId'] ?? '',
      recordId: map['recordId'] ?? '',
      recordType: map['recordType'] ?? '',
      recordAlias: map['recordAlias'] ?? '',
      recordAliasDisp: map['recordAliasDisp'] ?? '',
      module: map['module'] ?? '',
      status: map['status'] ?? '',
      statusDisp: map['statusDisp'] ?? '',
      appName: map['appName'] ?? '',
      address: map['address'] ?? '',
      mobileCard: map['mobileCard'] != null ? MobileCard.fromMap(map['mobileCard']) : null,
      fileDate: map['fileDate'] ?? '',
      auditDate: map['auditDate'] ?? '',
      editable: map['editable'] ?? false,
      asiGroups: List<AsiSubgroupCompleteDescription>.from(map['asiGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      asitGroups: List<AsiSubgroupCompleteDescription>.from(map['asitGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      asiValues: AccelaJsonParsing.parseAsiValues(map['asiValues']) ?? {},
      asitValues: AccelaJsonParsing.parseAsitValues(map['asitValues']) ?? {},
      inspections: List<Inspection>.from(map['inspections']?.map((x) => Inspection.fromMap(x))),
      attachments: List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory InspectionRecord.fromJson(String source) => InspectionRecord.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InspectionRecord(customId: $customId, recordId: $recordId, recordType: $recordType, recordAlias: $recordAlias, recordAliasDisp: $recordAliasDisp, module: $module, status: $status, statusDisp: $statusDisp, appName: $appName, inspections: $inspections)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspectionRecord &&
        other.customId == customId &&
        other.recordId == recordId &&
        other.recordType == recordType &&
        other.recordAlias == recordAlias &&
        other.recordAliasDisp == recordAliasDisp &&
        other.module == module &&
        other.status == status &&
        other.statusDisp == statusDisp &&
        other.appName == appName &&
        listEquals(other.inspections, inspections);
  }

  @override
  int get hashCode {
    return customId.hashCode ^
        recordId.hashCode ^
        recordType.hashCode ^
        recordAlias.hashCode ^
        recordAliasDisp.hashCode ^
        module.hashCode ^
        status.hashCode ^
        statusDisp.hashCode ^
        appName.hashCode ^
        inspections.hashCode;
  }

  String getDisplayRecordAlias() {
    return recordAliasDisp.isNotEmpty ? recordAliasDisp : recordAlias;
  }

  String getDisplayRecordStatus() {
    return statusDisp.isNotEmpty ? statusDisp : status;
  }

  MobileCard getMobileCard() {
    if (mobileCard != null) {
      return mobileCard!;
    }
    MobileCard card = MobileCard.empty();
    card.headers.add(getDisplayRecordAlias());
    card.entries.add(CardEntry(value: getDisplayRecordStatus()));
    card.entries.add(CardEntry(value: fileDate, type: "date", dateFormat: "yyyy-MM-dd HH:mm:ss"));
    card.entries.add(CardEntry(value: customId));
    mobileCard = card;
    return card;
  }
}
