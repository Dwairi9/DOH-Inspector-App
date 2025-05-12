import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/checklist.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/inspection_with_config.dart';
import 'package:aca_mobile_app/description/inspection_description.dart';
import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_record.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_result_group.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type_config.dart';
import 'package:easy_localization/easy_localization.dart';

enum InspectionDocumentDescription {
  completed("Insp Completed"),
  scheduled("Insp Scheduled"),
  cancelled("Insp Cancelled"),
  all("");

  final String stringValue;

  const InspectionDocumentDescription(this.stringValue);

  String get asString => stringValue;

  static InspectionDocumentDescription fromString(String desc) {
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

class InspectionRepository {
  static Future<List<Inspection>> getInspections(String type, String status, String inspectorId, bool getForCurrentUser, String startDate, String endDate,
      InspectionDocumentDescription documentDescription, String userType) async {
    var result = await AccelaServiceManager.emseRequest('searchInspections', {
      "type": type,
      "status": status,
      "startDate": startDate,
      "endDate": endDate,
      "documentDescription": documentDescription.asString,
      "inspectorId": inspectorId,
      "getForCurrentUser": getForCurrentUser,
      "userType": userType
    });
    if (result.success) {
      return List<Inspection>.from(result.content.map((x) => Inspection.fromMap(x)));
    }
    return [];
  }

  static Future<List<InspectionRecord>> getInspectionRecords(String type, String status, String inspectorId, bool getForCurrentUser, String startDate,
      String endDate, InspectionDocumentDescription documentDescription, String userType) async {
    var result = await AccelaServiceManager.emseRequest('searchRecordInspections', {
      "type": type,
      "status": status,
      "startDate": startDate,
      "endDate": endDate,
      "documentDescription": documentDescription.asString,
      "inspectorId": inspectorId,
      "getForCurrentUser": getForCurrentUser,
      "userType": userType
    });
    if (result.success) {
      return List<InspectionRecord>.from(result.content.map((x) => InspectionRecord.fromMap(x)));
    }
    return [];
  }

  static Future<InspectionRecord?> getInspectionRecord(String customId) async {
    var result = await AccelaServiceManager.emseRequest('getInspectionRecord', {"customId": customId});
    if (result.success) {
      return InspectionRecord.fromMap(result.content);
    }
    return null;
  }

  static Future<Inspection?> getInspection(String customId, int idNumber) async {
    var result = await AccelaServiceManager.emseRequest('getInspection', {"customId": customId, "idNumber": idNumber, "getConfig": false});
    if (result.success) {
      return Inspection.fromMap(result.content["inspection"]);
    }
    return null;
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

  static Future<ActionObject> resultInspection(String customId, int idNumber, String status, String comment, String userType) async {
    var result = await AccelaServiceManager.emseRequest(
        'resultInspection', {"customId": customId, "idNumber": idNumber, "status": status, "comment": comment, "userType": userType});
    if (result.success) {
      return ActionObject(success: true, message: "Inspection Submitted Successfully".tr());
    }
    return ActionObject(success: false, message: result.message);
  }

  static Future<ActionObject> resassignInspection(String customId, int idNumber, String userId) async {
    var result = await AccelaServiceManager.emseRequest('reassignInspection', {"customId": customId, "idNumber": idNumber, "userId": userId});
    if (result.success) {
      return ActionObject(success: true, message: "Inspection Reassigned Successfully".tr());
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
}
