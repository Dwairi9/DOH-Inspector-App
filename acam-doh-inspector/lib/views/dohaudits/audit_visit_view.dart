import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/Widgets/better_expansion_tile.dart';
import 'package:aca_mobile_app/Widgets/mobile_card_widget.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_data_objects/department_user.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/component_manager_view_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_list_provider.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_view_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_utility.dart';
import 'package:aca_mobile_app/view_widgets/tappable_list_item_widget.dart';
import 'package:aca_mobile_app/views/checklist_list_view.dart';
import 'package:aca_mobile_app/views/component_manager_view.dart';
import 'package:aca_mobile_app/views/dohaudits/audit_visit_reports_view.dart';
import 'package:aca_mobile_app/views/dohaudits/audit_visit_result_view.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/audit_visit_violation_view.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_attachment_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitView extends ConsumerWidget {
  const AuditVisitView({Key? key, required this.auditVisitViewProvider}) : super(key: key);

  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);
    final themeNotifier = ref.watch(themeProvider);

    if (provider.isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 200),
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text("Loading Visit Details...".tr()),
        ],
      );
    }

    if (provider.criticalErrorMessage.isNotEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Row(
              children: [
                Text("Failed to load visit details".tr(), style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: 8),
                IconButton(
                    onPressed: () {
                      provider.loadAuditVisit();
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
    if (provider.auditVisit == null) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Text(
            'No Data'.tr(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ));
    }

    AuditVisit auditVisit = provider.auditVisit!;
    // var inspectionDate = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(auditVisit.fileDate);
    // Sunday, 22 Janaray 2021 - 12:00 AM
    //  - hh:mm a
    // var formattedDate = DateFormat('EEEE, dd MMMM yyyy', Utility.isRTL(context) ? 'ar_AE' : 'en_US').format(inspectionDate);
    return Stack(
      children: [
        Align(
            alignment: Utility.isRTL(context) ? Alignment.topLeft : Alignment.topRight,
            child: Icon(Icons.ballot, size: 200, color: Colors.white.withOpacity(0.5))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 12),
                          child: Text(
                            "Audit Visit Details".tr(),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                      if (auditVisit.editable)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: SizedBox(
                            height: 46,
                            child: Tooltip(
                              message: !provider.hasScheduledInspections(true) ? 'All of your inspections has been completed.'.tr() : '',
                              child: ElevatedButton(
                                  onPressed: !provider.hasScheduledInspections(true)
                                      ? null
                                      : () {
                                          submitAuditVisit(context, provider, ref);
                                        },
                                  child: Text(
                                    'Result Inspection'.tr(),
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  MobileCardWidget(
                    mobileCard: auditVisit.getMobileCard(),
                    customPadding: 8,
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            TappableListItem(
                themeNotifier: themeNotifier,
                title: 'Visit Information'.tr(),
                icon: Icons.backup_table,
                count: auditVisit.asiGroups.length,
                showCount: false,
                onTap: () {
                  editAsi(context, provider, auditVisit);
                }),
            TappableListItem(
                themeNotifier: themeNotifier,
                title: 'Contact Details'.tr(),
                icon: Icons.group,
                count: auditVisit.asiGroups.length,
                showCount: false,
                onTap: () {
                  viewContactDetails(context, provider, auditVisit);
                }),
            // TappableListItem(
            //     themeNotifier: themeNotifier,
            //     title: 'Custom Tables'.tr(),
            //     icon: Icons.table_chart_outlined,
            //     count: auditVisit.asitGroups.length,
            //     showCount: false,
            //     onTap: () {
            //       editAsit(context, provider, auditVisit);
            //     }),
            TappableListItem(
                themeNotifier: themeNotifier,
                title: 'Documents'.tr(),
                icon: Icons.file_present,
                count: auditVisit.attachments.length,
                onTap: () {
                  editAttachments(context, provider, auditVisit);
                }),
            TappableListItem(
                themeNotifier: themeNotifier,
                title: 'Reports'.tr(),
                icon: Icons.notes,
                count: 0,
                showCount: false,
                onTap: () {
                  showReports(context, auditVisit);
                }),
            TappableListItem(
                themeNotifier: themeNotifier,
                title: 'Violation'.tr(),
                icon: Icons.notes,
                count: 0,
                showCount: false,
                onTap: () {
                  showViolation(context, auditVisit, provider, ref);
                }),
            if (auditVisit.editable) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Text("Inspections".tr(), style: Theme.of(context).textTheme.headlineLarge),
              ),
              for (var inspectionProvider in provider.inspectionProviders)
                InspectionChecklistsWidget(
                  inspectionProvider: inspectionProvider,
                  auditVisitViewProvider: auditVisitViewProvider,
                )
            ],
            const Divider(),
          ],
        ),
      ],
    );
  }

  editAttachments(BuildContext context, AuditVisitViewProvider provider, AuditVisit auditVisit) {
    List<BaseComponentViewProvider> componentList = [];

    var attachmentViewProvider = AttachmentViewProvider(
      ParentComponentType.record,
      attachmentObserver: provider,
      recordId: RecordId(customId: auditVisit.customId, id: auditVisit.recordId),
      isReadOnly: auditVisit.editable == false,
      documentGroup: "HAAV",
      documentCategory: "Audit Evidence",
    );
    componentList.add(attachmentViewProvider);

    ComponentManagerViewProvider componentManagerViewProvider = ComponentManagerViewProvider(componentList, isComponentsExpandable: false);
    WidgetUtil.showFullScreenDialog(
        context,
        ComponentManagerView(
          componentManagerViewProvider,
          scrollable: false,
        ),
        "Attachments".tr(),
        [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  showReports(BuildContext context, AuditVisit auditVisit) {
    WidgetUtil.showFullScreenDialog(context, AuditVisitReportsView(auditVisit), "Reports".tr(), [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  showViolation(BuildContext context, AuditVisit auditVisit, AuditVisitViewProvider provider, WidgetRef ref) {
    provider.violationHeaderCustomId = auditVisit.customId;

    WidgetUtil.showFullScreenDialog(context, AuditVisitViolationView( auditVisit,auditVisitViewProvider: auditVisitViewProvider,),
      "Violation".tr(), subtitleBuilder: (context){
        return Consumer(
          builder: (context, ref, child){
            final violationProvider = ref.watch(auditVisitViewProvider);
            final currentValue = "${violationProvider.violationHeaderCustomId} - ${violationProvider.violationHeaderStatus}";
            return Text(currentValue);
          }
        );
      }, [],
      onClose: (BuildContext context) {
        provider.clearViolation();
        Navigator.pop(context);
      }
    );
  }

  showViolationAttachments(BuildContext context, WidgetRef ref) {
    ref.read(currentAuditVisitListProvider).loadInspections();

    WidgetUtil.showFullScreenDialog(
        context,
        ViolationAttachmentView(
          auditVisitViewProvider: auditVisitViewProvider,
        ),
        "Attachments".tr(),
        subtitle: ref.read(auditVisitViewProvider).violationInformation?.violationCustomId,
        [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  submitAuditVisit(BuildContext context, AuditVisitViewProvider provider, WidgetRef ref) {
    provider.prepareInspectionsSelectedForResult();
    WidgetUtil.showFullScreenDialog(context, AuditVisitResultView(auditVisitViewProvider: auditVisitViewProvider), "Result Inspection".tr(), [
      FullScreenActionButton(
          title: "Submit".tr(),
          callback: provider.isSaving
              ? null
              : (fullScreenContext, loader) async {
                  if (provider.isSaving) {
                    return;
                  }
                  var actionObject = await provider.resultAuditVisit();

                  if (actionObject.success) {
                    if (fullScreenContext.mounted) AcamUtility.showMessageForActionObject(fullScreenContext, actionObject);
                    provider.loadAuditVisit();
                    ref.read(currentAuditVisitListProvider).loadInspections();
                    ref.read(previousAuditVisitListProvider).loadInspections();

                    if (fullScreenContext.mounted) Navigator.pop(fullScreenContext);
                    // if (context.mounted) Navigator.maybePop(context);
                  } else {
                    provider.setErrorMessage(actionObject.message);
                  }
                })
    ], onClose: (BuildContext context) async {
      if (context.mounted) Navigator.pop(context);
    });
  }

  editAsi(BuildContext context, AuditVisitViewProvider provider, AuditVisit auditVisit) {
    if (auditVisit.asiGroups.isEmpty && auditVisit.asitGroups.isEmpty) {
      return;
    }

    List<BaseComponentViewProvider> componentList = [];

    var asiComponents = auditVisit.asiGroups.map((e) {
      return AsiComponentViewProvider(
        e,
        title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
        values: auditVisit.asiValues[e.subgroup],
        forceReadOnly: auditVisit.editable == false,
        expressionsDescription: e.expressionDescription,
      );
    }).toList();

    componentList.addAll(asiComponents);

    var asitComponents = auditVisit.asitGroups.map((e) {
      return AsitComponentViewProvider(
        e,
        title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
        values: auditVisit.asitValues[e.subgroup],
        isReadOnly: auditVisit.editable == false,
        expressionsDescription: e.expressionDescription,
      );
    }).toList();
    componentList.addAll(asitComponents);

    ComponentManagerViewProvider componentManagerViewProvider = ComponentManagerViewProvider(
      componentList,
      initialExpandState: InitialExpandState.all,
      recordId: RecordId(customId: auditVisit.customId),
    );
    WidgetUtil.showFullScreenDialog(
        context,
        ComponentManagerView(
          componentManagerViewProvider,
          scrollable: false,
        ),
        "Visit Information".tr(),
        [
          if (auditVisit.editable)
            FullScreenActionButton(
                title: "Save".tr(),
                callback: (context, loader) async {
                  if (!componentManagerViewProvider.isValid()) {
                    Utility.showAlert(context, "Validation".tr(), "Please Correct the Errors in the Form".tr());
                    return;
                  }
                  for (var component in componentList) {
                    if (component.type == ComponentType.asi) {
                      AsiComponentViewProvider asiComponent = component as AsiComponentViewProvider;
                      provider.setAsiValues(asiComponent.getGroupName(), asiComponent.getAsiValuesAsStrings());
                    } else if (component.type == ComponentType.asit) {
                      AsitComponentViewProvider asitComponent = component as AsitComponentViewProvider;
                      provider.setAsitValues(asitComponent.getGroupName(), asitComponent.getAsitRowsAsStrings());
                    }
                  }
                  componentManagerViewProvider.setLoading(true);
                  var actionObject = await provider.updateRecordAsitAsit();
                  componentManagerViewProvider.setLoading(false);
                  if (context.mounted) AcamUtility.showMessageForActionObject(context, actionObject);

                  if (actionObject.success && context.mounted) Navigator.pop(context);
                })
        ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  viewContactDetails(BuildContext context, AuditVisitViewProvider provider, AuditVisit auditVisit) {
    if (auditVisit.facilityAsiGroups.isEmpty && auditVisit.facilityAsitGroups.isEmpty) {
      return;
    }

    List<BaseComponentViewProvider> componentList = [];

    var asiComponents = auditVisit.facilityAsiGroups.map((e) {
      return AsiComponentViewProvider(
        e,
        title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
        values: auditVisit.facilityAsiValues[e.subgroup],
        forceReadOnly: true,
      );
    }).toList();

    componentList.addAll(asiComponents);

    var asitComponents = auditVisit.facilityAsitGroups.map((e) {
      return AsitComponentViewProvider(
        e,
        title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
        values: auditVisit.facilityAsitValues[e.subgroup],
        isReadOnly: true,
      );
    }).toList();
    componentList.addAll(asitComponents);

    ComponentManagerViewProvider componentManagerViewProvider = ComponentManagerViewProvider(componentList, initialExpandState: InitialExpandState.all);
    WidgetUtil.showFullScreenDialog(
        context,
        ComponentManagerView(
          componentManagerViewProvider,
          scrollable: false,
        ),
        "Contact Details".tr(),
        [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  editAsit(BuildContext context, AuditVisitViewProvider provider, AuditVisit auditVisit) {
    if (auditVisit.asitGroups.isEmpty) {
      return;
    }

    List<BaseComponentViewProvider> componentList = [];

    var asitComponents = auditVisit.asitGroups.map((e) {
      return AsitComponentViewProvider(
        e,
        title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
        values: auditVisit.asitValues[e.subgroup],
        isReadOnly: auditVisit.editable == false,
      );
    }).toList();
    componentList.addAll(asitComponents);

    ComponentManagerViewProvider componentManagerViewProvider = ComponentManagerViewProvider(componentList, initialExpandState: InitialExpandState.all);
    WidgetUtil.showFullScreenDialog(
        context,
        ComponentManagerView(
          componentManagerViewProvider,
          scrollable: false,
        ),
        "Custom Tables".tr(),
        [
          FullScreenActionButton(
              title: "Save".tr(),
              callback: (context, loader) async {
                if (!componentManagerViewProvider.isValid()) {
                  Utility.showAlert(context, "Validation".tr(), "Please Correct the Errors in the Form".tr());
                  return;
                }
                for (var component in componentList) {
                  if (component.type == ComponentType.asit) {
                    AsitComponentViewProvider asitComponent = component as AsitComponentViewProvider;
                    provider.setAsitValues(asitComponent.getGroupName(), asitComponent.getAsitRowsAsStrings());
                  }
                }
                componentManagerViewProvider.setLoading(true);
                var actionObject = await provider.updateRecordAsit();
                componentManagerViewProvider.setLoading(false);
                if (context.mounted) AcamUtility.showMessageForActionObject(context, actionObject);

                if (actionObject.success && context.mounted) Navigator.pop(context);
              })
        ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }
}

class InspectionChecklistsWidget extends ConsumerWidget {
  const InspectionChecklistsWidget({
    super.key,
    required this.inspectionProvider,
    required this.auditVisitViewProvider,
  });

  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(inspectionProvider);
    final themeNotifier = ref.watch(themeProvider);
    final userSession = ref.watch(userSessionProvider);
    final auditVisitProvider = ref.watch(auditVisitViewProvider);

    return Column(
      children: [
        const SizedBox(height: 8),
        Material(
          color: themeNotifier.light5Color,
          child: BetterExpansionTile(
              initiallyExpanded: true,
              //   trailing: Icon(
              //     provider.isExpanded ? Icons.remove : Icons.add,
              //     color: themeNotifier.iconColor,
              //   ),
              collapsedIconColor: themeNotifier.light3Color,
              iconColor: themeNotifier.light3Color,
              controlAffinity: ListTileControlAffinity.leading,
              onExpansionChanged: (bool isExpanded) {
                provider.setExpanded(isExpanded);
              },
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 4.0),
                  //     child: Icon(Icons.checklist_outlined, color: themeNotifier.dark2Color),
                  //   ),
                  //   const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          provider.getDisplayInspectionType(),
                          style: Theme.of(context).textTheme.headlineMedium,
                          maxLines: 1,
                          minFontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              provider.getFriendlyInspectionStatus(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              " - ${provider.getScheduledInspectionDate()}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  //   const Spacer(),
                  if (auditVisitProvider.auditVisit?.isCurrentUserTeamLeader ?? false)
                    AcamIcon(
                      icon: Icons.account_circle,
                      iconColor: !(provider.inspection?.editable ?? false) ? null : themeNotifier.primaryColor,
                      text: "Reassign".tr(),
                      condensed: true,
                      onTap: !(provider.inspection?.editable ?? false)
                          ? null
                          : () {
                              provider.assignedInspector = provider.inspection?.userID ?? "";
                              WidgetUtil.showFullScreenDialog(
                                  context,
                                  AssignInspectorView(
                                    auditVisitViewProvider: auditVisitViewProvider,
                                    inspectionProvider: inspectionProvider,
                                  ),
                                  "Assign Inspector".tr(),
                                  [
                                    FullScreenActionButton(
                                        title: "Save".tr(),
                                        callback: (context, loader) async {
                                          if (provider.assignedInspector.isEmpty) {
                                            Utility.showAlert(context, "Validation".tr(), "Please Select Inspector".tr());
                                            return;
                                          }
                                          provider.setIsReassigningInspector(true);
                                          var actionObject = await provider.reassignInspector();
                                          provider.setIsReassigningInspector(false);
                                          if (context.mounted) AcamUtility.showMessageForActionObject(context, actionObject);
                                          if (actionObject.success) auditVisitProvider.loadAuditVisit();
                                          if (actionObject.success && context.mounted) Navigator.pop(context);
                                        })
                                  ], onClose: (BuildContext context) {
                                Navigator.pop(context);
                              });
                            },
                    )
                ],
              ),
              children: [
                const Divider(),
                if (userSession.userId.toUpperCase() == provider.inspection?.userID.toUpperCase())
                  Material(
                    color: themeNotifier.light2Color,
                    child: ChecklistListView(inspectionProvider: inspectionProvider),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${"This Inspection Is Assigned To".tr()} ${auditVisitProvider.getDepartmentUserFullNameByUserId(provider.inspection?.userID ?? "")}",
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  )
              ]),
        ),
      ],
    );
  }
}

class AssignInspectorView extends ConsumerWidget {
  const AssignInspectorView({
    super.key,
    required this.inspectionProvider,
    required this.auditVisitViewProvider,
  });

  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditProvider = ref.watch(auditVisitViewProvider);
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(inspectionProvider);
    return SingleChildScrollView(
        child: Column(children: [
      if (provider.isReassigningInspector)
        LinearProgressIndicator(
          color: themeNotifier.primaryColor,
          backgroundColor: Colors.transparent,
        )
      else
        Container(
          color: themeNotifier.primaryColor,
          height: 4,
        ),
      InfoMessageWidget(infoMessageProvider: provider.infoMessageProvider),
      const SizedBox(height: 4),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Department Inspectors".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeNotifier.light3Color, width: 0.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.getAssignedInspectorForDropdown(auditProvider.auditVisit?.auditDepartmentInspectors ?? []),
                    elevation: 16,
                    isExpanded: true,
                    style: TextStyle(color: themeNotifier.primaryColor),
                    onChanged: (String? value) {
                      if (value != null) {
                        provider.setAssignedInspector(value);
                      }
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: themeNotifier.light4Color,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: "",
                        child: Text("Select Inspector".tr(), style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      ...(auditProvider.auditVisit?.auditDepartmentInspectors ?? []).map<DropdownMenuItem<String>>((DepartmentUser item) {
                        return DropdownMenuItem<String>(
                          value: item.username,
                          child: AutoSizeText(
                            "${item.firstName} ${item.lastName} (${item.username})",
                            minFontSize: 11,
                            stepGranularity: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        );
                      }).toList()
                    ],
                  ),
                ))
          ]))
    ]));
  }
}

class RecordInspectionListView extends ConsumerWidget {
  const RecordInspectionListView({Key? key, required this.auditVisitViewProvider}) : super(key: key);

  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
        itemCount: provider.auditVisit?.inspections.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: RecordInspectionWidget(inspection: (provider.auditVisit?.inspections[index])!, auditVisitViewProvider: auditVisitViewProvider),
          );
        });
  }
}

class RecordInspectionWidget extends ConsumerWidget {
  const RecordInspectionWidget({
    Key? key,
    required this.inspection,
    required this.auditVisitViewProvider,
  }) : super(key: key);

  final Inspection inspection;
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    // final inspectionRecordNotifier = ref.watch(auditVisitViewProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: InkWell(
            child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: Utility.isRTL(context) ? 0 : 12, right: Utility.isRTL(context) ? 12 : 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(inspection.getDisplayInspectionType(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifier.primaryColor)),
                    const Spacer(),
                    Text(inspection.getDisplayStatus(), style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                )),
            onTap: () async {
              //   final inspectionProvider = ChangeNotifierProvider((ref) {
              //     var userType = ref.watch(userSessionProvider).inspectorUserType;
              //     var inspProvider = InspectionProvider(inspection.customId, inspection.idNumber, parentRecordProvider: inspectionRecordNotifier, userType);
              //     inspProvider.setRef(ref);
              //     inspProvider.initProvider();

              //     return inspProvider;
              //   });

              //   Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: InspectionScreen(inspectionProvider: inspectionProvider)));
            },
          ),
        ),
        Divider(height: 1, thickness: 1, indent: 0, endIndent: 0, color: themeNotifier.light3Color),
      ],
    );
  }
}
