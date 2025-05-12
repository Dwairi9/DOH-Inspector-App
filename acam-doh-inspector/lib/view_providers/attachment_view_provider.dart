import 'dart:io';

import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/repositories/attachment_repository.dart';
import 'package:aca_mobile_app/repositories/record_repository.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';

enum ParentComponentType { record, inspection, checklistItem }

enum AttachmenDisplayStyle { list, grid }

abstract class AttachmentObserver {
  List<Attachment> get getAttachments;
  set setAttachments(List<Attachment> attachments);
}

class AttachmentViewProvider extends BaseComponentViewProvider {
  List<Attachment> attachments = [];
  bool isLoading = false;
  bool isDeleting = false;
  bool isUploading = false;
  bool isDownloading = false;
  ActionObject downloadResult = ActionObject(success: false, message: "");
  AttachmenDisplayStyle displayStyle = AttachmenDisplayStyle.list;
  ParentComponentType parentComponentType;
  AttachmentObserver? attachmentObserver;
  RecordId? recordId;
  int inspectionId = 0;
  String checklistId = "";
  String checklistItemId = "";
  double uploadProgress = 0.0;
  bool isReadOnly = false;
  String documentGroup = "";
  String documentCategory = "";

  AttachmentViewProvider(
    this.parentComponentType, {
    this.recordId,
    this.inspectionId = 0,
    this.checklistId = "",
    this.checklistItemId = "",
    this.attachmentObserver,
    this.isReadOnly = false,
    this.documentGroup = "",
    this.documentCategory = "",
  }) : super(ComponentType.attachment) {
    attachments = attachmentObserver?.getAttachments ?? [];
    if (parentComponentType == ParentComponentType.record) {
      if (recordId?.id.isEmpty ?? true) {
        throw Exception("RecordId cannot be null for parent component type record");
      }
    } else if (parentComponentType == ParentComponentType.inspection) {
      if ((recordId?.customId.isEmpty ?? true) || inspectionId == 0) {
        throw Exception("Record Custom ID and Inspection ID cannot be empty for parent component type inspection");
      }
    } else if (parentComponentType == ParentComponentType.checklistItem) {
      if ((recordId?.customId.isEmpty ?? true) || inspectionId == 0 || checklistId.isEmpty || checklistItemId.isEmpty) {
        throw Exception("Record Custom ID, Inspection ID, Checklist ID and ChecklistItem ID cannot be empty for parent component type checklistItem");
      }
    }
  }

  loadAttachments() async {
    setLoading(true);
    if (parentComponentType == ParentComponentType.record) {
      attachments = await RecordRepository.getRecordDocuments(recordId!);
    } else if (parentComponentType == ParentComponentType.inspection) {
      attachments = await AttachmentRepository.getInspectionDocuments(recordId?.customId ?? "", inspectionId);
    } else if (parentComponentType == ParentComponentType.checklistItem) {
      attachments = await AttachmentRepository.getChecklistItemDocuments(recordId?.customId ?? "", inspectionId, checklistId, checklistItemId);
    }
    attachmentObserver?.setAttachments = attachments;

    setLoading(false);
  }

  Future<ActionObject> deleteAttachment(String documentNo) async {
    var actionObject = ActionObject(success: false, message: "Not implemented");
    setDeleting(true);
    if (parentComponentType == ParentComponentType.record) {
      actionObject = await AttachmentRepository.deleteEntityDocument(DocumentEntityType.record, documentNo, recordId: recordId?.id ?? "");
    } else if (parentComponentType == ParentComponentType.inspection) {
      actionObject = await AttachmentRepository.deleteEntityDocument(DocumentEntityType.inspection, documentNo, inspectionId: inspectionId);
    } else if (parentComponentType == ParentComponentType.checklistItem) {
      actionObject = await AttachmentRepository.deleteEntityDocument(DocumentEntityType.inspection, documentNo, inspectionId: inspectionId);
    }

    setDeleting(false);
    return actionObject;
  }

  Future<ActionObject> downloadAttachment(String documentNo, String fileName) async {
    setDownloading(true);
    downloadResult = await AttachmentRepository.downloadDocument(documentNo, fileName, false);

    setDownloading(false);
    return downloadResult;
  }

  Future<ActionObject> uploadAttachment(File file) async {
    var actionObject = ActionObject(success: false, message: "Not implemented");
    setUploading(true);
    setUploadProgress(0.0);
    if (parentComponentType == ParentComponentType.record) {
      actionObject =
          await AttachmentRepository.uploadEntityDocument(DocumentEntityType.record, file, recordId: recordId?.id ?? "", sendProgress: (int sent, int total) {
        setUploadProgress(sent / total);
      }, group: documentGroup, category: documentCategory);
    } else if (parentComponentType == ParentComponentType.inspection) {
      actionObject =
          await AttachmentRepository.uploadEntityDocument(DocumentEntityType.inspection, file, inspectionId: inspectionId, sendProgress: (int sent, int total) {
        setUploadProgress(sent / total);
      }, group: documentGroup, category: documentCategory);
    } else if (parentComponentType == ParentComponentType.checklistItem) {
      actionObject = await AttachmentRepository.uploadEntityDocument(DocumentEntityType.checklistItem, file,
          inspectionId: inspectionId, checklistId: checklistId, checklistItemId: checklistItemId, sendProgress: (int sent, int total) {
        setUploadProgress(sent / total);
      }, group: documentGroup, category: documentCategory);
    }

    setUploading(false);
    return actionObject;
  }

  setLoading(isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  setDeleting(isDeleting) {
    this.isDeleting = isDeleting;
    notifyListeners();
  }

  setUploading(isUploading) {
    this.isUploading = isUploading;
    notifyListeners();
  }

  setDownloading(isDownloading) {
    this.isDownloading = isDownloading;
    notifyListeners();
  }

  setUploadProgress(uploadProgress) {
    this.uploadProgress = uploadProgress;
    notifyListeners();
  }

  bool isPreventOperations() {
    return isLoading || isDeleting || isUploading;
  }

  @override
  Map<String, Object> getViewValues() {
    return <String, Object>{};
  }

  @override
  bool isValid() {
    return true;
  }
}
