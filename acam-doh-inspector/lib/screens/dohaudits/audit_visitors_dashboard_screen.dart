import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_list_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_providers/global_inspection_provider.dart';
import 'package:aca_mobile_app/views/dohaudits/audit_visit_list_view.dart';
import 'package:aca_mobile_app/views/dohaudits/audit_visit_search_view.dart';
import 'package:aca_mobile_app/views/user_profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitorsDashboardScreen extends ConsumerStatefulWidget {
  const AuditVisitorsDashboardScreen({
    Key? key,
  }) : super(key: key);
  @override
  AuditVisitorsDashboardScreenState createState() => AuditVisitorsDashboardScreenState();
}

class AuditVisitorsDashboardScreenState extends ConsumerState<AuditVisitorsDashboardScreen> with TickerProviderStateMixin {
  late TabController homeTabController;

  @override
  void initState() {
    super.initState();
    homeTabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = ref.watch(themeProvider);
    var globalInspectionProvider = ref.watch(inspectionGlobalProvider);

    return DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          globalInspectionProvider.inspectionDashboardTabController = tabController;
          homeTabController.addListener(() {
            globalInspectionProvider.setGlobalTabIndex(homeTabController.index);
            // if (tabController.index == 1) {
            //   int index = tabController.previousIndex;
            //   tabController.index = index;
            // }
          });
          return WillPopScope(
            onWillPop: () => UserManageUtils.logoutConfirm(context),
            child: Scaffold(
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: themeNotifier.dark1Color, width: 0.0),
                    ),
                  ),
                  child: Material(
                    color: themeNotifier.light0Color,
                    child: TabBar(
                        labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        unselectedLabelColor: themeNotifier.iconColor,
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        labelColor: Theme.of(context).primaryColor,
                        controller: tabController,
                        tabs: const [
                          Tab(
                            //   text: "Today".tr(),
                            icon: Icon(Icons.home),
                          ),
                          Tab(
                            //   text: "Search".tr(),
                            icon: Icon(Icons.search),
                          ),
                          Tab(
                            //   text: "Settings".tr(),
                            icon: Icon(Icons.settings),
                          )
                        ]
                        // isScrollable: true,
                        ),
                  ),
                ),
                //   appBar: AppBar(
                //     backgroundColor: themeNotifier.dark3Color,
                //     title: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text('Inspections'.tr(), style: const TextStyle(color: Colors.white)),
                //       ],
                //     ),
                //   ),
                body: SafeArea(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 122,
                            child: Stack(
                              children: [
                                Material(
                                  color: Theme.of(context).primaryColor,
                                  child: TabBar(
                                      controller: homeTabController,
                                      // labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      unselectedLabelColor: themeNotifier.light3Color,
                                      labelStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 34),
                                      labelColor: Colors.white,
                                      indicatorColor: Colors.white,
                                      indicator: const UnderlineTabIndicator(
                                        borderSide: BorderSide(width: 4.0, color: Colors.white),
                                        insets: EdgeInsets.symmetric(horizontal: 16.0),
                                      ),
                                      tabs: [
                                        Tab(
                                          text: "Current".tr(),
                                          height: 120,
                                        ),
                                        Tab(
                                          text: "Previouss".tr(),
                                          height: 120,
                                        ),
                                      ]
                                      // isScrollable: true,
                                      ),
                                ),
                                IgnorePointer(
                                  child: Align(
                                      alignment: globalInspectionProvider.globalTabIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
                                      child: globalInspectionProvider.globalTabIndex == 0
                                          ? const Icon(Icons.ballot, size: 130, color: Color.fromARGB(50, 255, 255, 255))
                                          : const Icon(Icons.history, size: 130, color: Color.fromARGB(40, 255, 255, 255))),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: homeTabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: const [
                                AuditVisitListView(
                                  auditVisitsType: AuditVisitsType.current,
                                ),
                                AuditVisitListView(
                                  auditVisitsType: AuditVisitsType.previous,
                                ),
                                //   InspectionRecordListView(
                                //       inspectionRecordListProvider: widget.inspectionRecordListProvider, inspectionListProvider: widget.inspectionListProvider),
                                //   InspectionListView(inspectionListProvider: widget.inspectionListProvider),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const AuditVisitSearchView(),
                      const UserProfileView(),
                    ],
                  ),
                ))),
          );
        }));
  }
}
