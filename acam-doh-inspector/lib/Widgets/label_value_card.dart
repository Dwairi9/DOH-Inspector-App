import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CardLabelPositon {
  top,
  bottom,
  none;

  static CardLabelPositon getCardLabelPosition(String labelPosition) {
    switch (labelPosition) {
      case 'top':
        return CardLabelPositon.top;
      case 'bottom':
        return CardLabelPositon.bottom;
      case 'none':
        return CardLabelPositon.none;
      default:
        return CardLabelPositon.none;
    }
  }
}

enum CardType { text, date, lineBreak }

class LabelValueCard extends ConsumerWidget {
  const LabelValueCard(
      {super.key,
      required this.label,
      required this.value,
      this.valueIcon,
      this.labelExtra = '',
      this.labelExtraColor,
      this.type = CardType.text,
      this.dateValue,
      this.isPadded = true,
      this.labelPosition = CardLabelPositon.none,
      this.customPadding = -1,
      this.valueMaxLines = 1});

  final CardLabelPositon labelPosition;
  final String label;
  final String labelExtra;
  final Color? labelExtraColor;
  final String value;
  final CardType type;
  final DateTime? dateValue;
  final Icon? valueIcon;
  final bool isPadded;
  final int valueMaxLines;
  final int customPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeNotifier = ref.watch(themeProvider);
    return Padding(
      padding: customPadding == -1 ? EdgeInsets.all(isPadded ? 8.0 : 0.0) : EdgeInsets.all(customPadding.toDouble()),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (labelPosition == CardLabelPositon.top)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  label,
                  minFontSize: 9,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1),
                ),
                if (labelExtra.isNotEmpty)
                  AutoSizeText(
                    minFontSize: 9,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    labelExtra,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1, color: labelExtraColor),
                  ),
              ],
            ),
          if (type == CardType.text)
            Row(
              children: [
                if (valueIcon != null) valueIcon!,
                if (valueIcon != null) const SizedBox(width: 6),
                Expanded(
                  child: AutoSizeText(
                    value,
                    maxLines: valueMaxLines,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          if (type == CardType.lineBreak) const SizedBox(height: 8),
          if (type == CardType.date && dateValue != null) ...[
            Row(
              children: [
                Icon(Icons.calendar_month, size: 20, color: themeNotifier.iconColor),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                  style: TextStyle(fontSize: 24, color: themeNotifier.dark2Color, height: 1, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 4,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //   dateValue!.year.toString(),
                      DateFormat.y(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString(),
                      style: TextStyle(fontSize: 12, color: themeNotifier.dark2Color, height: 0.8),
                    ),
                    Text(
                      DateFormat.MMM(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toUpperCase(),
                      style: TextStyle(fontSize: 11, color: themeNotifier.dark2Color, height: 1),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 2),
          ],
          if (labelPosition == CardLabelPositon.bottom)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  label,
                  minFontSize: 9,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1),
                ),
                if (labelExtra.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  AutoSizeText(
                    minFontSize: 9,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    labelExtra,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1, color: labelExtraColor),
                  )
                ],
              ],
            ),
          if (labelPosition == CardLabelPositon.none && labelExtra.isNotEmpty) ...[
            // const SizedBox(height: 4),
            AutoSizeText(
              minFontSize: 9,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              labelExtra,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1, color: labelExtraColor),
            )
          ],
        ],
      ),
    );
  }
}
