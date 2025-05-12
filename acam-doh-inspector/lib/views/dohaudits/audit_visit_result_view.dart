import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/description/inspection_result_group_item.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_view_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/views/draw_view2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitResultView extends ConsumerWidget {
  const AuditVisitResultView({Key? key, required this.auditVisitViewProvider}) : super(key: key);

  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);
    final themeNotifier = ref.watch(themeProvider);

    return SingleChildScrollView(
      controller: provider.resultViewScrollController,
      child: Column(
        children: [
          if (provider.isSaving)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Result the Following Inspections".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: provider.getInspectionProviders(true).map((InspectionProvider inspProvider) {
                          return CheckboxListTile(
                              dense: true,
                              enabled: inspProvider.inspectionResultable(),
                              fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return themeNotifier.light3Color;
                                } else if (states.contains(MaterialState.selected)) {
                                  return themeNotifier.primaryColor;
                                }
                                return null; // Use the component's default.
                              }),
                              contentPadding: const EdgeInsets.only(left: 18, right: 18),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                  (inspProvider.inspection?.getDisplayInspectionType() ?? '') +
                                      (inspProvider.getInspectionTextStatus().isNotEmpty ? ' (${inspProvider.getInspectionTextStatus()})' : ''),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
                              value: inspProvider.inspection?.selectedForResult,
                              onChanged: (checked) => {provider.setInspectionSelectedForResult(inspProvider.inspection!, checked ?? false)});
                        }).toList(),
                      ),
                    )),
                const SizedBox(height: 16),
                Text("Inspection Result".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
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
                        value: provider.inspectionResult,
                        elevation: 16,
                        isExpanded: true,
                        style: TextStyle(color: themeNotifier.primaryColor),
                        onChanged: (String? value) {
                          if (value != null) {
                            provider.setInspectionResult(value);
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: themeNotifier.light4Color,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "",
                            child: Text("Set Status".tr(), style: Theme.of(context).textTheme.headlineMedium),
                          ),
                          ...provider.getInspectionResultGroupItems().map<DropdownMenuItem<String>>((InspectionResultGroupItem item) {
                            return DropdownMenuItem<String>(
                              value: item.value,
                              child: AutoSizeText(
                                item.text,
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
                    )),
                const SizedBox(height: 16),
                //   Text("Comment".tr()),
                //   const SizedBox(height: 10),
                Text("Inspection Comments".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                TextField(
                  controller: provider.commentController,
                  onChanged: (String value) {
                    provider.setInspectionResultComment(value);
                  },
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(4),
                    hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: themeNotifier.light4Color),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    hintText: "Add Inspection Comments Here".tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (!provider.inspectorUploadedSignature()) ...[
                  Text("Inspector Signature".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () {
                      addSignature(context, provider.inspectorPainterController, "Inspector Signature".tr(), themeNotifier, provider);
                    },
                    child: IgnorePointer(
                      child: SizedBox(
                        height: 240,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: themeNotifier.light0Color,
                                  border: Border.all(color: themeNotifier.light3Color),
                                ),
                                child: PainterView(provider.inspectorPainterController)),
                            if (provider.inspectorPainterController.isEmpty)
                              Center(
                                  child: Text(
                                "Tap Here to Sign".tr(),
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifier.light4Color),
                              )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("Responsible Party Signature".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text("Not Available".tr()),
                      Checkbox(
                          value: provider.otherPartySignatureNotAvailable,
                          onChanged: (bool? value) {
                            if (value != null) {
                              provider.setOtherPartySignatureNotAvailable(value);
                            }
                          })
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (provider.otherPartySignatureNotAvailable)
                    TextField(
                      controller: provider.otherPartySignatureNotAvailableReasonController,
                      onChanged: (String value) {
                        provider.setOtherPartySignatureNotAvailableReason(value);
                      },
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: themeNotifier.light4Color),
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        hintText: "Add Justification for no signature".tr(),
                        border: const OutlineInputBorder(),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {
                        addSignature(context, provider.otherPartyPainterController, "Responsible Party Signature".tr(), themeNotifier, provider);
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                          height: 240,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: themeNotifier.light0Color,
                                    border: Border.all(color: themeNotifier.light3Color),
                                  ),
                                  child: PainterView(provider.otherPartyPainterController)),
                              if (provider.otherPartyPainterController.isEmpty)
                                Center(
                                    child: Text(
                                  "Tap Here to Sign".tr(),
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifier.light4Color),
                                )),
                            ],
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  Text("Inspector Signature".tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.all(0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: themeNotifier.light3Color),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("The audit visit has already been signed by this inspector.".tr(),
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, color: themeNotifier.light4Color)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
                // Container(
                //     decoration: BoxDecoration(
                //       color: themeNotifier.light0Color,
                //       border: Border.all(color: themeNotifier.light3Color),
                //     ),
                //     child: SizedBox(height: 160, width: MediaQuery.of(context).size.width, child: PainterView(provider.otherPartyPainterController))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addSignature(BuildContext context, PainterController painterController, String title, ThemeNotifier themeNotifier, AuditVisitViewProvider provider) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 240,
                child: Container(
                    decoration: BoxDecoration(
                      color: themeNotifier.light0Color,
                      border: Border.all(color: themeNotifier.light3Color),
                    ),
                    child: PainterView(painterController))),
            actions: [
              TextButton(
                child: Text("Clear".tr()),
                onPressed: () {
                  painterController.clear();
                  provider.signatureUpdated();
                },
              ),
              TextButton(
                onPressed: () async {
                  provider.signatureUpdated();
                  Navigator.of(dialogContext).pop();
                },
                child: Text("Okay".tr()),
              ),
            ],
          );
        });
  }
}
