import 'package:aca_mobile_app/repositories/dohaudits/audit_visits_repository.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

enum AuditVisitsSortBy {
  date("Audit Visit Date"),
  type("Audit Type"),
  facilityName("Facility Name"),
  customId("Custom ID");

  const AuditVisitsSortBy(this.title);
  final String title;

  static List<String> get valuesAsStrings => AuditVisitsSortBy.values.map<String>((e) => e.title).toList();
  static AuditVisitsSortBy valueFromString(String value) {
    return AuditVisitsSortBy.values.firstWhere((e) => e.title == value);
  }
}

enum AuditVisitsType { current, previous }

enum AuditVisitViewStyle { list, calendar }

enum AuditVisitsFitler { mine, team, leader }

class AuditVisitListProvider extends ChangeNotifier implements AcamListManagerProvider<AuditVisitsSortBy> {
  AuditVisitListProvider(this.userType, this.auditVisitsType, {this.viewStyleEnabled = false}) {
    if (auditVisitsType == AuditVisitsType.current) {
      _managerType = AcamListManagerType.group;
      _sortBy = AuditVisitsSortBy.type;
    }
  }

  DateTime? selectedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;
  bool isLoading = false;
  bool viewStyleEnabled = false;
  AuditVisitViewStyle auditVisitViewStyle = AuditVisitViewStyle.list;
  AuditVisitsFitler auditVisitsFitler = AuditVisitsFitler.mine;
  String userType;
  List<AuditVisit> auditVisits = [];
  AuditVisitsType auditVisitsType = AuditVisitsType.current;

  final TextEditingController _filterController = TextEditingController();
  String _filterText = "";
  AuditVisitsSortBy _sortBy = AuditVisitsSortBy.date;
  AcamListManagerSortByOrder _sortByOrder = AcamListManagerSortByOrder.desc;
  AcamListManagerType _managerType = AcamListManagerType.sort;
  Map<String, bool> expandedGroups = {};
  bool showTodayOnly = false;
  String criticalErrorMessage = "";
  Map<String, List<String>> cachedSortedGroups = {};
  Map<String, List<AuditVisit>> cachedSortedAuditVisits = {};

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
    // auditVisits = await OfflineUtil.getAuditVisits();
    notifyListeners();
    await loadInspections();
    notifyListeners();
  }

  loadInspections() async {
    setLoading(true);
    setCriticalErrorMessage("");
    String status = auditVisitsType == AuditVisitsType.current ? "scheduled" : "past";
    var res = await AuditVisitsRepository.searchAuditVisits(status, "", true, {});
    if (!res.success) {
      setLoading(false);
      setCriticalErrorMessage(res.message);
      return;
    }
    auditVisits = List<AuditVisit>.from(res.content.map((x) => AuditVisit.fromMap(x)));
    // OfflineUtil.setAuditVisits(auditVisits);
    cachedSortedGroups = {};
    cachedSortedAuditVisits = {};
    initMobileCards();
    setLoading(false);
    notifyListeners();
  }

  initVisitGroups() {}

  initMobileCards() {
    for (var rec in auditVisits) {
      rec.mobileCard = rec.getMobileCard();
    }
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  bool isGroupExpanded(String groupName) {
    return expandedGroups.containsKey(groupName) ? expandedGroups[groupName]! : true;
  }

  setGroupExpanded(String groupName, bool expanded) {
    expandedGroups[groupName] = expanded;
    notifyListeners();
  }

  List<String> getSortedGroups() {
    List<String> groupList = [];
    String key = "${sortBy.title}-${sortByOrder.toString()}";
    if (cachedSortedGroups.containsKey(key)) {
      groupList = cachedSortedGroups[key]!;
    } else {
      if (sortBy == AuditVisitsSortBy.date) {
        // group the auditVisits by auditVisitDate and return the number of groups
        groupList = auditVisits.map((e) => e.auditVisitDate).toSet().toList();
      } else if (sortBy == AuditVisitsSortBy.type) {
        groupList = auditVisits.map((e) => e.auditType).toSet().toList();
      } else if (sortBy == AuditVisitsSortBy.facilityName) {
        groupList = auditVisits.map((e) => e.facilityNameInEnglish).toSet().toList();
      }
      groupList.sort((a, b) {
        if (sortBy == AuditVisitsSortBy.date) {
          if (a.isEmpty) {
            return sortByOrder == AcamListManagerSortByOrder.desc ? 1 : -1;
          } else if (b.isEmpty) {
            return sortByOrder == AcamListManagerSortByOrder.desc ? -1 : 1;
          }
          DateTime aDateTime = DateFormat('MM/dd/yyyy', 'en_US').parse(a);
          DateTime bDateTime = DateFormat('MM/dd/yyyy', 'en_US').parse(b);
          return (sortByOrder == AcamListManagerSortByOrder.desc ? bDateTime.compareTo(aDateTime) : aDateTime.compareTo(bDateTime));
        } else {
          return (sortByOrder == AcamListManagerSortByOrder.asc ? a.compareTo(b) : b.compareTo(a));
        }
      });

      cachedSortedGroups[key] = groupList;
    }
    return groupList;
  }

  int getNumberOfGroups(List<AuditVisit> auditVisits) {
    return getSortedGroups().length;
  }

  String getGroupNameByIndex(int index) {
    List<String> groupList = getSortedGroups();

    return groupList.length > index ? groupList[index] : "";
  }

  List<AuditVisit> getAuditVisitsByGroup(int index) {
    var groupName = getGroupNameByIndex(index);
    if (sortBy == AuditVisitsSortBy.date) {
      // group the auditVisits by auditVisitDate and return the number of groups
      return getAuditVisits(auditVisitsSortBy: AuditVisitsSortBy.type).where((element) => element.auditVisitDate == groupName).toList();
    } else if (sortBy == AuditVisitsSortBy.type) {
      return getAuditVisits(auditVisitsSortBy: AuditVisitsSortBy.date).where((element) => element.auditType == groupName).toList();
    } else if (sortBy == AuditVisitsSortBy.facilityName) {
      return getAuditVisits(auditVisitsSortBy: AuditVisitsSortBy.facilityName).where((element) => element.facilityNameInEnglish == groupName).toList();
    }
    return [];
  }

  List<AuditVisit> getAuditVisits({AuditVisitsSortBy? auditVisitsSortBy}) {
    auditVisitsSortBy ??= sortBy;
    var sortedAuditVisits = getAuditVisitsSorted(auditVisitsSortBy: auditVisitsSortBy);
    return getAuditVisitsFiltered(sortedAuditVisits);
  }

  List<AuditVisit> getAuditVisitsSorted({AuditVisitsSortBy? auditVisitsSortBy}) {
    var sortedAuditVisits = auditVisits.toList();
    String key = "${auditVisitsSortBy?.title}-${sortByOrder.toString()}";
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
          String aAuditVisitTimeFrom = a.auditVisitTimeFrom.isEmpty ? "00:00" : a.auditVisitTimeFrom;
          String bAuditVisitTimeFrom = b.auditVisitTimeFrom.isEmpty ? "00:00" : b.auditVisitTimeFrom;
          DateTime aDateTime = DateFormat('MM/dd/yyyy HH:mm', 'en_US').parse("${a.auditVisitDate} $aAuditVisitTimeFrom");
          DateTime bDateTime = DateFormat('MM/dd/yyyy HH:mm', 'en_US').parse("${b.auditVisitDate} $bAuditVisitTimeFrom");
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

    if (showTodayOnly) {
      // check if audit visit date is not empty and matches today's date
      filteredInspectionRecords = filteredInspectionRecords.where((element) {
        String today = DateFormat('MM/dd/yyyy', 'en_US').format(DateTime.now());

        return element.getFormattedAuditVisitDate() == today;
      }).toList();
    }

    if (auditVisitsType == AuditVisitsType.current) {
      if (auditVisitsFitler == AuditVisitsFitler.mine) {
        filteredInspectionRecords = filteredInspectionRecords.where((element) {
          return element.visitStatus == "scheduled";
        }).toList();
      } else if (auditVisitsFitler == AuditVisitsFitler.team) {
        filteredInspectionRecords = filteredInspectionRecords.where((element) {
          return element.visitStatus == "pendingTeam";
        }).toList();
      } else if (auditVisitsFitler == AuditVisitsFitler.leader) {
        filteredInspectionRecords = filteredInspectionRecords.where((element) {
          return element.visitStatus == "pendingLeader";
        }).toList();
      }
    }

    return filteredInspectionRecords;
  }

  String getAuditVisitsLabelByFilter() {
    if (auditVisitsType == AuditVisitsType.current) {
      if (auditVisitsFitler == AuditVisitsFitler.mine) {
        return "My Audit Visits";
      } else if (auditVisitsFitler == AuditVisitsFitler.team) {
        return "Team Audit Visits";
      } else if (auditVisitsFitler == AuditVisitsFitler.leader) {
        return "Awaiting Leader's Decision";
      }
    } else {
      return "Previous Audit Visits";
    }
    return "";
  }

  void setShowTodayOnly(bool showTodayOnly) {
    this.showTodayOnly = showTodayOnly;
    notifyListeners();
  }

  setAuditVisitViewStyle(AuditVisitViewStyle auditVisitViewStyle) {
    this.auditVisitViewStyle = auditVisitViewStyle;
    notifyListeners();
  }

  setAuditVisitsFitler(AuditVisitsFitler auditVisitsFitler) {
    this.auditVisitsFitler = auditVisitsFitler;
    notifyListeners();
  }

  setSelectedDay(DateTime? selectedDay) {
    this.selectedDay = selectedDay;
    notifyListeners();
  }

  List<AuditVisit> getAuditVisitsBySelectedDay() {
    if (selectedDay == null) {
      return [];
    }
    return getAuditVisitsByDate(selectedDay!);
  }

  List<AuditVisit> getAuditVisitsByDate(DateTime date) {
    String formattedDate = DateFormat('MM/dd/yyyy', 'en_US').format(date);
    return auditVisits.where((element) => element.getFormattedAuditVisitDate() == formattedDate).toList();
  }

  setCalendarFormat(CalendarFormat calendarFormat) {
    this.calendarFormat = calendarFormat;
    notifyListeners();
  }

  setCriticalErrorMessage(String message) {
    criticalErrorMessage = message;
    notifyListeners();
  }
}

final currentAuditVisitListProvider = ChangeNotifierProvider<AuditVisitListProvider>((ref) {
  var userType = ref.watch(userSessionProvider).inspectorUserType;
  var provider = AuditVisitListProvider(userType, AuditVisitsType.current, viewStyleEnabled: true);
  provider.initProvider();
  return provider;
});

final previousAuditVisitListProvider = ChangeNotifierProvider<AuditVisitListProvider>((ref) {
  var userType = ref.watch(userSessionProvider).inspectorUserType;
  var provider = AuditVisitListProvider(userType, AuditVisitsType.previous);
  provider.initProvider();
  return provider;
});
