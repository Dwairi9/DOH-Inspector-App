import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayTableWidget extends ConsumerWidget {
  const DisplayTableWidget({
    Key? key,
    required this.numberOfColumns,
    required this.columnSizes,
    required this.widgets,
  }) : super(key: key);

  final int numberOfColumns;
  final Map<int, double> columnSizes;
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Table(
        columnWidths: columnSizes.map((key, value) => MapEntry(key, FlexColumnWidth(value))),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: List.generate((widgets.length / numberOfColumns).ceil(), (int rowIdx) {
          return TableRow(
              children: List.generate(numberOfColumns, (int cellIdx) {
            var globalCellIdx = (rowIdx * numberOfColumns) + cellIdx;
            Widget? cell;
            if (globalCellIdx < widgets.length) {
              cell = widgets[globalCellIdx];
            }

            if (cell != null) {
              return TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: cell,
              );
            } else {
              return TableCell(child: Container());
            }
          }));
        }));
  }
}
