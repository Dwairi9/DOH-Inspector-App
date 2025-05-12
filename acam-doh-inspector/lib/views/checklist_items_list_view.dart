import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/Widgets/better_expansion_tile.dart';
import 'package:aca_mobile_app/data_models/checklist_item.dart';
import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/description/checklist_item_status_group_item.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:aca_mobile_app/view_providers/checklist_item_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/component_manager_view_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:aca_mobile_app/view_widgets/acam_utility.dart';
import 'package:aca_mobile_app/views/component_manager_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:scroll_to_index/scroll_to_index.dart';

class ChecklistItemsListView extends ConsumerWidget {
  const ChecklistItemsListView({Key? key, required this.inspectionProvider, required this.checklistIdx}) : super(key: key);

  final int checklistIdx;
  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(inspectionProvider);
    final themeNotifier = ref.watch(themeProvider);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.inspection == null) {
      return Center(
          child: Text(
        'No Data'.tr(),
        style: Theme.of(context).textTheme.headlineLarge,
      ));
    }
    List<ChecklistItem> checklistItems = provider.getChecklistItems(checklistIdx);

    return Column(
      children: [
        if (provider.isSaving)
          LinearProgressIndicator(
            color: themeNotifier.primaryColor,
            backgroundColor: Colors.transparent,
          )
        else
          const SizedBox(
            height: 4,
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: AcamListManagerWidget(provider),
        ),
        const Divider(),
        const SizedBox(
          height: 16,
        ),
        if (Constants.isDebug)
          TextButton(
              onPressed: () {
                provider.randomFillChecklistItems(checklistIdx);
              },
              child: const Text("Random Fill")),
        Expanded(
          child: ListView.builder(
              itemCount: checklistItems.length,
              shrinkWrap: true,
              controller: provider.scrollController,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: provider.scrollController,
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: ChecklistItemCardWidget(
                        checklistItem: checklistItems[index],
                        inspectionProvider: inspectionProvider,
                        checklistIdx: checklistIdx,
                        checklistItemIdx: index,
                        checklistItemsCount: checklistItems.length),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class ChecklistItemCardWidget extends ConsumerWidget {
  const ChecklistItemCardWidget({
    Key? key,
    required this.checklistItem,
    required this.inspectionProvider,
    required this.checklistIdx,
    required this.checklistItemIdx,
    required this.checklistItemsCount,
  }) : super(key: key);

  final ChecklistItem checklistItem;
  final int checklistIdx;
  final int checklistItemIdx;
  final int checklistItemsCount;
  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;

  viewChecklistItemText(BuildContext context, ChecklistItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.textDisp.isNotEmpty ? item.textDisp : item.text),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Okay".tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  viewChecklistItemGuidelines(BuildContext context, ChecklistItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.guidelines),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Okay".tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  editChecklistItemScore(BuildContext context, ChangeNotifierProvider<InspectionProvider> inspectionProvider, ChecklistItem item) {
    var textController = TextEditingController(text: item.scoreEdit == -2 ? "" : item.scoreEdit.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            InspectionProvider provider = ref.watch(inspectionProvider);
            return AlertDialog(
              title: Text("Edit Checklist Item Score".tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    onChanged: (String value) {
                      int score = int.tryParse(value) ?? -1;

                      textController.selection = TextSelection.collapsed(offset: textController.text.length);

                      if (value.isEmpty) {
                        score = -1;
                        provider.setChecklistItemScoreError(checklistItem, "");
                      } else if (score == -1) {
                        provider.setChecklistItemScoreError(checklistItem, "Item score must be a valid number".tr());
                      } else if (item.maxPoints > 0 && score > item.maxPoints) {
                        provider.setChecklistItemScoreError(checklistItem, "Item score must be less than or equal to the max score".tr());
                      } else {
                        provider.setChecklistItemScoreError(checklistItem, "");
                      }

                      provider.setChecklistItemScore(item, score);
                      provider.setChecklistSaved(checklistIdx, false);
                    },
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Score".tr(),
                    ),
                  ),
                  if (checklistItem.maxPoints > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        "${"Max Score".tr()} (${checklistItem.maxPoints})",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: item.scoreError.isNotEmpty ? Text(item.scoreError, style: const TextStyle(color: Colors.red)) : null,
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancel".tr()),
                  onPressed: () {
                    provider.discardChecklistItemScore(checklistItem);
                    textController.dispose();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: checklistItem.scoreError.isEmpty && checklistItem.scoreEdit >= 0
                      ? () {
                          provider.saveChecklistItemScore(checklistItem);
                          textController.dispose();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Text("Save".tr()),
                ),
              ],
            );
          });
        });
  }

  editAttachments(BuildContext context, InspectionProvider provider, ChecklistItemProvider itemProvider) {
    List<BaseComponentViewProvider> componentList = [];

    var attachmentViewProvider = AttachmentViewProvider(
      ParentComponentType.checklistItem,
      attachmentObserver: itemProvider,
      inspectionId: provider.inspection?.idNumber ?? 0,
      checklistId: itemProvider.getChecklistId(),
      checklistItemId: itemProvider.getChecklistItemId(),
      recordId: RecordId(customId: provider.inspection?.customId ?? ""),
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

  editChecklistItemAsi(BuildContext context, InspectionProvider provider, ChecklistItem item) {
    var asiDescriptionList = provider.getChecklistItemAsiDescription(item);
    if (asiDescriptionList?.isEmpty ?? true) {
      return;
    }
    var asitDescriptionList = provider.getChecklistItemAsitDescription(item);
    List<BaseComponentViewProvider> componentList = [];

    var asiComponents = asiDescriptionList?.map((e) {
          return AsiComponentViewProvider(
            e,
            title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
            values: provider.getChecklistItemAsiValues(item, e.subgroup) ?? {},
          );
        }).toList() ??
        [];
    var asitComponents = asitDescriptionList?.map((e) {
          return AsitComponentViewProvider(
            e,
            title: e.subgroupDisp.isNotEmpty ? e.subgroupDisp : e.subgroup,
            values: provider.getChecklistItemAsitValues(item, e.subgroup),
          );
        }).toList() ??
        [];
    componentList.addAll(asiComponents);
    componentList.addAll(asitComponents);
    ComponentManagerViewProvider componentManagerViewProvider = ComponentManagerViewProvider(componentList, initialExpandState: InitialExpandState.all);
    WidgetUtil.showFullScreenDialog(
        context,
        ComponentManagerView(
          componentManagerViewProvider,
          scrollable: false,
        ),
        "Edit Checklist Item Custom Fields & Tables".tr(),
        [
          FullScreenActionButton(
              title: "Save".tr(),
              callback: componentManagerViewProvider.isLoading
                  ? null
                  : (context, loader) async {
                      if (!componentManagerViewProvider.isValid()) {
                        Utility.showAlert(context, "Validation".tr(), "Please Correct the Errors in the Form".tr());
                        return;
                      }
                      for (var component in componentList) {
                        if (component.type == ComponentType.asi) {
                          AsiComponentViewProvider asiComponent = component as AsiComponentViewProvider;
                          provider.setChecklistItemAsiValues(item, asiComponent.getGroupName(), asiComponent.getAsiValuesAsStrings());
                        } else if (component.type == ComponentType.asit) {
                          AsitComponentViewProvider asitComponent = component as AsitComponentViewProvider;
                          provider.setChecklistItemAsitValues(item, asitComponent.getGroupName(), asitComponent.getAsitRowsAsStrings());
                        }
                      }
                      componentManagerViewProvider.setLoading(true);
                      var actionObject = await provider.updateChecklistItemAsiAsit(item);
                      componentManagerViewProvider.setLoading(false);
                      if (context.mounted) AcamUtility.showMessageForActionObject(context, actionObject);

                      if (actionObject.success && context.mounted) Navigator.pop(context);
                    })
        ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(inspectionProvider);
    final checklistItemProvider = ref.watch(checklistItem.getChecklistItemProvder());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, maxWidth: MediaQuery.of(context).size.width),
          child: Container(
            decoration: BoxDecoration(
              color: themeNotifier.light0Color,
              //   border: Border.all(color: themeNotifier.dark1Color),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: InkWell(
                            child: AutoSizeText(checklistItem.textDisp.isNotEmpty ? checklistItem.textDisp : checklistItem.text,
                                minFontSize: 11,
                                stepGranularity: 1,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineMedium),
                            onTap: () {
                              viewChecklistItemText(context, checklistItem);
                            })),
                    const SizedBox(height: 24),
                    if (checklistItem.guidelines.isNotEmpty) ...[
                      BetterExpansionTile(
                        initiallyExpanded: checklistItemProvider.checklistItemGuidelinesExpanded(),
                        // expandController: provider.getComponent(index).betterExpansionTileController,
                        title: Text("Guidelines".tr(), style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
                        trailing: Icon(
                          checklistItemProvider.checklistItemGuidelinesExpanded() ? Icons.remove : Icons.add,
                          color: themeNotifier.iconColor,
                        ),
                        collapsedBackgroundColor: themeNotifier.light0Color,
                        backgroundColor: themeNotifier.light0Color,
                        onExpansionChanged: (bool isExpanded) {
                          checklistItemProvider.setChecklistItemGuidelinesExpanded(isExpanded);
                        },
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (checklistItemProvider.checklistItemGuidelinesExpanded())
                            Align(
                                alignment: Utility.isRTL(context) ? Alignment.centerRight : Alignment.centerLeft,
                                child: Text(checklistItem.guidelines, style: Theme.of(context).textTheme.headlineMedium)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (checklistItem.previousStatus.isNotEmpty) ...[
                      Text("${"Previous Status".tr()}: ${checklistItem.previousStatus}",
                          style:
                              Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: themeNotifier.orangeColor)),
                      const SizedBox(height: 12),
                    ],
                    if (checklistItem.isStatusVisible || checklistItem.isScoreVisible)
                      Row(
                        mainAxisAlignment: provider.showStarRating(checklistItem) ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                fillColor: Colors.transparent,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeNotifier.light3Color, width: 0.0),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: checklistItem.status.isNotEmpty ? checklistItem.status : "",
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: themeNotifier.primaryColor),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      provider.setChecklistItemStatus(checklistItem, value);
                                      provider.setChecklistSaved(checklistIdx, false);
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
                                    ...provider
                                        .getChecklistItemStatusGroupItems(checklistItem.statusGroupName)
                                        .map<DropdownMenuItem<String>>((ChecklistItemStatusGroupItem item) {
                                      return DropdownMenuItem<String>(
                                        value: item.guideSheetItemStatus,
                                        child: AutoSizeText(
                                          item.guideSheetItemStatusDisp,
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
                              ),
                            ),
                          ),
                          if (checklistItem.isScoreVisible) const SizedBox(width: 42),
                          if (checklistItem.isScoreVisible)
                            InkWell(
                              child: badges.Badge(
                                badgeContent: Text(
                                  checklistItem.score.toString(),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                                ),
                                badgeColor: themeNotifier.primaryColor,
                                shape: badges.BadgeShape.square,
                                elevation: 0,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              onTap: () {
                                provider.setChecklistItemScoreError(checklistItem, "");
                                provider.setChecklistItemScore(checklistItem, checklistItem.score);
                                editChecklistItemScore(context, inspectionProvider, checklistItem);
                              },
                            ),
                          if (checklistItem.isScoreVisible) const SizedBox(width: 16),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Divider(height: 1, thickness: 1, indent: 0, endIndent: 0, color: themeNotifier.light3Color),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (checklistItem.isCommentVisible)
                          badges.Badge(
                            badgeContent: Text(
                              "1",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                            ),
                            elevation: 0,
                            showBadge: checklistItem.comment.isNotEmpty,
                            badgeColor: themeNotifier.orangeColor,
                            padding: const EdgeInsets.all(8),
                            position: badges.BadgePosition.topEnd(top: -12, end: -6),
                            child: AcamIcon(
                              icon: Icons.comment_outlined,
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => EditCommentDialog(provider: provider, item: checklistItem, checklistIdx: checklistIdx),
                              ),
                              condensed: true,
                              iconSize: 34,
                              text: "Comments".tr(),
                              iconColor: themeNotifier.primaryColor,
                            ),
                          ),
                        badges.Badge(
                          badgeContent: Text(
                            "${checklistItemProvider.getAttachments.length}",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                          ),
                          elevation: 0,
                          showBadge: checklistItemProvider.getAttachments.isNotEmpty,
                          badgeColor: themeNotifier.orangeColor,
                          padding: const EdgeInsets.all(8),
                          position: badges.BadgePosition.topEnd(top: -12, end: -6),
                          child: AcamIcon(
                            icon: Icons.file_present,
                            text: "Attachments".tr(),
                            onTap: () => editAttachments(context, provider, checklistItemProvider),
                            condensed: true,
                            iconSize: 34,
                            iconColor: themeNotifier.primaryColor,
                          ),
                        ),
                        if (checklistItem.isAsiVisible)
                          badges.Badge(
                            elevation: 0,
                            showBadge: false,
                            badgeColor: themeNotifier.orangeColor,
                            padding: const EdgeInsets.all(8),
                            position: badges.BadgePosition.topEnd(top: -12, end: -6),
                            child: AcamIcon(
                              icon: Icons.backup_table,
                              text: "Additional Info".tr(),
                              onTap: () => editChecklistItemAsi(context, provider, checklistItem),
                              condensed: true,
                              iconSize: 34,
                              iconColor: themeNotifier.primaryColor,
                            ),
                          ),
                        // if (checklistItem.guidelines.isNotEmpty && false)
                        //   AcamIcon(
                        //     icon: Icons.backup_table,
                        //     text: "Guidelines".tr(),
                        //     onTap: () => viewChecklistItemGuidelines(context, checklistItem),
                        //     condensed: true,
                        //     iconSize: 34,
                        //     iconColor: themeNotifier.primaryColor,
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 0),
                  ],
                )),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}

class EditCommentDialog extends ConsumerStatefulWidget {
  final InspectionProvider provider;
  final ChecklistItem item;
  final int checklistIdx;

  const EditCommentDialog({Key? key, required this.provider, required this.item, required this.checklistIdx}) : super(key: key);

  @override
  ConsumerState<EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends ConsumerState<EditCommentDialog> {
  late final TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController(text: widget.item.comment);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Checklist Item Comments".tr()),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Comment".tr(),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel".tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Save".tr()),
          onPressed: () {
            widget.provider.setChecklistItemComment(widget.item, commentController.text);
            widget.provider.setChecklistSaved(widget.checklistIdx, false);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
