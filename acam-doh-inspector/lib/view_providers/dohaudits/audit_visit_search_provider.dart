import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/description/dropdown_value_description.dart';
import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/repositories/dohaudits/audit_visits_repository.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_list_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuditVisitSearchViewType {
  search,
  results,
}

class AuditVisitSearchProvider extends ChangeNotifier implements AcamListManagerProvider<AuditVisitsSortBy> {
  bool isLoading = false;
  String userType;
  AccelaUnifiedFormProvider? searchFormProvider;

  AuditVisitSearchProvider(this.ref, this.userType);
  List<ReportDescription> inspectionReports = [];
  ChangeNotifierProviderRef ref;
  List<AuditVisit> auditVisits = [];
  AuditVisitSearchViewType viewType = AuditVisitSearchViewType.search;
  final TextEditingController _filterController = TextEditingController();
  String _filterText = "";
  AuditVisitsSortBy _sortBy = AuditVisitsSortBy.date;
  AcamListManagerSortByOrder _sortByOrder = AcamListManagerSortByOrder.desc;
  AcamListManagerType _managerType = AcamListManagerType.sort;
  Map<String, List<AuditVisit>> cachedSortedAuditVisits = {};
  String criticalErrorMessage = "";

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
  String getSortByTypeTitle(AuditVisitsSortBy sortBy) {
    return sortBy.title.tr();
  }

  @override
  List<String> getSortByTypes() {
    if (managerType == AcamListManagerType.group) {
      return AuditVisitsSortBy.valuesAsStrings.where((element) => element != "Custom ID" && element != "AuditVisit Status").toList();
    } else {
      return AuditVisitsSortBy.valuesAsStrings;
    }
  }

  @override
  AuditVisitsSortBy get sortBy => _sortBy;

  @override
  set sortByAsString(String sortByString) {
    _sortBy = AuditVisitsSortBy.valueFromString(sortByString);
    notifyListeners();
  }

  @override
  AcamListManagerSortByOrder get sortByOrder => _sortByOrder;

  @override
  set sortByOrder(AcamListManagerSortByOrder sortByOrder) {
    _sortByOrder = sortByOrder;
    notifyListeners();
  }

  @override
  AcamListManagerType get managerType => _managerType;

  initProvider() async {
    // await loadInspectionTypeConfigs();
    setupInspectionSearchProvider();
    notifyListeners();
  }

//   loadInspectionTypeConfigs() async {
//     setLoading(true);
//     var inspectionTypeConfig = await InspectionRepository.getInspectionTypeConfig();

//     inspectionTypes = inspectionTypeConfig?.inspectionTypes ?? [];
//     inspectionResultGroups = inspectionTypeConfig?.inspectionResultGroups ?? [];

//     setupInspectionSearchProvider();
//     setLoading(false);
//     notifyListeners();
//   }

  Future<ActionObject> searchInspections() async {
    setLoading(true);

    var visitStatus = searchFormProvider?.getFieldValueAsString("visitStatus") ?? "";

    var res = await AuditVisitsRepository.searchAuditVisits(visitStatus, "", true, searchFormProvider?.getValuesAsStrings() ?? {});
    if (!res.success) {
      setLoading(false);
      setCriticalErrorMessage(res.message);
      return res;
    }

    auditVisits = List<AuditVisit>.from(res.content.map((x) => AuditVisit.fromMap(x)));
    cachedSortedAuditVisits = {};
    viewType = AuditVisitSearchViewType.results;

    setLoading(false);
    notifyListeners();

    return ActionObject(success: true, message: "Search Completed Successfully".tr());
  }

  clearSearchForm() {
    searchFormProvider?.clearValues();
    notifyListeners();
  }

  backToSearch() {
    viewType = AuditVisitSearchViewType.search;
    notifyListeners();
  }

  setupInspectionSearchProvider() {
    List<UnifiedFormField> fields = [];

    fields.add(UnifiedFormField("visitStatus", "Audit Visit Status".tr(), AccelaFieldTypes.dropdown, valueList: [
      DropDownValueDescription(text: "Current".tr(), value: "scheduled"),
      DropDownValueDescription(text: "Previous".tr(), value: "past"),
    ]));
    fields.add(UnifiedFormField("Facility Name In English", "Facility Name In English".tr(), AccelaFieldTypes.text));
    fields.add(
      UnifiedFormField("Facility Type", "Facility Type".tr(), AccelaFieldTypes.dropdown, valueList: [
        DropDownValueDescription(text: "Ambulance Services".tr(), value: "Ambulance Services"),
        DropDownValueDescription(text: "Center".tr(), value: "Center"),
        DropDownValueDescription(text: "Clinic".tr(), value: "Clinic"),
        DropDownValueDescription(text: "Diagnostic Center".tr(), value: "Diagnostic Center"),
        DropDownValueDescription(text: "Dialysis Center".tr(), value: "Dialysis Center"),
        DropDownValueDescription(text: "Drug Store - Medical Store".tr(), value: "Drug Store - Medical Store"),
        DropDownValueDescription(text: "Fertilization Center (IVF)".tr(), value: "Fertilization Center (IVF)"),
        DropDownValueDescription(text: "Hospital".tr(), value: "Hospital"),
        DropDownValueDescription(text: "Medical Factory".tr(), value: "Medical Factory"),
        DropDownValueDescription(text: "Medical Transportation".tr(), value: "Medical Transportation"),
        DropDownValueDescription(text: "Medicine Transportation & Ambulance Services".tr(), value: "Medicine Transportation & Ambulance Services"),
        DropDownValueDescription(text: "Mobile Health Unit".tr(), value: "Mobile Health Unit"),
        DropDownValueDescription(text: "Pharmacy".tr(), value: "Pharmacy"),
        DropDownValueDescription(text: "Provider".tr(), value: "Provider"),
        DropDownValueDescription(text: "Provision of Health Service".tr(), value: "Provision of Health Service"),
        DropDownValueDescription(text: "Rehabilitation".tr(), value: "Rehabilitation"),
        DropDownValueDescription(text: "Scientific Office".tr(), value: "Scientific Office"),
        DropDownValueDescription(text: "TCAM".tr(), value: "TCAM"),
        DropDownValueDescription(text: "Tele-Medicine Provider".tr(), value: "Tele-Medicine Provider"),
      ]),
    );
    fields.add(
      UnifiedFormField("Facility Sub Type", "Facility Sub Type".tr(), AccelaFieldTypes.dropdown, valueList: [
        DropDownValueDescription(text: "24 Hours".tr(), value: "24 Hours"),
        DropDownValueDescription(text: "Acupuncture".tr(), value: "Acupuncture"),
        DropDownValueDescription(text: "Audiometric Shop".tr(), value: "Audiometric Shop"),
        DropDownValueDescription(text: "Ayuverda".tr(), value: "Ayuverda"),
        DropDownValueDescription(text: "Both".tr(), value: "Both"),
        DropDownValueDescription(text: "Chiropractic".tr(), value: "Chiropractic"),
        DropDownValueDescription(text: "Dental".tr(), value: "Dental"),
        DropDownValueDescription(text: "Dental Laboratory".tr(), value: "Dental Laboratory"),
        DropDownValueDescription(text: "Employment - Transferring Medical Staff".tr(), value: "Employment - Transferring Medical Staff"),
        DropDownValueDescription(text: "First Aid Post".tr(), value: "First Aid Post"),
        DropDownValueDescription(text: "General".tr(), value: "General"),
        DropDownValueDescription(text: "General Dental".tr(), value: "General Dental"),
        DropDownValueDescription(text: "Health Care Management".tr(), value: "Health Care Management"),
        DropDownValueDescription(text: "Hijama".tr(), value: "Hijama"),
        DropDownValueDescription(text: "Home Care Services".tr(), value: "Home Care Services"),
        DropDownValueDescription(text: "Homeopathy".tr(), value: "Homeopathy"),
        DropDownValueDescription(text: "Imaging and Laboratory".tr(), value: "Imaging and Laboratory"),
        DropDownValueDescription(text: "In-Patient".tr(), value: "In-Patient"),
        DropDownValueDescription(text: "Medical".tr(), value: "Medical"),
        DropDownValueDescription(text: "Medical Imaging".tr(), value: "Medical Imaging"),
        DropDownValueDescription(text: "Medical Laboratory".tr(), value: "Medical Laboratory"),
        DropDownValueDescription(text: "Medical Professional Development".tr(), value: "Medical Professional Development"),
        DropDownValueDescription(text: "Medical Transport Service".tr(), value: "Medical Transport Service"),
        DropDownValueDescription(text: "Naturopathy".tr(), value: "Naturopathy"),
        DropDownValueDescription(text: "Nursing Home".tr(), value: "Nursing Home"),
        DropDownValueDescription(text: "One Day Surgery".tr(), value: "One Day Surgery"),
        DropDownValueDescription(text: "Optical Shop".tr(), value: "Optical Shop"),
        DropDownValueDescription(text: "Osteopathy".tr(), value: "Osteopathy"),
        DropDownValueDescription(text: "Out-Patient".tr(), value: "Out-Patient"),
        DropDownValueDescription(text: "Patient Escort".tr(), value: "Patient Escort"),
        DropDownValueDescription(text: "Physiotherapy".tr(), value: "Physiotherapy"),
        DropDownValueDescription(text: "Primary Health Care".tr(), value: "Primary Health Care"),
        DropDownValueDescription(text: "Prosthetic & Orthotics".tr(), value: "Prosthetic & Orthotics"),
        DropDownValueDescription(text: "Rehabilitation".tr(), value: "Rehabilitation"),
        DropDownValueDescription(text: "School Clinic".tr(), value: "School Clinic"),
        DropDownValueDescription(text: "Specialized".tr(), value: "Specialized"),
        DropDownValueDescription(text: "Specialized Dental".tr(), value: "Specialized Dental"),
        DropDownValueDescription(text: "TCM".tr(), value: "TCM"),
        DropDownValueDescription(text: "Tele-Medicine".tr(), value: "Tele-Medicine"),
        DropDownValueDescription(text: "Unani".tr(), value: "Unani"),
        DropDownValueDescription(text: "Virtual Clinic booths".tr(), value: "Virtual Clinic booths"),
      ]),
    );
    fields.add(UnifiedFormField("Facility License Number", "Facility License Number".tr(), AccelaFieldTypes.text));

    fields.add(UnifiedFormField("Audit Type", "Audit Type".tr(), AccelaFieldTypes.dropdown, valueList: [
      DropDownValueDescription(text: "Ad Hoc".tr(), value: "Ad Hoc"),
      DropDownValueDescription(text: "Concise".tr(), value: "Concise"),
      DropDownValueDescription(text: "CTQ".tr(), value: "CTQ"),
      DropDownValueDescription(text: "Follow Up".tr(), value: "Follow Up"),
      DropDownValueDescription(text: "HFL".tr(), value: "HFL"),
      DropDownValueDescription(text: "Ranking".tr(), value: "Ranking")
    ]));
    fields.add(UnifiedFormField("Audit From Date", "Audit From Date".tr(), AccelaFieldTypes.date));
    fields.add(UnifiedFormField("Audit To Date", "Audit To Date".tr(), AccelaFieldTypes.date));

    searchFormProvider = AccelaUnifiedFormProvider.fromFieldList(fieldLists: fields, parentComponentKey: "search-form-key");
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  bool isSearchFormInitialized() {
    return searchFormProvider != null;
  }

  List<AuditVisit> getAuditVisits({AuditVisitsSortBy? auditVisitsSortBy}) {
    auditVisitsSortBy ??= sortBy;
    var sortedAuditVisits = getAuditVisitsSorted(auditVisitsSortBy: auditVisitsSortBy);
    return getAuditVisitsFiltered(sortedAuditVisits);
  }

  List<AuditVisit> getAuditVisitsSorted({AuditVisitsSortBy? auditVisitsSortBy}) {
    var sortedAuditVisits = auditVisits.toList();
    String key = "$auditVisitsSortBy-$sortByOrder";
    if (cachedSortedAuditVisits.containsKey(key)) {
      sortedAuditVisits = cachedSortedAuditVisits[key]!;
    } else {
      if (auditVisitsSortBy == AuditVisitsSortBy.date) {
        sortedAuditVisits.sort((a, b) {
          if (a.auditVisitDate.isEmpty) {
            return -1;
          } else if (b.auditVisitDate.isEmpty) {
            return 1;
          }
          DateTime aDateTime = DateFormat('MM/dd/yyyy HH:mm', 'en_US').parse("${a.auditVisitDate} ${a.auditVisitTimeFrom}");
          DateTime bDateTime = DateFormat('MM/dd/yyyy HH:mm', 'en_US').parse("${b.auditVisitDate} ${b.auditVisitTimeFrom}");
          return (sortByOrder == AcamListManagerSortByOrder.desc ? bDateTime.compareTo(aDateTime) : aDateTime.compareTo(bDateTime));
        });
      } else if (auditVisitsSortBy == AuditVisitsSortBy.type) {
        sortedAuditVisits.sort((a, b) {
          var aType = a.auditType;
          var bType = b.auditType;
          return (sortByOrder == AcamListManagerSortByOrder.asc ? aType.compareTo(bType) : bType.compareTo(aType));
        });
      } else if (auditVisitsSortBy == AuditVisitsSortBy.customId) {
        sortedAuditVisits.sort((a, b) => (sortByOrder == AcamListManagerSortByOrder.asc ? a.customId.compareTo(b.customId) : b.customId.compareTo(a.customId)));
      } else if (sortBy == AuditVisitsSortBy.facilityName) {
        sortedAuditVisits.sort((a, b) {
          var aStatus = a.facilityNameInEnglish;
          var bStatus = b.facilityNameInEnglish;
          return (sortByOrder == AcamListManagerSortByOrder.asc ? aStatus.compareTo(bStatus) : bStatus.compareTo(aStatus));
        });
      }

      cachedSortedAuditVisits[key] = sortedAuditVisits;
    }

    return sortedAuditVisits;
  }

  List<AuditVisit> getAuditVisitsFiltered(List<AuditVisit> sortedAuditVisits) {
    List<AuditVisit> filteredInspectionRecords = [];
    if (filterText.isNotEmpty) {
      filteredInspectionRecords = sortedAuditVisits
          .where((inspection) =>
              inspection.appName.toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.customId.toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.getMobileCard().anyEntriesMatch(filterText.toLowerCase()))
          .toList();
    } else {
      filteredInspectionRecords = sortedAuditVisits;
    }

    return filteredInspectionRecords;
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  setCriticalErrorMessage(String message) {
    criticalErrorMessage = message;
    notifyListeners();
  }
}

final auditVisitSearchProvider = ChangeNotifierProvider<AuditVisitSearchProvider>((ref) {
  var userType = ref.watch(userSessionProvider).inspectorUserType;
  var provider = AuditVisitSearchProvider(ref, userType);
  provider.initProvider();
  return provider;
});
