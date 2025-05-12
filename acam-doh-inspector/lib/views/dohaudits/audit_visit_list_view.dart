import 'package:aca_mobile_app/Widgets/better_expansion_tile.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_list_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:aca_mobile_app/view_widgets/dohaudits/audit_visit_card_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:badges/badges.dart' as badges;

class AuditVisitListView extends ConsumerWidget {
  const AuditVisitListView({Key? key, required this.auditVisitsType}) : super(key: key);
  final AuditVisitsType auditVisitsType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = auditVisitsType == AuditVisitsType.current ? ref.watch(currentAuditVisitListProvider) : ref.watch(previousAuditVisitListProvider);

    final themeNotifier = ref.watch(themeProvider);
    return Column(
      children: [
        if (provider.viewStyleEnabled)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<AuditVisitViewStyle>(
              segments: <ButtonSegment<AuditVisitViewStyle>>[
                ButtonSegment<AuditVisitViewStyle>(
                  value: AuditVisitViewStyle.list,
                  label: Text("List".tr()),
                  icon: const Icon(Icons.list),
                ),
                ButtonSegment<AuditVisitViewStyle>(
                  value: AuditVisitViewStyle.calendar,
                  label: Text("Calendar".tr()),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
              selected: <AuditVisitViewStyle>{provider.auditVisitViewStyle},
              onSelectionChanged: (Set<AuditVisitViewStyle> newSelection) {
                provider.setAuditVisitViewStyle(newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return themeNotifier.primaryColor;
                    }
                    return Colors.transparent;
                  },
                ),
                iconColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return themeNotifier.dark3Color;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return themeNotifier.dark3Color;
                  },
                ),
                side: MaterialStateProperty.all(BorderSide(color: themeNotifier.getColor("light3"), width: 1)),
                textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16)),
              ),
            ),
          ),
        if (provider.auditVisitViewStyle == AuditVisitViewStyle.list)
          Expanded(
            child: provider.managerType == AcamListManagerType.group ? AuditVisitGroupedWidget(provider: provider) : AuditVisitListWidget(provider: provider),
          )
        else
          Expanded(
            child: AuditVisitCalendarWidget(provider: provider),
          ),
      ],
    );
  }
}

class AuditVisitGroupedWidget extends ConsumerWidget {
  const AuditVisitGroupedWidget({
    super.key,
    required this.provider,
  });

  final AuditVisitListProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    var auditVisits = provider.getAuditVisits();
    if (provider.criticalErrorMessage.isNotEmpty) {
      return LoadErrorWidget(provider: provider, themeNotifier: themeNotifier);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: AcamListManagerWidget(provider),
        ),
        const Divider(),
        const SizedBox(
          height: 8,
        ),
        if (provider.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SegmentedButton<AuditVisitsFitler>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<AuditVisitsFitler>>[
                    ButtonSegment<AuditVisitsFitler>(
                      value: AuditVisitsFitler.mine,
                      label: Text("Mine".tr()),
                      icon: const Icon(Icons.person),
                    ),
                    ButtonSegment<AuditVisitsFitler>(
                      value: AuditVisitsFitler.team,
                      label: Text("Team Pending".tr()),
                      icon: const Icon(Icons.group),
                    ),
                    ButtonSegment<AuditVisitsFitler>(
                      value: AuditVisitsFitler.leader,
                      label: Text("Leader Decision".tr()),
                      icon: const Icon(Icons.star),
                    ),
                  ],
                  selected: <AuditVisitsFitler>{provider.auditVisitsFitler},
                  onSelectionChanged: (Set<AuditVisitsFitler> newSelection) {
                    provider.setAuditVisitsFitler(newSelection.first);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return themeNotifier.primaryColor;
                        }
                        return Colors.transparent;
                      },
                    ),
                    side: MaterialStateProperty.all(BorderSide(color: themeNotifier.getColor("light3"), width: 1)),
                    iconColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return themeNotifier.dark3Color;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return themeNotifier.dark3Color;
                      },
                    ),
                    textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12)),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${provider.getAuditVisitsLabelByFilter()} (${auditVisits.length})",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                InkWell(
                  onTap: () {
                    provider.setShowTodayOnly(!provider.showTodayOnly);
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                          color: Colors.white,
                          width: 16,
                          height: 16,
                          child: Checkbox(
                            checkColor: Colors.white,
                            value: provider.showTodayOnly,
                            onChanged: (bool? value) {
                              provider.setShowTodayOnly(value ?? false);
                            },
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Show Today".tr(), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                provider.loadInspections();
                return;
              },
              child: auditVisits.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: provider.getNumberOfGroups(auditVisits),
                              shrinkWrap: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                List<AuditVisit> groupAuditVisits = provider.getAuditVisitsByGroup(index);
                                String groupName = provider.getGroupNameByIndex(index);
                                if (provider.sortBy == AuditVisitsSortBy.date) {
                                  if (groupName.isEmpty) {
                                    groupName = "N/A";
                                  } else {
                                    groupName = DateFormat('EEEE, dd MMMM yyyy', Utility.isRTL(context) ? 'ar_AE' : 'en_US')
                                        .format(DateFormat('MM/dd/yyyy', 'en_US').parse(groupName));
                                  }
                                }
                                return groupAuditVisits.isNotEmpty
                                    ? Column(
                                        children: [
                                          BetterExpansionTile(
                                            // key: PageStorageKey<String>(groupName),
                                            key: Key(groupName),
                                            initiallyExpanded: provider.isGroupExpanded(groupName),
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  provider.isGroupExpanded(groupName) ? Icons.remove : Icons.add,
                                                  color: themeNotifier.iconColor,
                                                  size: 13,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(groupName,
                                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                                                      maxLines: 2,
                                                      minFontSize: 13,
                                                      overflow: TextOverflow.ellipsis),
                                                ),
                                                // const Spacer(),
                                                // const SizedBox(
                                                //   width: 8,
                                                // ),
                                                const SizedBox(
                                                  width: 40,
                                                  child: Divider(
                                                    height: 1,
                                                    thickness: 1,
                                                    indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing:
                                                Text("(${groupAuditVisits.length})", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18)),
                                            collapsedBackgroundColor: themeNotifier.getColor("light2"),
                                            backgroundColor: themeNotifier.getColor("light5"),
                                            onExpansionChanged: (bool isExpanded) {
                                              provider.setGroupExpanded(groupName, isExpanded);
                                            },
                                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                                                child: AuditVisitGroupListWidget(auditVisits: groupAuditVisits),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox();
                              }),
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(
                            child: Text(
                          'No Data'.tr(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ))
                      ],
                    ),
            ),
          )
        ],
      ],
    );
  }
}

class LoadErrorWidget extends StatelessWidget {
  const LoadErrorWidget({
    super.key,
    required this.provider,
    required this.themeNotifier,
  });

  final AuditVisitListProvider provider;
  final ThemeNotifier themeNotifier;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Row(
            children: [
              Text("Failed to load audit visits list".tr(), style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    provider.loadInspections();
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 18,
                    color: themeNotifier.primaryColor,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, minHeight: 100),
            child: Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  provider.criticalErrorMessage,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class AuditVisitGroupListWidget extends ConsumerWidget {
  const AuditVisitGroupListWidget({
    super.key,
    required this.auditVisits,
  });

  final List<AuditVisit> auditVisits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        itemCount: auditVisits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AuditVisitCardWidget(auditVisit: auditVisits[index]);
        });
  }
}

class AuditVisitListWidget extends ConsumerWidget {
  const AuditVisitListWidget({
    super.key,
    required this.provider,
  });

  final AuditVisitListProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auditVisits = provider.getAuditVisits();
    final themeNotifier = ref.watch(themeProvider);
    if (provider.criticalErrorMessage.isNotEmpty) {
      return LoadErrorWidget(provider: provider, themeNotifier: themeNotifier);
    }
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: AcamListManagerWidget(provider),
        ),
        const Divider(),
        const SizedBox(
          height: 8,
        ),
        if (provider.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Text("${'Total Number of Audit Visits'.tr()} (${auditVisits.length})",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const Divider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    provider.loadInspections();
                    return;
                  },
                  child: auditVisits.isNotEmpty
                      ? ListView.builder(
                          itemCount: auditVisits.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                              // child: InspectionRecordCardWidget(record: recordList[index]),
                              child: AuditVisitCardWidget(auditVisit: auditVisits[index]),
                            );
                          })
                      : ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Center(
                                child: Text(
                              'No Data'.tr(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ))
                          ],
                        ),
                ),
              ),
            ],
          )),
      ],
    );
  }
}

class AuditVisitCalendarWidget extends ConsumerWidget {
  const AuditVisitCalendarWidget({
    super.key,
    required this.provider,
  });

  final AuditVisitListProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              child: TableCalendar(
                // rowHeight: 40,
                availableCalendarFormats: <CalendarFormat, String>{
                  CalendarFormat.month: "Week".tr(),
                  CalendarFormat.twoWeeks: "Month".tr(),
                  CalendarFormat.week: "Two Weeks".tr()
                },
                sixWeekMonthsEnforced: true,
                availableGestures: AvailableGestures.horizontalSwipe,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: true,
                  headerPadding: EdgeInsets.all(0),
                  //   titleTextFormatter: (date, locale) => DateFormat('MMMM yyyy', locale).format(date).toUpperCase(),
                ),
                daysOfWeekHeight: 20,

                calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) => events.isNotEmpty
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 50),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: badges.Badge(
                                badgeColor: Colors.orange,
                                shape: badges.BadgeShape.circle,
                                padding: const EdgeInsets.all(4),
                                badgeContent: Text(
                                  "${events.length}",
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                          )
                        : null),
                eventLoader: (day) => provider.getAuditVisitsByDate(day),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: provider.selectedDay ?? DateTime.now(),
                selectedDayPredicate: (day) {
                  return isSameDay(provider.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  provider.setSelectedDay(selectedDay);
                },
                onFormatChanged: (format) => provider.setCalendarFormat(format),
                calendarFormat: provider.calendarFormat,
              ),
            ),
            AuditVisitGroupListWidget(auditVisits: provider.getAuditVisitsBySelectedDay()),
          ],
        ),
      ),
    );
  }
}
