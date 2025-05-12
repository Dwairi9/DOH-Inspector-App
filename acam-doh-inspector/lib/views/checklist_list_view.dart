import 'package:aca_mobile_app/data_models/checklist.dart';
import 'package:aca_mobile_app/data_models/checklist_item.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/screens/checklist_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class ChecklistListView extends ConsumerWidget {
  const ChecklistListView({Key? key, required this.inspectionProvider}) : super(key: key);

  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(inspectionProvider);
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
    Inspection inspection = provider.inspection!;

    return ListView.builder(
        itemCount: inspection.checklists.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: ChecklistCardWidget(inspectionProvider: inspectionProvider, checklist: inspection.checklists[index]),
          );
        });
  }
}

class ChecklistCardWidget extends ConsumerWidget {
  const ChecklistCardWidget({
    Key? key,
    required this.checklist,
    required this.inspectionProvider,
  }) : super(key: key);

  final Checklist checklist;
  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(inspectionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: InkWell(
            onTap: !(provider.inspection?.editable == true)
                ? null
                : () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: ChecklistScreen(
                              inspectionProvider: inspectionProvider,
                              checklistIdx: ref.read(inspectionProvider).inspection!.checklists.indexOf(checklist),
                            )));
                  },
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      checklist.guideTypeDisp.isNotEmpty ? checklist.guideTypeDisp : checklist.guideType,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: !(provider.inspection?.editable == true) ? themeNotifier.light4Color : themeNotifier.primaryColor),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text("Progress".tr(), style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(width: 12),
                        Text("${getNumberOfCompletedItems(checklist.checklistItems)}${Utility.isRTL(context) ? "\\" : "/"}${checklist.checklistItems.length}",
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),

                    // const Icon(Icons.arrow_forward_ios),
                  ],
                )),
          ),
        ),
        Divider(height: 1, thickness: 1, indent: 0, endIndent: 0, color: themeNotifier.light3Color),
      ],
    );
  }

  int getSumOfScores(List<ChecklistItem> checklistItems) {
    int sum = 0;
    for (var item in checklistItems) {
      sum += item.score;
    }
    return sum;
  }

  int getNumberOfCompletedItems(List<ChecklistItem> checklistItems) {
    int count = 0;
    for (var item in checklistItems) {
      if (item.status.isNotEmpty) {
        count++;
      }
    }
    return count;
  }
}
