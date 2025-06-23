import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/checklist.dart';
import 'package:aca_mobile_app/data_models/facility_information.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/inspection_with_config.dart';
import 'package:aca_mobile_app/data_models/violation.dart';
import 'package:aca_mobile_app/data_models/violation_information.dart';
import 'package:aca_mobile_app/description/inspection_description.dart';
import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_result_group.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type_config.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data_models/professional_information.dart';
import '../../data_models/violation_clause.dart';

enum AuditVisitInspectionDocumentDescription {
  completed("Insp Completed"),
  scheduled("Insp Scheduled"),
  cancelled("Insp Cancelled"),
  all("");

  final String stringValue;

  const AuditVisitInspectionDocumentDescription(this.stringValue);

  String get asString => stringValue;

  static AuditVisitInspectionDocumentDescription fromString(String desc) {
    if (desc == "Insp Completed") {
      return completed;
    } else if (desc == "Insp Scheduled") {
      return scheduled;
    } else if (desc == "Insp Cancelled") {
      return cancelled;
    } else {
      return all;
    }
  }
}

class AuditVisitsRepository {
  static Future<ActionObject<dynamic>> searchAuditVisits(String status, String inspectorId, bool getForCurrentUser, Map searchParams) async {
    var result = await AccelaServiceManager.emseRequest('searchAuditVisits', {
      "status": status,
      "inspectorId": inspectorId,
      "getForCurrentUser": getForCurrentUser,
      "searchParams": searchParams,
    });
    return result;
  }

  static Future<ActionObject<dynamic>> getAuditVisit(String customId) async {
    return await AccelaServiceManager.emseRequest('getAuditVisit', {"customId": customId});
  }

  static Future<InspectionWithConfig?> getInspectionWithConfig(String customId, int idNumber) async {
    var result = await AccelaServiceManager.emseRequest('getInspection', {"customId": customId, "idNumber": idNumber, "getConfig": true});
    if (result.success) {
      var inspection = Inspection.fromMap(result.content["inspection"]);
      var inspectionDescription = InspectionDescription.fromMap(result.content["inspectionDescription"]);
      return InspectionWithConfig(inspection: inspection, inspectionDescription: inspectionDescription);
    }
    return null;
  }

  static Future<InspectionTypeConfig?> getInspectionTypeConfig() async {
    var result = await AccelaServiceManager.emseRequest('getInspectionTypeConfig', {});
    if (result.success) {
      var inspectionTypes = List<InspectionType>.from(result.content["inspectionTypes"]?.map((x) => InspectionType.fromMap(x)));
      var resultGroups = List<InspectionResultGroup>.from(result.content["resultGroups"]?.map((x) => InspectionResultGroup.fromMap(x)));
      var inspectionReports = List<ReportDescription>.from(result.content["mobileReports"]?.map((x) => ReportDescription.fromMap(x)));
      var defaultModule = result.content["defaultModule"] ?? "";
      return InspectionTypeConfig(inspectionTypes, resultGroups, inspectionReports, defaultModule);
    }
    return null;
  }

  static Future<ActionObject> updateChecklistItems(String customId, int idNumber, Checklist checklist) async {
    var result = await AccelaServiceManager.emseRequest('updateChecklistItems', {"customId": customId, "idNumber": idNumber, "checklist": checklist.toMap()});
    if (result.success) {
      return ActionObject(success: true, message: "Checklist Items Saved Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> updateChecklistItemAsiAsit(String checklistId, String checklistItemId, String asiGroup,
      Map<String, Map<String, Object?>> asiValues, Map<String, List<Map<String, Object?>>> asits) async {
    var result = await AccelaServiceManager.emseRequest('updateChecklistItemAsiAsit',
        {"checklistId": checklistId, "checklistItemId": checklistItemId, "asiGroup": asiGroup, "asiValues": asiValues, "asits": asits});
    if (result.success) {
      return ActionObject(success: true, message: "Checklist Item ASI Saved Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> updateRecordAsiAsit(
      String customId, String asiGroup, Map<String, Map<String, Object?>> asiValues, Map<String, List<Map<String, Object?>>> asits) async {
    var result =
        await AccelaServiceManager.emseRequest('updateRecordAsiAsit', {"customId": customId, "asiGroup": asiGroup, "asiValues": asiValues, "asits": asits});
    if (result.success) {
      return ActionObject(success: true, message: "Record ASI Saved Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> resultAuditVisit(
      String customId, List<int> idNumbers, String status, String comment, String userType, String noSignatureJustification) async {
    var result = await AccelaServiceManager.emseRequest('resultAuditVisit', {
      "customId": customId,
      "idNumbers": idNumbers,
      "status": status,
      "comment": comment,
      "userType": userType,
      "noSignatureJustification": noSignatureJustification
    });
    if (result.success) {
      return ActionObject(success: true, message: "Inspection Result Submitted Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> cancelInspection(String customId, int idNumber, String comments) async {
    var result = await AccelaServiceManager.emseRequest('cancelInspection', {
      "customId": customId,
      "idNumber": idNumber,
      "comments": comments,
    });
    if (result.success) {
      return ActionObject(success: true, message: "Inspection Cancelled Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<Inspection?> getInspectionReports() async {
    var result = await AccelaServiceManager.emseRequest('getInspectionReports', {});
    if (result.success) {
      return Inspection.fromMap(result.content["inspection"]);
    }
    return null;
  }

  ///violations api calls
///

  static Future<ActionObject<dynamic>> getViolationsExistsInformation(String customId) async {
    return await AccelaServiceManager.emseRequest('getViolationFacilityInfo', {"inspectionId": customId});
  }


  //****** Submit Violation ******
  static Future<ActionObject<dynamic>> getViolationCategoryList(String userId, String lang) async {
    var result =  await AccelaServiceManager.emseRequest('getViolationCategoryList', {"userId": userId, "lang": lang});
    return result;
  }

  static Future<FacilityInformation?> getViolationFacilityInfo(String inspectionId, String userId, String lang) async {
    var result = await AccelaServiceManager.emseRequest('getViolationFacilityInfo', {"inspectionId": inspectionId, "userId": userId, "lang": lang});

    if (result.success) {
      return FacilityInformation.fromMap(result.content);
    }
    return null;
  }

  static Future<ProfessionalInformation?> getViolationProfessionalInfo(String inspectionId, String professionalLicenseNumber) async {
    var result = await AccelaServiceManager.emseRequest('getViolationProfessionalInfo', {"inspectionId": inspectionId, "professionalLicenseNumber": professionalLicenseNumber});

    if (result.success && result.content != "Success") {
      return ProfessionalInformation.fromMap(result.content);
    }

    return null;
  }

  static Future<Violation?> getViolation(String inspectionId) async{
    var result = await AccelaServiceManager.emseRequest('getViolation', {"inspectionId": inspectionId});

    if (result.success && result.content != "Success") {
      return Violation.fromMap(result.content);
    }
    return null;
  }

  static Future<ActionObject> submitViolation(ViolationInformation? violationInfo, FacilityInformation? facilityInfo,
      ProfessionalInformation? professionalInfo, List<ViolationClause> violationClauses) async {
    var result = await AccelaServiceManager.emseRequest('submitViolation',
        {
          "violationCapId": violationInfo?.violationCapId ?? "",
          "violationCustomId": violationInfo?.violationCustomId ?? "",
          "violationInformation": {
            "relatedAuditRequestNumber": violationInfo?.relatedAuditRequestNumber,
            "violationCategory": violationInfo?.category,
            "violationMode": "",
            "movedToProfile": "",
            "violationDate": violationInfo?.violationDate
          },
          "facilityInformation": {
            "facilityLicenseNumber": facilityInfo?.facilityLicenseNumber,
            "facilityNameInEnglish": facilityInfo?.facilityNameInEnglish,
            "facilityNameInArabic": facilityInfo?.facilityNameInArabic,
            "facilityCategory": facilityInfo?.facilityCategory,
            "facilityType": facilityInfo?.facilityType,
            "facilitySubType": facilityInfo?.facilitySubType,
            "facilityLicenseIssueDate": facilityInfo?.facilityLicenseIssueDate,
            "facilityLicenseExpiryDate": facilityInfo?.facilityLicenseExpiryDate,
            "Region": facilityInfo?.facilityRegion,
            "City": facilityInfo?.facilityCity,
          },
          "professionalInformation": {
            "professionalLicenseNumber": professionalInfo?.professionalLicenseNumber,
            "professionalEnglishName": professionalInfo?.professionalNameInEnglish,
            "professionalArabicName": professionalInfo?.professionalNameInArabic,
            "category": professionalInfo?.professionalCategory,
            "major": professionalInfo?.professionalMajor,
            "professional": professionalInfo?.professionalProfession,
            "professionalLicenseIssueDate": professionalInfo?.professionalLicenseIssueDate,
            "professionalLicenseExpiryDate": professionalInfo?.professionalLicenseExpiryDate
          },
          "violations": violationClauses.map((x) => x.toMap()).toList()
        });

    if (result.success) {
      return ActionObject(success: true, message: "Violation Submitted Successfully".tr(), content: result.content);
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> moveTaskToSectionHead(customId) async{
    var result = await AccelaServiceManager.emseRequest('moveTaskToSectionHead', { "customId": customId  });

    if (result.success) {
      return ActionObject(success: true, message: "Violation transferred to Section Head".tr(), content: result.content);
    }
    return ActionObject(success: false, message: result.message);
  }

  //********* Violation Clause
  static Future<ActionObject<dynamic>> getViolationClauseModeList(String userId, String lang) async {
    var result =  await AccelaServiceManager.emseRequest('getViolationModeList', {"userId": userId, "lang": lang});
    return result;
  }

  static Future<ActionObject<dynamic>> getViolationClauseTypeList(String violationMode, String userId, String lang) async {
    var result =  await AccelaServiceManager.emseRequest('getViolationTypeList', {"violationMode": violationMode, "userId": userId, "lang": lang});
    return result;
  }

  static Future<ActionObject<dynamic>> getViolationItemDetails(String? violationCategory, String? violationMode, String? violationType, String? facilityNo, String? professionalNo) async {
    var result =  await AccelaServiceManager.emseRequest('getViolationItem',
        {
          "violationMode": violationMode,
          "violationType": violationType,
          "facilityNo": facilityNo,
          "proNo": professionalNo,
          "violationCategory": violationCategory
        });

    return result;
  }
}
