import 'package:aca_mobile_app/data_models/checklist.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_utility.dart';
import 'package:aca_mobile_app/views/checklist_items_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChecklistScreen extends ConsumerWidget {
  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;
  final int checklistIdx;
  const ChecklistScreen({
    Key? key,
    required this.inspectionProvider,
    required this.checklistIdx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(inspectionProvider);
    Checklist checklist = (provider.inspection?.checklists[checklistIdx])!;
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                saveChecklist(context, provider);
                Navigator.pop(context);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(checklist.guideTypeDisp.isNotEmpty ? checklist.guideTypeDisp : checklist.guideType, style: const TextStyle(color: Colors.white)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: provider.preventBarActions()
                    ? null
                    : () async {
                        saveChecklist(context, provider);
                      },
                child: Text('Save'.tr(), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
              ),
            ]),
        body: SafeArea(
            child: Align(
          alignment: Alignment.topCenter,
          child: ChecklistItemsListView(inspectionProvider: inspectionProvider, checklistIdx: checklistIdx),
        )));
  }

  saveChecklist(BuildContext context, InspectionProvider provider) async {
    if (provider.isChecklistSaved(checklistIdx)) {
      return;
    }
    provider.scrollController.jumpTo(0);
    var actionObject = await provider.saveChecklist(checklistIdx);
    if (actionObject.success) {
      provider.setChecklistSaved(checklistIdx, true);
    }
    if (context.mounted) AcamUtility.showMessageForActionObject(context, actionObject);
  }
}
