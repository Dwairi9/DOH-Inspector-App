import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/description/dropdown_value_description.dart';
import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/providers/report_provider.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_record.dart';
import 'package:aca_mobile_app/view_providers/inspection_list_provider.dart';
import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_result_group.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_record_list_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalInspectionProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSearchingInspections = false;
  bool isSearchingRecords = false;
  int globalTabIndex = 0;
  String userType;
  List<InspectionType> inspectionTypes = [];
  List<InspectionResultGroup> inspectionResultGroups = [];
  AccelaUnifiedFormProvider? searchFormProvider;
  InspectionListProvider? inspectionListProvider;
  InspectionRecordListProvider? inspectionRecordListProvider;
  TabController? inspectionDashboardTabController;
  TabController? homeTabController;

  GlobalInspectionProvider(this.ref, this.userType) {
    reportsProvider = ChangeNotifierProvider((ref) {
      var provider = ReportsProvider();

      return provider;
    });
  }
  List<ReportDescription> inspectionReports = [];
  late ChangeNotifierProvider<ReportsProvider> reportsProvider;
  ChangeNotifierProviderRef ref;

  initProvider() async {
    await loadInspectionTypeConfigs();
    notifyListeners();
  }

  loadInspectionTypeConfigs() async {
    setLoading(true);
    var inspectionTypeConfig = await InspectionRepository.getInspectionTypeConfig();

    inspectionTypes = inspectionTypeConfig?.inspectionTypes ?? [];
    inspectionResultGroups = inspectionTypeConfig?.inspectionResultGroups ?? [];
    ref.read(reportsProvider).myReports = inspectionTypeConfig?.inspectionReports ?? [];
    ref.read(reportsProvider).defaultModule = inspectionTypeConfig?.defaultModule ?? "Building";

    setupInspectionSearchProvider();
    setLoading(false);
    notifyListeners();
  }

  searchInspections() async {
    setLoadingForSearchInspections(true);
    setLoadingForSearchRecords(true);
    String inspectionGroupType = searchFormProvider?.getFieldValueAsString("inspectionType") ?? "";
    String inspectionType = inspectionGroupType.split(" - ").last;
    String inspectionResult = searchFormProvider?.getFieldValueAsString("inspectionResult") ?? "";
    String inspectionStatus = searchFormProvider?.getFieldValueAsString("inspectionStatus") ?? "";
    String inspectionFromDate = searchFormProvider?.getFieldValueAsString("inspectionFromDate") ?? "";
    String inspectionToDate = searchFormProvider?.getFieldValueAsString("inspectionToDate") ?? "";
    inspectionDashboardTabController?.animateTo(0);

    inspectionListProvider?.setLoading(true);

    await inspectionRecordListProvider?.searchInspections(inspectionType, inspectionResult, "", true, inspectionFromDate, inspectionToDate,
            InspectionDocumentDescription.fromString(inspectionStatus), userType) ??
        Future<bool>.value(false);
    List<Inspection> inspections = [];
    for (InspectionRecord record in inspectionRecordListProvider?.records ?? []) {
      inspections.addAll(record.inspections);
    }

    inspectionListProvider?.setInspections(inspections);
    inspectionListProvider?.setLoading(false);

    setLoadingForSearchInspections(false);
    setLoadingForSearchRecords(false);
    notifyListeners();
  }

  clearSearchForm() {
    searchFormProvider?.clearValues();
    notifyListeners();
  }

  setupInspectionSearchProvider() {
    List<UnifiedFormField> fields = [];
    var dropdownValueList = inspectionTypes.map((e) {
      String text = "${e.groupNameDisp.isNotEmpty ? e.groupNameDisp : e.groupName} - ${e.typeDisp.isNotEmpty ? e.typeDisp : e.type}";
      String value = "${e.groupCode} - ${e.groupName} - ${e.type}";

      return DropDownValueDescription(text: text, value: value);
    }).toList();
    dropdownValueList = dropdownValueList.sortedBy((element) => element.text);
    var inspTypeDropdownField = UnifiedFormField("inspectionType", "Inspection Type".tr(), AccelaFieldTypes.dropdown, valueList: dropdownValueList);
    var inspStatusDropdownField = UnifiedFormField("inspectionResult", "Inspection Result".tr(), AccelaFieldTypes.dropdown, valueList: []);

    fields.add(inspTypeDropdownField);
    fields.add(inspStatusDropdownField);
    fields.add(UnifiedFormField("inspectionStatus", "Inspection Status".tr(), AccelaFieldTypes.dropdown, valueList: [
      //   DropDownValueDescription(text: "All".tr(), value: ""),
      DropDownValueDescription(text: "Scheduled Inspections".tr(), value: InspectionDocumentDescription.scheduled.asString),
      DropDownValueDescription(text: "Completed Inspections".tr(), value: InspectionDocumentDescription.completed.asString),
      DropDownValueDescription(text: "Cancelled Inspections".tr(), value: InspectionDocumentDescription.cancelled.asString)
    ]));
    fields.add(UnifiedFormField("inspectionFromDate", "Inspection From Date".tr(), AccelaFieldTypes.date));
    fields.add(UnifiedFormField("inspectionToDate", "Inspection To Date".tr(), AccelaFieldTypes.date));
    // fields.add(UnifiedFormField("assignedTo", "Assigned To".tr(), AccelaFieldTypes.date));

    searchFormProvider = AccelaUnifiedFormProvider.fromFieldList(fieldLists: fields, parentComponentKey: "search-form-key");
    searchFormProvider?.setFieldReadOnly('inspectionResult', true);
    searchFormProvider?.addFieldCallback('inspectionType', (String inspectionGroupType) async {
      List<DropDownValueDescription> valueList = [];
      if (inspectionGroupType.isNotEmpty) {
        String inspectionGroupCode = inspectionGroupType.split(" - ")[0];
        String inspectionGroup = inspectionGroupType.split(" - ")[1];
        String inspectionType = inspectionGroupType.split(" - ")[2];

        var inspectionTypeObj = inspectionTypes
            .firstWhereOrNull((element) => element.type == inspectionType && element.groupName == inspectionGroup && element.groupCode == inspectionGroupCode);

        if (inspectionTypeObj != null) {
          var inspectionResultGroup = inspectionResultGroups.firstWhereOrNull((element) => element.group == inspectionTypeObj.resultGroup);
          if (inspectionResultGroup != null) {
            valueList = inspectionResultGroup.results
                .map((e) => DropDownValueDescription(text: e.resultDisp.isNotEmpty ? e.resultDisp : e.result, value: e.result))
                .toList();
          }
        }
      }
      searchFormProvider?.setFieldDropdownValues('inspectionResult', valueList);
      searchFormProvider?.setFieldReadOnly('inspectionResult', valueList.isEmpty);
    });
    searchFormProvider?.setFieldValue("inspectionStatus", "Insp Scheduled", FieldModifySource.event);
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  setGlobalTabIndex(globalTabIndex) {
    this.globalTabIndex = globalTabIndex;
    notifyListeners();
  }

  setLoadingForSearchInspections(loading) {
    isSearchingInspections = loading;
    notifyListeners();
  }

  setLoadingForSearchRecords(loading) {
    isSearchingRecords = loading;
    notifyListeners();
  }

  bool isSearchFormInitialized() {
    return searchFormProvider != null;
  }
}

final inspectionGlobalProvider = ChangeNotifierProvider<GlobalInspectionProvider>((ref) {
  var userType = ref.watch(userSessionProvider).inspectorUserType;
  var provider = GlobalInspectionProvider(ref, userType);
  provider.initProvider();
  return provider;
});
