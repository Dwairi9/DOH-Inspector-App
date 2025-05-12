import 'package:aca_mobile_app/Widgets/display_table_widget.dart';
import 'package:aca_mobile_app/Widgets/label_value_card.dart';
import 'package:aca_mobile_app/data_models/mobile_card.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileCardWidget extends ConsumerWidget {
  const MobileCardWidget(
      {super.key, required this.mobileCard, this.customPadding = -1, this.forceLabel = false, this.forcedlabelPosition = CardLabelPositon.none});

  final MobileCard mobileCard;
  final int customPadding;
  final bool forceLabel;
  final CardLabelPositon forcedlabelPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // for (String header in mobileCard.headers)
        //   Padding(
        //     padding: customPadding == -1 ? const EdgeInsets.all(8.0) : EdgeInsets.all(customPadding.toDouble()),
        //     child: AutoSizeText(
        //       header,
        //       maxLines: 2,
        //       minFontSize: 12,
        //       overflow: TextOverflow.ellipsis,
        //       style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 19),
        //     ),
        //   ),
        for (CardEntry cardEntry in mobileCard.headerEntries)
          CardEntryWidget(
            cardEntry: cardEntry,
            customPadding: customPadding,
            forceLabel: forceLabel,
            forcedlabelPosition: forcedlabelPosition,
          ),
        DisplayTableWidget(
          numberOfColumns: 2,
          columnSizes: const {0: 2, 1: 1},
          widgets: [
            for (CardEntry cardEntry in mobileCard.entriesList)
              CardEntryWidget(
                cardEntry: cardEntry,
                customPadding: customPadding,
                forceLabel: forceLabel,
                forcedlabelPosition: forcedlabelPosition,
              ),
          ],
        ),
        for (CardEntry cardEntry in mobileCard.footerEntries)
          CardEntryWidget(
            cardEntry: cardEntry,
            customPadding: customPadding,
            forceLabel: forceLabel,
            forcedlabelPosition: forcedlabelPosition,
          ),
        // for (String footer in mobileCard.footers)
        //   Padding(
        //     padding: customPadding == -1 ? const EdgeInsets.all(8.0) : EdgeInsets.all(customPadding.toDouble()),
        //     child: AutoSizeText(
        //       footer,
        //       maxLines: 2,
        //       minFontSize: 12,
        //       overflow: TextOverflow.ellipsis,
        //       style: Theme.of(context).textTheme.headlineMedium,
        //     ),
        //   )
      ],
    );
  }
}

class CardEntryWidget extends ConsumerWidget {
  const CardEntryWidget({
    super.key,
    required this.cardEntry,
    required this.customPadding,
    required this.forceLabel,
    required this.forcedlabelPosition,
  });

  final CardEntry cardEntry;
  final int customPadding;
  final bool forceLabel;
  final CardLabelPositon forcedlabelPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return LabelValueCard(
      label: cardEntry.label,
      value: cardEntry.value,
      dateValue: cardEntry.date,
      customPadding: customPadding,
      valueMaxLines: cardEntry.numberOfLines,
      labelPosition: !forceLabel
          ? cardEntry.showLabel
              ? CardLabelPositon.getCardLabelPosition(cardEntry.labelPosition)
              : CardLabelPositon.none
          : forcedlabelPosition,
      labelExtra: cardEntry.extraLabel,
      labelExtraColor: themeNotifier.errorColor,
      type: cardEntry.type == "date"
          ? CardType.date
          : cardEntry.type == "lineBreak"
              ? CardType.lineBreak
              : CardType.text,
    );
  }
}
