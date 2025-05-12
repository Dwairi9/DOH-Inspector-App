import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/views/checklist_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChecklistListScreen extends ConsumerWidget {
  final ChangeNotifierProvider<InspectionProvider> inspectionProvider;
  const ChecklistListScreen({
    Key? key,
    required this.inspectionProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          //   backgroundColor: themeNotifier.dark3Color,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checklists'.tr(), style: const TextStyle(color: Colors.white, fontSize: 24)),
            ],
          ),
        ),
        body: SafeArea(
            child: Align(
          alignment: Alignment.topCenter,
          child: ChecklistListView(inspectionProvider: inspectionProvider),
        )));
  }
}
