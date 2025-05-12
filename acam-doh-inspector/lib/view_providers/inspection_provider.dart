import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/checklist.dart';
import 'package:aca_mobile_app/data_models/checklist_item.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/inspection_with_config.dart';
import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/description/checklist_item_status_group_item.dart';
import 'package:aca_mobile_app/description/inspection_description.dart';
import 'package:aca_mobile_app/description/inspection_result_group_item.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/providers/error_message_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/repositories/attachment_repository.dart';
import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_data_objects/department_user.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:aca_mobile_app/view_providers/checklist_item_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_record_view_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:aca_mobile_app/views/draw_view2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:collection/collection.dart';

enum ChecklistItemsSortBy {
  order("Display Order"),
  text("Title"),
  status("Status");

  const ChecklistItemsSortBy(this.title);
  final String title;

  static List<String> get valuesAsStrings => ChecklistItemsSortBy.values.map<String>((e) => e.title).toList();
  static ChecklistItemsSortBy valueFromString(String value) {
    return ChecklistItemsSortBy.values.firstWhere((e) => e.title == value);
  }
}

class InspectionProvider extends ChangeNotifier implements AcamListManagerProvider<ChecklistItemsSortBy>, AttachmentObserver {
  InspectionProvider(this.customId, this.idNumber, this.userType, {this.parentRecordProvider});

  bool checklistItemListExpanded = true;
  TextEditingController commentController = TextEditingController();
  String customId;
  int idNumber;
  final infoMessageProvider = ChangeNotifierProvider((ref) {
    final themeNotifier = ref.watch(themeProvider);
    return InfoMessageProvider(themeNotifier);
  });

  Inspection? inspection;
  String inspectionCancelComment = "";
  String assignedInspector = "";
  bool isReassigningInspector = false;
  InspectionDescription? inspectionDescription;
  String inspectionResult = "";
  String inspectionResultComment = "";
  PainterController inspectorPainterController = _newController();
  bool inspectorSignatureUploaded = false;
  bool isLoading = false;
  bool isSaving = false;
  PainterController otherPartyPainterController = _newController();
  bool otherPartySignatureUploaded = false;
  InspectionRecordProvider? parentRecordProvider;
  ChangeNotifierProviderRef<Object?>? ref;
  Map<int, Map<int, ChangeNotifierProvider<ChecklistItemProvider>>> checklistItemProviders = {};
  final scrollController = AutoScrollController(
    axis: Axis.vertical,
  );
  bool isExpanded = true;

  String getDisplayInspectionType() {
    return inspection?.getDisplayInspectionType() ?? "";
  }

  String getFriendlyInspectionStatus() {
    if (inspection?.documentDescription == "Insp Completed") {
      return "Completed".tr();
    } else if (inspection?.documentDescription == "Insp Scheduled") {
      return "Scheduled".tr();
    } else if (inspection?.documentDescription == "Insp Cancelled") {
      return "Cancelled".tr();
    } else {
      return "NA".tr();
    }
  }

  setExpanded(bool expanded) {
    isExpanded = expanded;
    notifyListeners();
  }

  double uploadProgress = 0.0;
  String userType;

  final TextEditingController _filterController = TextEditingController();
  String _filterText = "";
  ChecklistItemsSortBy _sortBy = ChecklistItemsSortBy.order;
  AcamListManagerSortByOrder _sortByOrder = AcamListManagerSortByOrder.asc;
  final AcamListManagerType _managerType = AcamListManagerType.sort;

  @override
  AcamListManagerType get managerType => _managerType;

  @override
  TextEditingController get filterController => _filterController;

  @override
  String get filterText => _filterText;

  @override
  set filterText(String filterText) {
    _filterText = filterText;
    notifyListeners();
  }

  @override
  List<Attachment> get getAttachments {
    return inspection?.attachments ?? [];
  }

  @override
  String getSortByTypeTitle(ChecklistItemsSortBy sortBy) {
    return sortBy.title.tr();
  }

  @override
  List<String> getSortByTypes() {
    return ChecklistItemsSortBy.valuesAsStrings;
  }

  @override
  set setAttachments(List<Attachment> attachments) {
    inspection?.attachments = attachments;
    notifyListeners();
  }

  @override
  ChecklistItemsSortBy get sortBy => _sortBy;

  @override
  set sortByAsString(String sortByString) {
    _sortBy = ChecklistItemsSortBy.valueFromString(sortByString);
    notifyListeners();
  }

  @override
  AcamListManagerSortByOrder get sortByOrder => _sortByOrder;

  @override
  set sortByOrder(AcamListManagerSortByOrder sortByOrder) {
    _sortByOrder = sortByOrder;
    notifyListeners();
  }

  bool isCancelable() {
    return inspection?.isCancelable ?? false;
  }

  setRef(ChangeNotifierProviderRef<Object?> ref) {
    this.ref = ref;
  }

  initProvider() async {
    await loadInspection();
    notifyListeners();
  }

  setupInspection(InspectionWithConfig inspectionWithConfig) {
    inspection = inspectionWithConfig.inspection;
    inspectionDescription = inspectionWithConfig.inspectionDescription;
    verifyChecklistItemsStatus();
    notifyListeners();
  }

  loadInspection() async {
    setLoading(true);
    var inspectionWithConfig = await InspectionRepository.getInspectionWithConfig(customId, idNumber);
    inspection = inspectionWithConfig?.inspection;
    inspectionDescription = inspectionWithConfig?.inspectionDescription;
    verifyChecklistItemsStatus();

    setLoading(false);
    notifyListeners();
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  setSaving(saving) {
    isSaving = saving;
    notifyListeners();
  }

  bool isChecklistSaved(int idx) {
    return inspection?.checklists[idx].isSaved ?? false;
  }

  setChecklistSaved(int idx, bool isSaved) {
    inspection?.checklists[idx].isSaved = isSaved;
    notifyListeners();
  }

  List<ChecklistItem> getChecklistItems(int idx) {
    List<ChecklistItem> filteredChecklistItems = [];
    if (filterText.isNotEmpty) {
      filteredChecklistItems = inspection?.checklists[idx].checklistItems ?? [];
      filteredChecklistItems = filteredChecklistItems
          .where((item) =>
              item.text.toLowerCase().contains(filterText.toLowerCase()) ||
              item.textDisp.toLowerCase().contains(filterText.toLowerCase()) ||
              item.status.toLowerCase().contains(filterText.toLowerCase()))
          .toList();
    } else {
      filteredChecklistItems = inspection?.checklists[idx].checklistItems ?? [];
    }
    if (sortBy == ChecklistItemsSortBy.order) {
      filteredChecklistItems.sort((a, b) {
        var aOrder = int.tryParse(a.displayOrder) ?? 100000;
        var bOrder = int.tryParse(b.displayOrder) ?? 100000;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? aOrder.compareTo(bOrder) : bOrder.compareTo(aOrder));
        // return (sortByOrder == AcamListManagerSortByOrder.asc ? aOrder > bOrder : bType.compareTo(aType));
      });
    } else if (sortBy == ChecklistItemsSortBy.status) {
      filteredChecklistItems.sort((a, b) {
        return (sortByOrder == AcamListManagerSortByOrder.asc ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
      });
    } else if (sortBy == ChecklistItemsSortBy.text) {
      filteredChecklistItems.sort((a, b) {
        var atitle = a.textDisp.isNotEmpty ? a.textDisp : a.text;
        var btitle = b.textDisp.isNotEmpty ? b.textDisp : b.text;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? atitle.compareTo(btitle) : btitle.compareTo(atitle));
      });
    }

    return filteredChecklistItems;
  }

  List<ChecklistItemStatusGroupItem> getChecklistItemStatusGroupItems(String checklistItemStatusGroup) {
    if (inspectionDescription == null) {
      return [];
    }
    List<ChecklistItemStatusGroupItem> arr = inspectionDescription!.checklistItemStatusGroups.containsKey(checklistItemStatusGroup)
        ? inspectionDescription!.checklistItemStatusGroups[checklistItemStatusGroup]!
        : [];

    return arr;
  }

  bool isChecklistItemStatusGroupItemsAllNumbers(String checklistItemStatusGroup) {
    List<ChecklistItemStatusGroupItem> arr = getChecklistItemStatusGroupItems(checklistItemStatusGroup);

    return arr.where((element) => !Utility.isInt(element.guideSheetItemStatus)).toList().isEmpty;
  }

  int getChecklistItemStatusGroupItemsCount(String checklistItemStatusGroup) {
    List<ChecklistItemStatusGroupItem> arr = getChecklistItemStatusGroupItems(checklistItemStatusGroup);

    return arr.length;
  }

  bool showStarRating(ChecklistItem checklistItem) {
    return checklistItem.isStatusVisible && isChecklistItemStatusGroupItemsAllNumbers(checklistItem.statusGroupName);
  }

  String getStatusAtIndex(String checklistItemStatusGroup, int index) {
    List<ChecklistItemStatusGroupItem> arr = getChecklistItemStatusGroupItems(checklistItemStatusGroup);

    return arr[index].guideSheetItemStatus;
  }

  // If a checklist item has a set status but the status is not in the list of statuses for the checklist item status group, then the status is invalid.
  // this can happen if the checklist is modified in the database after the inspection is created.
  bool isChecklistItemStatusValid(ChecklistItem checklistItem) {
    if (checklistItem.status.isEmpty) {
      return true;
    }
    List<ChecklistItemStatusGroupItem> arr = getChecklistItemStatusGroupItems(checklistItem.statusGroupName);
    return arr.any((element) => element.guideSheetItemStatus == checklistItem.status);
  }

  verifyChecklistItemsStatus() {
    if (inspection == null) {
      return;
    }
    for (var checklist in inspection!.checklists) {
      for (var checklistItem in checklist.checklistItems) {
        if (!isChecklistItemStatusValid(checklistItem)) {
          checklistItem.status = "";
        }
      }
    }
  }

  List<AsiSubgroupCompleteDescription>? getChecklistItemAsiDescription(ChecklistItem checklistItem) {
    return (inspectionDescription?.asiGroups.containsKey(checklistItem.asiGroup) ?? false) ? inspectionDescription?.asiGroups[checklistItem.asiGroup] : null;
  }

  List<AsiSubgroupCompleteDescription>? getChecklistItemAsitDescription(ChecklistItem checklistItem) {
    return (inspectionDescription?.asitGroups.containsKey(checklistItem.asiGroup) ?? false) ? inspectionDescription?.asitGroups[checklistItem.asiGroup] : null;
  }

  Map<String, Object?>? getChecklistItemAsiValues(ChecklistItem checklistItem, String subgroupName) {
    if (checklistItem.asiValues.containsKey(subgroupName)) {
      var asiValues = checklistItem.asiValues[subgroupName];
      return asiValues;
    }

    return {};
  }

  List<Map<String, Object?>>? getChecklistItemAsitValues(ChecklistItem checklistItem, String subgroupName) {
    if (checklistItem.asitValues.containsKey(subgroupName)) {
      var asitValues = checklistItem.asitValues[subgroupName];
      return asitValues;
    }

    return [];
  }

  setChecklistItemAsiValues(ChecklistItem checklistItem, String subgroupName, Map<String, Object> values) {
    if (checklistItem.asiValues.containsKey(subgroupName)) {
      checklistItem.asiValues[subgroupName] = values;
    }

    notifyListeners();
  }

  setChecklistItemAsitValues(ChecklistItem checklistItem, String subgroupName, List<Map<String, Object?>> values) {
    if (checklistItem.asitValues.containsKey(subgroupName)) {
      checklistItem.asitValues[subgroupName] = values;
    }

    notifyListeners();
  }

  setChecklistItemStatus(ChecklistItem checklistItem, String status) {
    checklistItem.status = status;
    notifyListeners();
  }

  setChecklistItemComment(ChecklistItem checklistItem, String comment) {
    if (checklistItem.comment != comment) {
      checklistItem.comment = comment;
      notifyListeners();
    }
  }

  setChecklistItemScore(ChecklistItem checklistItem, int score) {
    checklistItem.scoreEdit = score;
    notifyListeners();
  }

  saveChecklistItemScore(ChecklistItem checklistItem) {
    checklistItem.score = checklistItem.scoreEdit;
    checklistItem.scoreEdit = -1;
    notifyListeners();
  }

  discardChecklistItemScore(ChecklistItem checklistItem) {
    checklistItem.scoreEdit = -1;
  }

  setChecklistItemScoreError(ChecklistItem checklistItem, String scoreError) {
    if (checklistItem.scoreError != scoreError) {
      checklistItem.scoreError = scoreError;
      notifyListeners();
    }
  }

  Future<ActionObject> saveChecklist(int idx) async {
    setSaving(true);
    Checklist checklist = inspection!.checklists[idx];

    var res = await InspectionRepository.updateChecklistItems(customId, idNumber, checklist);

    setSaving(false);
    return res;
  }

  Future<ActionObject> updateChecklistItemAsiAsit(ChecklistItem item) async {
    setSaving(true);

    var res = await InspectionRepository.updateChecklistItemAsiAsit(item.checklistId, item.idNumber, item.asiGroup, item.asiValues, item.asitValues);

    setSaving(false);
    return res;
  }

  bool preventBarActions() {
    return isSaving;
  }

  setInspectionResult(String result) {
    inspectionResult = result;
    notifyListeners();
  }

  setInspectionResultComment(String comment) {
    inspectionResultComment = comment;
    notifyListeners();
  }

  isInspectionSelectedForResult() {
    return (inspection?.selectedForResult ?? false) && inspection?.documentDescription == "Insp Scheduled";
  }

  List<InspectionResultGroupItem> getInspectionResultGroupItems() {
    return inspectionDescription?.inspectionResultGroup ?? [];
  }

  Future<ActionObject> uploadSignatures() async {
    setSaving(true);

    if (!inspectorSignatureUploaded) {
      var signatureHasContent = inspectorPainterController.hasContent();
      if (signatureHasContent) {
        var file = await inspectorPainterController.finish().toFile("inspector-signature.png");
        var res =
            await AttachmentRepository.uploadEntityDocument(DocumentEntityType.inspection, file, inspectionId: idNumber, sendProgress: (int sent, int total) {
          setUploadProgress(sent / total);
        });
        if (!res.success) {
          return res;
        }
      }
      inspectorSignatureUploaded = true;
    }

    if (!otherPartySignatureUploaded) {
      var signatureHasContent = inspectorPainterController.hasContent();
      if (signatureHasContent) {
        var file = await otherPartyPainterController.finish().toFile("other-party-signature.png");
        var res =
            await AttachmentRepository.uploadEntityDocument(DocumentEntityType.inspection, file, inspectionId: idNumber, sendProgress: (int sent, int total) {
          setUploadProgress(sent / total);
        });
        if (!res.success) {
          return res;
        }
      }
      otherPartySignatureUploaded = true;
    }

    setSaving(false);
    return ActionObject(success: true, message: "");
  }

  Future<ActionObject> verifyAllChecklistsAreSaved() async {
    for (var i = 0; i < inspection!.checklists.length; i++) {
      var checklist = inspection!.checklists[i];
      if (!checklist.isSaved) {
        var res = await saveChecklist(i);
        if (!res.success) {
          return res;
        } else {
          checklist.isSaved = true;
        }
      }
    }

    return ActionObject(success: true, message: "");
  }

  bool inspectionResultable() {
    return areAllChecklistsComplete() && inspection?.documentDescription == "Insp Scheduled";
  }

  String getInspectionTextStatus() {
    if (inspection?.documentDescription == "Insp Completed") {
      return "Complete".tr();
    } else if (inspection?.documentDescription == "Insp Scheduled") {
      if (!areAllChecklistsComplete()) {
        return "Incomplete".tr();
      } else {
        return "";
      }
    } else if (inspection?.documentDescription == "Insp Cancelled") {
      return "Cancelled".tr();
    } else {
      return "NA".tr();
    }
  }

  bool areAllChecklistsComplete() {
    return inspection?.areAllChecklistsComplete() ?? false;
  }

  Future<ActionObject> resultInspection() async {
    if (inspectionResult.isEmpty) {
      return ActionObject(success: false, message: "Please Select an Inspection Result".tr());
    }
    var res = await uploadSignatures();
    if (!res.success) {
      return res;
    }

    res = await verifyAllChecklistsAreSaved();
    if (!res.success) {
      return res;
    }

    setSaving(true);
    res = await InspectionRepository.resultInspection(customId, idNumber, inspectionResult, inspectionResultComment, userType);

    setSaving(false);

    return res;
  }

  Future<ActionObject> cancelInspection(String comments) async {
    setSaving(true);
    // var res = await InspectionRepository.cancelInspection(customId, idNumber, comments);
    var res = await InspectionRepository.resultInspection(customId, idNumber, "Cancelled", comments, userType);

    setSaving(false);
    return res;
  }

  Future<ActionObject> reassignInspector() async {
    setSaving(true);
    var res = await InspectionRepository.resassignInspection(customId, idNumber, assignedInspector);

    setSaving(false);
    return res;
  }

  setUploadProgress(uploadProgress) {
    this.uploadProgress = uploadProgress;
    notifyListeners();
  }

  setInspectionCancelComments(String comments) {
    inspectionCancelComment = comments;
    notifyListeners();
  }

  setErrorMessage(String message) {
    ref?.read(infoMessageProvider).setErrorMessage(message);
  }

  setChecklistItemListExpanded(bool expanded) {
    checklistItemListExpanded = expanded;
    notifyListeners();
  }

  signatureUpdated() {
    notifyListeners();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 4.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  setIsReassigningInspector(bool isReassigningInspector) {
    this.isReassigningInspector = isReassigningInspector;
    notifyListeners();
  }

  setAssignedInspector(String assignedInspector) {
    this.assignedInspector = assignedInspector;
    notifyListeners();
  }

  String getAssignedInspectorForDropdown(List<DepartmentUser> inspectorList) {
    return inspectorList.firstWhereOrNull((element) => element.username == assignedInspector)?.username ?? "";
  }

  setInspectionSelectedForResult(bool selected) {
    inspection?.selectedForResult = selected;
  }

  randomFillChecklistItems(int checklistIdx) {
    var checklist = inspection?.checklists[checklistIdx];
    if (checklist == null) {
      return;
    }
    for (var checklistItem in checklist.checklistItems) {
      var statusGroupItems = getChecklistItemStatusGroupItems(checklistItem.statusGroupName);
      var randomIndex = Utility.randomInt(0, statusGroupItems.length - 1);
      var randomStatus = statusGroupItems[randomIndex].guideSheetItemStatus;
      setChecklistItemStatus(checklistItem, randomStatus);
    }
    setChecklistSaved(checklistIdx, false);
  }

  String getScheduledInspectionDate() {
    return Utility.stringDateReformat(inspection?.scheduledDate ?? "", "yyyy-MM-dd HH:mm", "dd/MM/yyyy");
  }
}
