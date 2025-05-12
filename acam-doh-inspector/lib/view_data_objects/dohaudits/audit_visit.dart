import 'dart:convert';

import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/inspection_with_config.dart';
import 'package:aca_mobile_app/data_models/mobile_card.dart';
import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/utils/accela_json_parsing.dart';
import 'package:aca_mobile_app/view_data_objects/department_user.dart';

class AuditVisit {
  final String customId;
  final String recordId;
  final String recordType;
  final String recordAlias;
  final String recordAliasDisp;
  final String module;
  final String status;
  final String statusDisp;
  final String visitStatus;
  final String userRole;
  final String appName;
  final String fileDate;
  final String auditDate;
  final String address;
  final String facilityLicenseNumber;
  final String facilityNameInEnglish;
  final String auditType;
  final String facilityType;
  final String auditVisitDate;
  final String auditVisitTimeFrom;
  final bool editable;
  final bool isCurrentUserTeamLeader;
  MobileCard? mobileCard;
  final List<InspectionWithConfig> inspectionsWithConfig;
  final List<Inspection> inspections;
  final Map<String, Map<String, Object?>> asiValues;
  final Map<String, List<Map<String, Object?>>> asitValues;
  final List<AsiSubgroupCompleteDescription> asiGroups;
  final List<AsiSubgroupCompleteDescription> asitGroups;
  final Map<String, Map<String, Object?>> facilityAsiValues;
  final Map<String, List<Map<String, Object?>>> facilityAsitValues;
  final List<AsiSubgroupCompleteDescription> facilityAsiGroups;
  final List<AsiSubgroupCompleteDescription> facilityAsitGroups;
  final List<DepartmentUser> auditDepartmentInspectors;
  List<Attachment> attachments;
  AuditVisit({
    required this.customId,
    required this.recordId,
    required this.recordType,
    required this.recordAlias,
    required this.recordAliasDisp,
    required this.module,
    required this.status,
    required this.statusDisp,
    required this.visitStatus,
    required this.userRole,
    required this.appName,
    required this.address,
    required this.mobileCard,
    required this.inspectionsWithConfig,
    required this.inspections,
    required this.fileDate,
    required this.auditDate,
    required this.asiValues,
    required this.asitValues,
    required this.asiGroups,
    required this.asitGroups,
    required this.facilityAsiValues,
    required this.facilityAsitValues,
    required this.facilityAsiGroups,
    required this.facilityAsitGroups,
    required this.attachments,
    required this.editable,
    required this.facilityLicenseNumber,
    required this.facilityNameInEnglish,
    required this.auditType,
    required this.facilityType,
    required this.auditVisitDate,
    required this.auditVisitTimeFrom,
    required this.isCurrentUserTeamLeader,
    required this.auditDepartmentInspectors,
  });

  AuditVisit copyWith(
      {String? customId,
      String? recordId,
      String? recordType,
      String? recordAlias,
      String? recordAliasDisp,
      String? module,
      String? status,
      String? statusDisp,
      String? visitStatus,
      String? userRole,
      String? appName,
      String? fileDate,
      String? auditDate,
      String? address,
      String? facilityLicenseNumber,
      String? facilityNameInEnglish,
      String? auditType,
      String? facilityType,
      String? auditVisitDate,
      String? auditVisitTimeFrom,
      bool? editable,
      bool? isCurrentUserTeamLeader,
      MobileCard? mobileCard,
      Map<String, Map<String, Object?>>? asiValues,
      Map<String, List<Map<String, Object?>>>? asitValues,
      List<AsiSubgroupCompleteDescription>? asiGroups,
      List<AsiSubgroupCompleteDescription>? asitGroups,
      Map<String, Map<String, Object?>>? facilityAsiValues,
      Map<String, List<Map<String, Object?>>>? facilityAsitValues,
      List<AsiSubgroupCompleteDescription>? facilityAsiGroups,
      List<AsiSubgroupCompleteDescription>? facilityAsitGroups,
      List<InspectionWithConfig>? inspectionsWithConfig,
      List<Inspection>? inspections,
      List<DepartmentUser>? auditDepartmentInspectors,
      List<Attachment>? attachments}) {
    return AuditVisit(
      customId: customId ?? this.customId,
      recordId: recordId ?? this.recordId,
      recordType: recordType ?? this.recordType,
      recordAlias: recordAlias ?? this.recordAlias,
      recordAliasDisp: recordAliasDisp ?? this.recordAliasDisp,
      module: module ?? this.module,
      status: status ?? this.status,
      statusDisp: statusDisp ?? this.statusDisp,
      visitStatus: visitStatus ?? this.visitStatus,
      userRole: userRole ?? this.userRole,
      appName: appName ?? this.appName,
      address: address ?? this.address,
      facilityLicenseNumber: facilityLicenseNumber ?? this.facilityLicenseNumber,
      facilityNameInEnglish: facilityNameInEnglish ?? this.facilityNameInEnglish,
      auditType: auditType ?? this.auditType,
      facilityType: facilityType ?? this.facilityType,
      auditVisitDate: auditVisitDate ?? this.auditVisitDate,
      auditVisitTimeFrom: auditVisitTimeFrom ?? this.auditVisitTimeFrom,
      mobileCard: mobileCard ?? this.mobileCard,
      inspectionsWithConfig: inspectionsWithConfig ?? this.inspectionsWithConfig,
      inspections: inspections ?? this.inspections,
      fileDate: fileDate ?? this.fileDate,
      auditDate: auditDate ?? this.auditDate,
      asiValues: asiValues ?? this.asiValues,
      asitValues: asitValues ?? this.asitValues,
      asiGroups: asiGroups ?? this.asiGroups,
      asitGroups: asitGroups ?? this.asitGroups,
      facilityAsiValues: facilityAsiValues ?? this.facilityAsiValues,
      facilityAsitValues: facilityAsitValues ?? this.facilityAsitValues,
      facilityAsiGroups: facilityAsiGroups ?? this.facilityAsiGroups,
      facilityAsitGroups: facilityAsitGroups ?? this.facilityAsitGroups,
      attachments: attachments ?? this.attachments,
      auditDepartmentInspectors: auditDepartmentInspectors ?? this.auditDepartmentInspectors,
      editable: editable ?? this.editable,
      isCurrentUserTeamLeader: isCurrentUserTeamLeader ?? this.isCurrentUserTeamLeader,
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
      'visitStatus': visitStatus,
      'userRole': userRole,
      'appName': appName,
      'address': address,
      'auditVisitDate': auditVisitDate,
      'auditVisitTimeFrom': auditVisitTimeFrom,
      'facilityLicenseNumber': facilityLicenseNumber,
      'facilityNameInEnglish': facilityNameInEnglish,
      'auditType': auditType,
      'facilityType': facilityType,
      'fileDate': fileDate,
      'auditDate': auditDate,
      'editable': editable,
      'inspectionsWithConfig': inspectionsWithConfig.map((x) => x.toMap()).toList(),
      'inspections': inspections.map((x) => x.toMap()).toList(),
      'asiGroups': asiGroups,
      'asitGroups': asitGroups,
      'asiValues': asiValues,
      'asitValues': asitValues,
      'facilityAsiGroups': facilityAsiGroups,
      'facilityAsitGroups': facilityAsitGroups,
      'facilityAsiValues': facilityAsiValues,
      'facilityAsitValues': facilityAsitValues,
      'auditDepartmentInspectors': auditDepartmentInspectors,
      'mobileCard': mobileCard?.toMap(),
      'isCurrentUserTeamLeader': isCurrentUserTeamLeader,
      'attachments': attachments.map((x) => x.toMap()).toList(),
    };
  }

  factory AuditVisit.fromMap(Map<String, dynamic> map) {
    return AuditVisit(
      customId: map['customId'] ?? '',
      recordId: map['recordId'] ?? '',
      recordType: map['recordType'] ?? '',
      recordAlias: map['recordAlias'] ?? '',
      recordAliasDisp: map['recordAliasDisp'] ?? '',
      module: map['module'] ?? '',
      status: map['status'] ?? '',
      statusDisp: map['statusDisp'] ?? '',
      visitStatus: map['visitStatus'] ?? '',
      userRole: map['userRole'] ?? '',
      appName: map['appName'] ?? '',
      address: map['address'] ?? '',
      auditVisitDate: map['auditVisitDate'] ?? '',
      auditVisitTimeFrom: map['auditVisitTimeFrom'] ?? '',
      facilityLicenseNumber: map['facilityLicenseNumber'] ?? '',
      facilityNameInEnglish: map['facilityNameInEnglish'] ?? '',
      auditType: map['auditType'] ?? '',
      facilityType: map['facilityType'] ?? '',
      mobileCard: map['mobileCard'] != null ? MobileCard.fromMap(map['mobileCard']) : null,
      fileDate: map['fileDate'] ?? '',
      auditDate: map['auditDate'] ?? '',
      editable: map['editable'] ?? true,
      isCurrentUserTeamLeader: map['isCurrentUserTeamLeader'] ?? false,
      asiGroups: List<AsiSubgroupCompleteDescription>.from(map['asiGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      asitGroups: List<AsiSubgroupCompleteDescription>.from(map['asitGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      auditDepartmentInspectors: List<DepartmentUser>.from(map['auditDepartmentInspectors']?.map((x) => DepartmentUser.fromMap(x)) ?? []),
      asiValues: AccelaJsonParsing.parseAsiValues(map['asiValues']) ?? {},
      asitValues: AccelaJsonParsing.parseAsitValues(map['asitValues']) ?? {},
      facilityAsiGroups: List<AsiSubgroupCompleteDescription>.from(map['facilityAsiGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      facilityAsitGroups: List<AsiSubgroupCompleteDescription>.from(map['facilityAsitGroups']?.map((x) => AsiSubgroupCompleteDescription.fromMap(x)) ?? []),
      facilityAsiValues: AccelaJsonParsing.parseAsiValues(map['facilityAsiValues']) ?? {},
      facilityAsitValues: AccelaJsonParsing.parseAsitValues(map['facilityAsitValues']) ?? {},
      inspectionsWithConfig: map['inspectionsWithConfig'] == null
          ? []
          : List<InspectionWithConfig>.from(map['inspectionsWithConfig']?.map((x) => InspectionWithConfig.fromMap(x))),
      inspections: map['inspections'] == null ? [] : List<Inspection>.from(map['inspections']?.map((x) => Inspection.fromMap(x))),
      attachments: List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuditVisit.fromJson(String source) => AuditVisit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InspectionRecord(customId: $customId, recordId: $recordId, recordType: $recordType, recordAlias: $recordAlias, recordAliasDisp: $recordAliasDisp, module: $module, status: $status, statusDisp: $statusDisp, appName: $appName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuditVisit &&
        other.customId == customId &&
        other.recordId == recordId &&
        other.recordType == recordType &&
        other.recordAlias == recordAlias &&
        other.recordAliasDisp == recordAliasDisp &&
        other.module == module &&
        other.status == status &&
        other.statusDisp == statusDisp &&
        other.appName == appName;
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
        appName.hashCode;
  }

  String getFormattedAuditVisitDate() {
    var arr = auditVisitDate.split("/");
    if (auditVisitDate.isEmpty || arr.length != 3) {
      return auditVisitDate;
    }

    // make sure the day and month are properly padded
    String day = arr[1].padLeft(2, '0');
    String month = arr[0].padLeft(2, '0');
    String year = arr[2];
    return "$month/$day/$year";
  }

  String getDisplayRecordAlias() {
    return recordAliasDisp.isNotEmpty ? recordAliasDisp : recordAlias;
  }

  String getDisplayRecordStatus() {
    return statusDisp.isNotEmpty ? statusDisp : status;
  }

  String getDisplaySubtitle() {
    return "$customId - ${getDisplayRecordStatus()}";
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
