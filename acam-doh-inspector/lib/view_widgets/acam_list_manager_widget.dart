import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AcamListManagerSortByOrder { asc, desc }

enum AcamListManagerType { sort, group }

abstract class AcamListManagerProvider<T> {
  TextEditingController get filterController;
  AcamListManagerSortByOrder get sortByOrder;
  AcamListManagerType get managerType;
  set sortByOrder(AcamListManagerSortByOrder sortByOrder);
  T get sortBy;
  set sortByAsString(String sortBy);
  String get filterText;
  set filterText(String filterText);
  List<String> getSortByTypes();
  String getSortByTypeTitle(T sortBy);
}

class AcamListManagerWidget extends ConsumerWidget {
  const AcamListManagerWidget(
    this.provider, {
    super.key,
  });

  final AcamListManagerProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 42, maxHeight: 42, maxWidth: 400),
                child: TextField(
                  controller: provider.filterController,
                  onChanged: (value) {
                    provider.filterText = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: themeNotifier.light4Color),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    hintText: "Filter By".tr(),
                    suffixIcon: provider.filterText.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: themeNotifier.light4Color, size: 20),
                            splashRadius: 10,
                            onPressed: () {
                              provider.filterText = '';
                              provider.filterController.clear();
                            })
                        : null,
                    prefixIcon: Icon(Icons.filter_alt_rounded,
                        color: themeNotifier.light4Color), /* hintText: 'search by record id or record type...'.tr(), hintStyle: TextStyle(fontSize: 12)*/
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.scale(
                  scaleY: provider.sortByOrder == AcamListManagerSortByOrder.desc ? 1 : -1,
                  child: AcamIcon(
                    iconColor: themeNotifier.primaryColor,
                    icon: Icons.sort,
                    condensed: true,
                    onTap: () async {
                      provider.sortByOrder =
                          provider.sortByOrder == AcamListManagerSortByOrder.desc ? AcamListManagerSortByOrder.asc : AcamListManagerSortByOrder.desc;
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 140,
                  height: 42,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.getSortByTypeTitle(provider.sortBy),
                      elevation: 4,
                      isExpanded: true,
                      focusColor: Colors.transparent,
                      alignment: Alignment.bottomLeft,
                      isDense: true,
                      style: TextStyle(color: themeNotifier.primaryColor),
                      onChanged: (String? value) {
                        provider.sortByAsString = value ?? '';
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: themeNotifier.primaryColor,
                      ),
                      items: provider.getSortByTypes().map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                // DropdownMenu<String>(
                //   initialSelection: provider.getSortByTypeTitle(provider.sortBy),
                //   enableSearch: false,
                //   enableFilter: false,
                //   onSelected: (String? value) {
                //     provider.sortByAsString = value ?? '';
                //   },
                //   dropdownMenuEntries: provider.getSortByTypes().map<DropdownMenuEntry<String>>((String value) {
                //     return DropdownMenuEntry<String>(value: value, label: value);
                //   }).toList(),
                // ),
                // InkWell(
                //   child: SizedBox(
                //     width: 130,
                //     child: Padding(
                //       padding: const EdgeInsets.only(top: 8, bottom: 8),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           const SizedBox(
                //             width: 4,
                //           ),
                //           Expanded(
                //             child: AutoSizeText(
                //                 minFontSize: 12,
                //                 maxLines: 1,
                //                 overflow: TextOverflow.ellipsis,
                //                 provider.getSortByTypeTitle(provider.sortBy),
                //                 style: Theme.of(context).textTheme.headlineMedium),
                //           ),
                //           const SizedBox(
                //             width: 8,
                //           ),
                //           Icon(Icons.keyboard_arrow_down, color: themeNotifier.primaryColor),
                //         ],
                //       ),
                //     ),
                //   ),
                //   onTap: () async {
                //     var sortBy = await showDialog<String>(
                //         context: context,
                //         builder: (BuildContext dialogContext) {
                //           return SimpleDialog(
                //             title: Text(provider.managerType == AcamListManagerType.sort ? 'Sort By'.tr() : 'Group By'.tr(),
                //                 style: Theme.of(context).textTheme.headlineLarge),
                //             children: provider
                //                 .getSortByTypes()
                //                 .map((e) => SimpleDialogOption(
                //                       child: Text(e.tr(), style: Theme.of(context).textTheme.headlineMedium),
                //                       onPressed: () {
                //                         Navigator.of(dialogContext).pop(e);
                //                       },
                //                     ))
                //                 .toList(),
                //           );
                //         });

                //     if (sortBy == null) {
                //       return;
                //     }

                //     provider.sortByAsString = sortBy;
                //   },
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
