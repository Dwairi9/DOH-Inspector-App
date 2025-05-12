import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_record.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:flutter/material.dart';

class InspectionRecordProvider extends ChangeNotifier implements AttachmentObserver {
  bool isLoading = false;
  InspectionRecord? inspectionRecord;
  String customId;
  InspectionRecordProvider(this.customId);
  bool inspectionListExpanded = true;
  bool editable = true;

  initProvider() async {
    await loadRecord();

    notifyListeners();
  }

  loadRecord() async {
    setLoading(true);
    inspectionRecord = await InspectionRepository.getInspectionRecord(customId);

    for (var inspection in inspectionRecord?.inspections ?? []) {
      inspection.isRecordInspection = true;
    }

    setLoading(false);
    notifyListeners();
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  @override
  List<Attachment> get getAttachments {
    return inspectionRecord?.attachments ?? [];
  }

  @override
  set setAttachments(List<Attachment> attachments) {
    inspectionRecord?.attachments = attachments;
    notifyListeners();
  }

  setAsiValues(String subgroupName, Map<String, Object> values) {
    if (inspectionRecord?.asiValues.containsKey(subgroupName) ?? false) {
      inspectionRecord?.asiValues[subgroupName] = values;
    }

    notifyListeners();
  }

  setAsitValues(String subgroupName, List<Map<String, Object?>> values) {
    if (inspectionRecord?.asitValues.containsKey(subgroupName) ?? false) {
      inspectionRecord?.asitValues[subgroupName] = values;
    }

    notifyListeners();
  }

  Future<ActionObject> updateRecordAsi() async {
    String asiGroup = "";
    if (inspectionRecord?.asiGroups.isNotEmpty ?? false) {
      asiGroup = inspectionRecord?.asiGroups.first.group ?? "";
    }
    var res = await InspectionRepository.updateRecordAsiAsit(customId, asiGroup, inspectionRecord?.asiValues ?? {}, {});

    return res;
  }

  Future<ActionObject> updateRecordAsit() async {
    var res = await InspectionRepository.updateRecordAsiAsit(customId, "", {}, inspectionRecord?.asitValues ?? {});

    return res;
  }

  setInspectionListExpanded(bool expanded) {
    inspectionListExpanded = expanded;
    notifyListeners();
  }
}
