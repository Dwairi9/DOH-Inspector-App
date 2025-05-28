import 'package:aca_mobile_app/providers/error_message_provider.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/views/accela_unified_form_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class AcamIcon extends ConsumerWidget {
  const AcamIcon(
      {Key? key, required this.icon, this.text, this.onTap, this.iconColor, this.condensed = false, this.textColor, this.disabled = false, this.iconSize})
      : super(key: key);

  final String? text;
  final IconData icon;
  final Function? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool condensed;
  final bool disabled;
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          IconButton(
            padding: EdgeInsets.all(condensed ? 2 : 16),
            iconSize: iconSize ?? (condensed ? 24 : 28),
            icon: Icon(icon),
            splashRadius: condensed ? 18 : 28,
            // tooltip: this.text,
            color: iconColor ?? themeNotifier.iconColor,
            onPressed: disabled
                ? null
                : () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
          ),
          if (text != null && text?.isNotEmpty == true)
            Text(text!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: textColor ?? Theme.of(context).textTheme.labelSmall?.color,
                      height: 1,
                    )),
        ],
      ),
    );
  }
}

class FullScreenDialog extends ConsumerWidget {
  final Widget content;
  final List<FullScreenActionButton> actions;
  final String title;
  final String? subtitle;
  final void Function(BuildContext context)? onClose;
  final loadingProvider = StateProvider<bool>((_) => false);
  final WidgetBuilder? subtitleBuilder;

  FullScreenDialog({super.key, required this.content, required this.title, required this.actions, this.onClose, this.subtitle, this.subtitleBuilder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
          child: Column(
            children: [
              AutoSizeText(title, maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 24)),
              if (subtitleBuilder != null)
                subtitleBuilder!(context)
              else if (subtitle != null)
                AutoSizeText(subtitle!,
                    maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        actions: actions
            .map((e) => TextButton(
                onPressed: () {
                  if (e.callback != null) {
                    e.callback!(context, ref.read(loadingProvider.notifier));
                  }
                },
                child: Text(
                  e.title,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                )))
            .toList(),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (onClose != null) {
                onClose!(context);
              } else {
                Navigator.of(context).pop();
              }
            }),
      ),
      body: content,
    );
  }
}

class ActionButton {
  String title;
  Icon? icon;
  void Function(BuildContext context)? callback;

  ActionButton({required this.title, this.callback, this.icon});
}

class FullScreenActionButton {
  String title;
  void Function(BuildContext context, StateController<bool> loader)? callback;

  FullScreenActionButton({required this.title, this.callback});
}

class WidgetUtil {
  static Future<T?> showFullScreenDialog<T extends Object?>(BuildContext context, Widget content, String title, List<FullScreenActionButton> actions,
      {void Function(BuildContext context)? onClose, String? subtitle, WidgetBuilder? subtitleBuilder}) async {
    return Navigator.push<T>(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 200),
            child: FullScreenDialog(
                content: content, title: title, actions: actions, onClose: onClose,
                subtitle: subtitle, subtitleBuilder: subtitleBuilder)));
  }

  static Future<T?> editAccelaUnifiedForm<T extends Object?>(BuildContext context, AccelaUnifiedFormProvider provider,
      {String title = 'Edit',
      String actionButtonTitle = 'Save',
      void Function(BuildContext context)? onSave,
      void Function(BuildContext context)? onClose,
      Future<bool> Function(BuildContext context, AccelaUnifiedFormProvider provider)? onBeforeSave,
      bool validate = true,
      bool showSaveButton = true,
      bool isEdit = true}) async {
    return Utility.showFullScreenDialog<T>(
        context,
        AccelaUnifiedFormView(
          provider,
          isEdit: isEdit,
          scrollable: true,
        ),
        title,
        [
          if (showSaveButton)
            FullScreenActionButton(
                title: actionButtonTitle.tr(),
                callback: (context, loader) async {
                  if (validate && !provider.isValid()) {
                    Utility.showAlert(context, "Validation".tr(), "Please Correct the Errors in the Form".tr());
                    return;
                  }

                  if (onBeforeSave != null) {
                    var success = await onBeforeSave(context, provider);
                    if (!success) {
                      return;
                    }
                  }

                  if (isEdit) {
                    provider.saveEdits();
                  }

                  if (!context.mounted) return;
                  if (onSave != null) {
                    onSave(context);
                  }

                  Navigator.of(context).pop();
                }),
        ], onClose: (BuildContext context) {
      if (isEdit) {
        provider.discardEdits();
      }
      if (onClose != null) {
        onClose(context);
      }
      Navigator.pop(context);
    });
  }
}

class TableCellData {
  static const int TYPE_TEXT = 1;
  static const int TYPE_DATE = 2;
  static const int TYPE_EMPTY = 3;
  String? title;
  String? value;
  DateTime? date;
  int? type;
  TableCellData({
    this.title,
    this.value = "",
    this.date,
    this.type = TYPE_TEXT,
  });
}

enum DataCardLabelPositon { top, bottom, none }

class DataCard extends ConsumerWidget {
  const DataCard(
      {Key? key,
      required this.numberOfColumns,
      required this.columnSizes,
      required this.cells,
      this.dense = false,
      this.disableShadow = false,
      this.labelPosition = DataCardLabelPositon.top,
      this.backgroundColor})
      : super(key: key);

  final int numberOfColumns;
  final Map<int, double> columnSizes;
  final List<TableCellData> cells;
  final bool dense;
  final bool disableShadow;
  final Color? backgroundColor;
  final DataCardLabelPositon labelPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? themeNotifier.getColor("light0"),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
          boxShadow: [
            if (!disableShadow)
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: Table(
            columnWidths: columnSizes.map((key, value) => MapEntry(key, FlexColumnWidth(value))),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate((cells.length / numberOfColumns).ceil(), (int rowIdx) {
              return TableRow(
                  children: List.generate(numberOfColumns, (int cellIdx) {
                var globalCellIdx = (rowIdx * numberOfColumns) + cellIdx;
                var cell = TableCellData(type: TableCellData.TYPE_EMPTY);
                if (globalCellIdx < cells.length) {
                  cell = cells[globalCellIdx];
                }

                if (cell.type != TableCellData.TYPE_EMPTY) {
                  return TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: dense ? const EdgeInsets.all(6.0) : const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (labelPosition == DataCardLabelPositon.top)
                            Text(
                              cell.title ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (cell.type == TableCellData.TYPE_TEXT)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 40),
                                child: Text(
                                  cell.value ?? '',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                            ),
                          if (cell.type == TableCellData.TYPE_DATE)
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: themeNotifier.iconColor),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  DateFormat.d().format(cell.date!),
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      cell.date!.year.toString(),
                                      style: TextStyle(fontSize: 10, color: themeNotifier.dark2Color),
                                    ),
                                    Text(
                                      DateFormat.MMM().format(cell.date!),
                                      style: TextStyle(fontSize: 11, color: themeNotifier.dark2Color),
                                    )
                                  ],
                                )
                              ],
                            ),
                          if (labelPosition == DataCardLabelPositon.bottom)
                            Text(
                              cell.title ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return TableCell(child: Container());
                }
              }));
            })));
  }
}

class InfoMessageWidget extends ConsumerWidget {
  const InfoMessageWidget({Key? key, required this.infoMessageProvider, this.borderRadius = 8}) : super(key: key);
  final double borderRadius;

  final ChangeNotifierProvider<InfoMessageProvider> infoMessageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(infoMessageProvider);

    if (!provider.showMessage) {
      return Container();
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: provider.color,
          //   borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                provider.icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Html(
                    data: "<div style='color:white'>${provider.textMessage.replaceAll("<font color=red>", "<font color=white>")}</div>",
                    // style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ),
              InkWell(
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () {
                  provider.closeMessage();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
