import 'dart:io';

import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/network/accela_services.dart';

class AttachmentRepository {
  static Future<ActionObject> deleteDocument(String recordId, String documentNumber, bool isUseAnonymousToken) async {
    return await AccelaServiceManager.deleteDocument(recordId, documentNumber, useAnonymousToken: isUseAnonymousToken);
  }

  static deleteEntityDocument(DocumentEntityType entityType, String documentNumber,
      {String? recordId, int? inspectionId, bool useAnonymousToken = false}) async {
    return await AccelaServiceManager.deleteEntityDocument(entityType, documentNumber,
        recordId: recordId, inspectionId: inspectionId, useAnonymousToken: useAnonymousToken);
  }

  static Future<ActionObject> updateDocument(String customId, Attachment attachment, bool isUseAnonymousToken) async {
    return await AccelaServiceManager.emseRequest('updateDocument', {"customId": customId, "doc": attachment.toMap()});
  }

  static Future<ActionObject> downloadDocument(String documentNo, String saveFileName, bool isUseAnonymousToken) async {
    return await AccelaServiceManager.downloadAttachment(documentNo, saveFileName, useAnonymousToken: isUseAnonymousToken);
  }

  static Future<ActionObject> uploadDocument(String recordId, File file, String group, String category, String description, Function(int, int) sendProgress,
      {bool useAnonymousToken = false}) async {
    return await AccelaServiceManager.uploadDocument(recordId, file, group, category, description, sendProgress, useAnonymousToken: useAnonymousToken);
  }

  static Future<ActionObject> uploadEntityDocument(DocumentEntityType entityType, File file,
      {String? recordId,
      int? inspectionId,
      String? checklistId,
      String? checklistItemId,
      bool useAnonymousToken = false,
      String group = "",
      String category = "",
      String description = "",
      Function(int, int)? sendProgress}) async {
    return await AccelaServiceManager.uploadEntityDocument(entityType, file,
        group: group,
        category: category,
        description: description,
        sendProgress: sendProgress,
        recordId: recordId,
        inspectionId: inspectionId,
        checklistId: checklistId,
        checklistItemId: checklistItemId,
        useAnonymousToken: useAnonymousToken);
  }

  static Future<List<Attachment>> getInspectionDocuments(String customId, int idNumber, {bool useAnonymousToken = false}) async {
    List<Attachment> attachments = [];

    var dataResult =
        await AccelaServiceManager.emseRequest('getInspectionDocuments', {"customId": customId, "idNumber": idNumber}, useAnonymousToken: useAnonymousToken);
    if (dataResult.success) {
      attachments = List<Attachment>.from(dataResult.content?.map((x) => Attachment.fromMap(x)));
    }

    return attachments;
  }

  static Future<List<Attachment>> getChecklistItemDocuments(String customId, int idNumber, String checklistId, String checklistItemId,
      {bool useAnonymousToken = false}) async {
    List<Attachment> attachments = [];

    var dataResult = await AccelaServiceManager.emseRequest(
        'getChecklistItemDocuments',
        {
          "customId": customId,
          "idNumber": idNumber,
          "checklistId": checklistId,
          "checklistItemId": checklistItemId,
        },
        useAnonymousToken: useAnonymousToken);
    if (dataResult.success) {
      attachments = List<Attachment>.from(dataResult.content?.map((x) => Attachment.fromMap(x)));
    }

    return attachments;
  }
}
