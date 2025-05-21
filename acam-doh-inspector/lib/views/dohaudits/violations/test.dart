import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Widgets/acam_widgets.dart';
import '../../../Widgets/better_expansion_tile.dart';
import '../../../themes/theme_provider.dart';
import '../../../user_management/providers/user_session_provider.dart';
import '../../../utility/utility.dart';
import '../../../view_providers/dohaudits/audit_visit_view_provider.dart';
import '../../../view_providers/inspection_provider.dart';
import '../../../view_widgets/acam_utility.dart';
import '../../checklist_list_view.dart';
import '../audit_visit_view.dart';

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