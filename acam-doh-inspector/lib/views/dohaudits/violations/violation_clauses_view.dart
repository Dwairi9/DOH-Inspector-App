import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../data_models/violationCategory.dart';
import '../../../view_providers/dohaudits/audit_visit_view_provider.dart';

class ViolationClausesView extends ConsumerWidget {
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  const ViolationClausesView({required this.auditVisitViewProvider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);

    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Violation Clauses',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text('Count ${provider.violationClauses.length}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                Divider(
                  height: 25,
                  color: Colors.grey.shade700,
                ),
                if(provider.isViolationEditable)
                  Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              value: false,
                              onChanged: (value) =>
                                  {provider.selectAll(value ?? false)},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text('Select All',
                          style: Theme.of(context).textTheme.bodySmall!),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(height: 30),
                          child: ElevatedButton(
                            onPressed: () => ref.read(auditVisitViewProvider).addViolationClause(),
                            child: Text(
                              'Add'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(height: 30),
                          child: ElevatedButton(
                            onPressed: () => ref
                              .read(auditVisitViewProvider)
                              .deleteSelectedViolationClause(),
                            child: Text(
                              'Delete'.tr(),
                              style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                //const SizedBox(height: 10,),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final provider = ref.watch(auditVisitViewProvider);
                      return ListView.builder(
                          itemCount: provider.violationClauses.length,
                          itemBuilder: (_, index) => ViolationClausesCell(
                              auditVisitViewProvider: auditVisitViewProvider,
                              index: index));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (provider.isLoading)
          Positioned.fill(
            // Allow taps to pass through if needed
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent, // Keep screen visible
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(), SizedBox(height: 12)],
              ),
            ),
          ),
      ],
    );
  }
}

class ViolationClausesCell extends ConsumerWidget {
  final int index;
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  const ViolationClausesCell(
      {required this.index, required this.auditVisitViewProvider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);
    final clause = provider.violationClauses[index];

    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          // height: 200,
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.5),
            //borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      value: clause.isSelected,
                      onChanged: (value) => {
                        ref.read(auditVisitViewProvider).toggleSelect(index, value!),
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.fromLTRB(8, 4, 8, 4),
                    fillColor: Colors.white,
                    filled: true,
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: themeNotifier.light3Color, width: 0.0),
                    // ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: clause.violationMode.isEmpty ? null : !clause.violationMode.contains('No97') ? null : clause.violationMode,
                      elevation: 16,
                      isExpanded: true,
                      hint: Text("Select Violation Mode".tr()),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).hintColor, // Optional: make it look like a placeholder
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          ref.read(auditVisitViewProvider).updateViolationClauseMode(index, value);
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade800,
                      ),
                      items: [
                        ...provider.violationClauseModes.map<DropdownMenuItem<String>>((ViolationCategory item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: AutoSizeText(
                              item.text,
                              minFontSize: 11,
                              stepGranularity: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  )
                ),
              ),

              const SizedBox(height: 1, ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Violation Mode')
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      Text(
                        clause.violationModeError,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.red
                        ),
                      )
                    ],
                  )
                ]
              ),

              const SizedBox( height: 10),

              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownSearch<String>(
                  selectedItem: clause.violationType.isEmpty ? null : clause.violationType,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search violation type",
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    itemBuilder: (context, item, isSelected) {
                      final index = clause.availableTypes.indexWhere((e) => e.value == item);
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: index.isOdd ? Colors.grey[200] : Colors.grey[300],
                        child: Text(clause.availableTypes[index].text),
                      );
                    },
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Select Violation Type".tr(),
                    ),
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      ref.read(auditVisitViewProvider).updateViolationClauseType(index, value);
                    }
                  },
                  items: clause.availableTypes.map((e) => e.value).toList(),
                  dropdownBuilder: (context, selectedItem) {
                    final item = clause.availableTypes.firstWhere(
                          (e) => e.value == selectedItem,
                          orElse: () => ViolationCategory(text: "", value: ""),
                    );
                    return Text(selectedItem == null ? "Select Violation Type".tr() : item.text);
                  },
                ),
              ),

              const SizedBox( height: 1),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Violation Type')
                    ],
                  ),
                const SizedBox(width: 40),
                  Column(
                    children: [
                      Text(
                        clause.violationTypeError,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.red
                        ),
                      )
                    ],
                  )
              ]),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ViolationClausesTitleSubtitleView(
                      title: clause.violationReference,
                      subTitle: 'Violation Reference',
                    ),
                  ),

                  const SizedBox( width: 10 ),

                  Expanded(
                    child: ViolationClausesTitleSubtitleView(
                      title: clause.violationAmount,
                      subTitle: 'Violation Amount',
                    )
                  ),

                  const SizedBox( width: 10 ),
                  const Text( 'AED' ),
                  const SizedBox( width: 10 ),
                ],
              ),

              const SizedBox( height: 10 ),

              Row(
                children: [
                  Expanded(
                    child: ViolationClausesTitleSubtitleView(
                      title: clause.violationOccurrence,
                      subTitle: 'Occurrence'
                    )
                  ),

                  const SizedBox( width: 10 ),

                  Expanded(
                    child: ViolationClausesTitleSubtitleView(
                      title: clause.violationFollowUp,
                      subTitle: 'Follow Up'
                    )
                  ),

                  const SizedBox( width: 10 ),
                  const Text( 'days' ),
                  const SizedBox( width: 10 ),
                ],
              ),

              const SizedBox( height: 10 ),

              Row(
                children: [
                  Expanded(
                      child: ViolationClausesTitleSubtitleView(
                          title: clause.violationFeeNumber,
                          subTitle: 'Number'
                      )
                  ),

                  const SizedBox( width: 10 ),
                ],
              ),

              const SizedBox(height: 10 ),

              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ViolationClausesTitleSubtitleView(
                  title: clause.violationAction,
                  subTitle: 'Action',
                )
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: clause.violationRemarksController,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: null),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      "Remarks",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: 12,
          child: Container(
            padding: const EdgeInsets.only(left: 2, right: 2),
            //margin: EdgeInsets.fromLTRB(0, 0,0, 0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Text((index + 1).toString(), style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
      ],
    );
  }
}

class ViolationClausesTitleSubtitleView extends StatelessWidget {
  const ViolationClausesTitleSubtitleView({
    required this.title,
    required this.subTitle,
    this.isArabic = false,
    this.isEnabled = false,
    super.key,
  });

  final String title;
  final String subTitle;
  final bool isArabic;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            enabled: isEnabled,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isEnabled ? Colors.black : null),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              //errorText: field.valid ? null : "required field".tr(),
              hintText: title,
            ),
            onChanged: null),
        const SizedBox(
          height: 1,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
        ),
      ],
    );
  }
}
