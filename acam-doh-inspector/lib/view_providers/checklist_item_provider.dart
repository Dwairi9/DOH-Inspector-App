import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/checklist_item.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:flutter/foundation.dart';

class ChecklistItemProvider extends ChangeNotifier implements AttachmentObserver {
  ChecklistItem checklistItem;

  ChecklistItemProvider(this.checklistItem);

  @override
  set setAttachments(List<Attachment> attachments) {
    checklistItem.attachments = attachments;
    notifyListeners();
  }

  @override
  List<Attachment> get getAttachments {
    return checklistItem.attachments;
  }

  String getChecklistId() {
    return checklistItem.checklistId;
  }

  String getChecklistItemId() {
    return checklistItem.idNumber;
  }

  bool checklistItemGuidelinesExpanded() {
    return checklistItem.guidelinesExpanded;
  }

  void setChecklistItemGuidelinesExpanded(bool value) {
    checklistItem.guidelinesExpanded = value;
    notifyListeners();
  }
}
