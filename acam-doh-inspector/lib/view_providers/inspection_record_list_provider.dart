import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_record.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum RecordsSortBy {
  date("Open Date"),
  type("Record Type"),
  status("Record Status"),
  customId("Custom ID");

  const RecordsSortBy(this.title);
  final String title;

  static List<String> get valuesAsStrings => RecordsSortBy.values.map<String>((e) => e.title).toList();
  static RecordsSortBy valueFromString(String value) {
    return RecordsSortBy.values.firstWhere((e) => e.title == value);
  }
}

class InspectionRecordListProvider extends ChangeNotifier implements AcamListManagerProvider<RecordsSortBy> {
  bool isLoading = false;
  List<InspectionRecord> records = [];
  InspectionRecordListProvider(this.userType);
  String userType;

  RecordsSortBy _sortBy = RecordsSortBy.date;
  AcamListManagerSortByOrder _sortByOrder = AcamListManagerSortByOrder.desc;
  String _filterText = "";
  final TextEditingController _filterController = TextEditingController();
  final AcamListManagerType _managerType = AcamListManagerType.sort;

  @override
  AcamListManagerType get managerType => _managerType;

  @override
  set sortByAsString(String sortByString) {
    _sortBy = RecordsSortBy.valueFromString(sortByString);
    notifyListeners();
  }

  @override
  RecordsSortBy get sortBy => _sortBy;

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
    return RecordsSortBy.valuesAsStrings;
  }

  @override
  String getSortByTypeTitle(RecordsSortBy sortBy) {
    return sortBy.title.tr();
  }

  initProvider() async {
    await loadInspections();
    notifyListeners();
  }

  loadInspections() async {
    setLoading(true);
    records = await InspectionRepository.getInspectionRecords("", "", "", true, "", "", InspectionDocumentDescription.scheduled, userType);
    initMobileCards();
    setLoading(false);
    notifyListeners();
  }

  Future<bool> searchInspections(String type, String status, String inspectorId, bool getForCurrentUser, String startDate, String endDate,
      InspectionDocumentDescription documentDescription, String userType) async {
    setLoading(true);
    records = await InspectionRepository.getInspectionRecords(type, status, inspectorId, getForCurrentUser, startDate, endDate, documentDescription, userType);
    initMobileCards();
    setLoading(false);
    notifyListeners();
    return true;
  }

  initMobileCards() {
    for (var rec in records) {
      rec.mobileCard = rec.getMobileCard();
    }
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  List<InspectionRecord> getRecords() {
    List<InspectionRecord> filteredInspectionRecords = [];
    if (filterText.isNotEmpty) {
      filteredInspectionRecords = records
          .where((inspection) =>
              inspection.recordAlias.toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.recordAliasDisp.toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.appName.toLowerCase().contains(filterText.toLowerCase()) ||
              inspection.customId.toLowerCase().contains(filterText.toLowerCase()))
          .toList();
    } else {
      filteredInspectionRecords = records;
    }
    if (sortBy == RecordsSortBy.date) {
      filteredInspectionRecords.sort((a, b) {
        DateTime aDateTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(a.fileDate);
        DateTime bDateTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(b.fileDate);
        return (sortByOrder == AcamListManagerSortByOrder.desc ? bDateTime.compareTo(aDateTime) : aDateTime.compareTo(bDateTime));
      });
    } else if (sortBy == RecordsSortBy.type) {
      filteredInspectionRecords.sort((a, b) {
        var aType = a.recordAliasDisp.isNotEmpty ? a.recordAliasDisp : a.recordAlias;
        var bType = b.recordAliasDisp.isNotEmpty ? b.recordAliasDisp : b.recordAlias;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? aType.compareTo(bType) : bType.compareTo(aType));
      });
    } else if (sortBy == RecordsSortBy.status) {
      filteredInspectionRecords.sort((a, b) {
        var aStatus = a.statusDisp.isNotEmpty ? a.statusDisp : a.status;
        var bStatus = b.statusDisp.isNotEmpty ? b.statusDisp : b.status;
        return (sortByOrder == AcamListManagerSortByOrder.asc ? aStatus.compareTo(bStatus) : bStatus.compareTo(aStatus));
      });
    } else if (sortBy == RecordsSortBy.customId) {
      filteredInspectionRecords
          .sort((a, b) => (sortByOrder == AcamListManagerSortByOrder.asc ? a.customId.compareTo(b.customId) : b.customId.compareTo(a.customId)));
    }

    return filteredInspectionRecords;
  }
}
