import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/view_providers/inspection_record_view_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum InspectionsSortBy {
  date("Inspection Date"),
  type("Inspection Type"),
  status("Inspection Status"),
  customId("Custom ID");

  const InspectionsSortBy(this.title);
  final String title;

  static List<String> get valuesAsStrings => InspectionsSortBy.values.map<String>((e) => e.title).toList();
  static InspectionsSortBy valueFromString(String value) {
    return InspectionsSortBy.values.firstWhere((e) => e.title == value);
  }
}

// enum InspectionsSortByOrder { asc, desc }

class InspectionListProvider extends ChangeNotifier implements AcamListManagerProvider<InspectionsSortBy> {
  bool isLoading = false;
  List<Inspection> inspections = [];
  InspectionListProvider(this.userType, {this.parentRecordProvider});
  InspectionRecordProvider? parentRecordProvider;
  String userType;

  InspectionsSortBy _sortBy = InspectionsSortBy.date;
  AcamListManagerSortByOrder _sortByOrder = AcamListManagerSortByOrder.desc;
  String _filterText = "";
  final TextEditingController _filterController = TextEditingController();
  final AcamListManagerType _managerType = AcamListManagerType.sort;

  @override
  AcamListManagerType get managerType => _managerType;

  @override
  set sortByAsString(String sortByString) {
    _sortBy = InspectionsSortBy.valueFromString(sortByString);
    notifyListeners();
  }

  @override
  InspectionsSortBy get sortBy => _sortBy;

  @override
  set sortByOrder(AcamListManagerSortByOrder sortByOrder) {
    _sortByOrder = sortByOrder;
    notifyListeners();
  }

  @override
  AcamListManagerSortByOrder get sortByOrder => _sortByOrder;

  @override
  set filterText(String filterText) {
    _filterText = filterText;
    notifyListeners();
  }

  @override
  String get filterText => _filterText;

  @override
  TextEditingController get filterController => _filterController;

  @override
  List<String> getSortByTypes() {
    return InspectionsSortBy.valuesAsStrings;
  }

  @override
  String getSortByTypeTitle(InspectionsSortBy sortBy) {
    return sortBy.title.tr();
  }

  initProvider() async {
    await loadInspections();
    notifyListeners();
  }

  filterTextChanged() {
    notifyListeners();
  }

  loadInspections() async {
    // In case the provider is used as a child of the record provider, we use the record inspections, we don't want to load the inspections again
    if (parentRecordProvider != null) {
      return;
    }
    setLoading(true);
    inspections = await InspectionRepository.getInspections("", "", "", true, "", "", InspectionDocumentDescription.scheduled, userType);
    initMobileCards();
    setLoading(false);
    notifyListeners();
  }

  setInspections(List<Inspection> inspections) {
    this.inspections = inspections;
    initMobileCards();
    notifyListeners();
  }

  Future<bool> searchInspections(String type, String status, String inspectorId, bool getForCurrentUser, String startDate, String endDate,
      InspectionDocumentDescription documentDescription) async {
    setLoading(true);
    inspections = await InspectionRepository.getInspections(type, status, inspectorId, getForCurrentUser, startDate, endDate, documentDescription, userType);
    initMobileCards();
    setLoading(false);
    notifyListeners();
    return true;
  }

  initMobileCards() {
    for (var inspection in inspections) {
      inspection.mobileCard = inspection.getMobileCard();
    }
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  List<Inspection> getInspections() {
    List<Inspection> filteredInspections = [];
    if (filterText.isNotEmpty) {
      filteredInspections = inspections
          .where((inspection) =>
              inspection.getDisplayInspectionType().toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.getDisplayStatus().toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.getMobileCard().entries.where((element) => element.value.toLowerCase().contains(filterText.toLowerCase())).toList().isNotEmpty ||
              inspection.getMobileCard().headers.where((element) => element.toLowerCase().contains(filterText.toLowerCase())).toList().isNotEmpty ||
              inspection.getMobileCard().footers.where((element) => element.toLowerCase().contains(filterText.toLowerCase())).toList().isNotEmpty)
          .toList();
    } else {
      filteredInspections = inspections;
    }
    if (sortBy == InspectionsSortBy.date) {
      filteredInspections.sort((a, b) {
        DateTime aDateTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(a.scheduledDate);
        DateTime bDateTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(b.scheduledDate);
        return (sortByOrder == AcamListManagerSortByOrder.desc ? bDateTime.compareTo(aDateTime) : aDateTime.compareTo(bDateTime));
      });
    } else if (sortBy == InspectionsSortBy.type) {
      filteredInspections.sort((a, b) {
        var aType = a.typeDisp.isNotEmpty ? a.typeDisp : a.type;
        var bType = b.typeDisp.isNotEmpty ? b.typeDisp : b.type;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? aType.compareTo(bType) : bType.compareTo(aType));
      });
    } else if (sortBy == InspectionsSortBy.status) {
      filteredInspections.sort((a, b) {
        var aStatus = a.statusDisp.isNotEmpty ? a.statusDisp : a.status;
        var bStatus = b.statusDisp.isNotEmpty ? b.statusDisp : b.status;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? aStatus.compareTo(bStatus) : bStatus.compareTo(aStatus));
      });
    } else if (sortBy == InspectionsSortBy.customId) {
      filteredInspections.sort((a, b) => (sortByOrder == AcamListManagerSortByOrder.asc ? a.customId.compareTo(b.customId) : b.customId.compareTo(a.customId)));
    }

    return filteredInspections;
  }
}
