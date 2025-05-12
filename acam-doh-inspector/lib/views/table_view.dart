import 'package:aca_mobile_app/view_providers/table_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableView extends ConsumerStatefulWidget {
  late final ChangeNotifierProvider<TableViewProvider> tableProvider;

  TableView(TableViewProvider tableViewProvider, {Key? key}) : super(key: key) {
    tableProvider = ChangeNotifierProvider<TableViewProvider>((ref) => tableViewProvider);
  }

  @override
  ConsumerState<TableView> createState() => _TableViewState();
}

class _TableViewState extends ConsumerState<TableView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(widget.tableProvider);
    var scrollBar = Scrollbar(
      thumbVisibility: true,
      thickness: 14,
      controller: _scrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: PaginatedDataTable(
        controller: _scrollController,
        sortColumnIndex: provider.sortColumnIndex,
        sortAscending: provider.sortAsc,
        showCheckboxColumn: provider.isSelectable(),
        rowsPerPage: provider.getRowsPerPage(),
        columns: provider.getColumns(context),
        source: DataSource(context, provider),
        onPageChanged: (value) => provider.setCurrentRow(value),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: scrollBar,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DataSource extends DataTableSource {
  final BuildContext context;
  final TableViewProvider provider;

  DataSource(this.context, this.provider);

  @override
  DataRow? getRow(int index) {
    if (index >= provider.getRowCount()) {
      return null; // empty row
    }
    return DataRow.byIndex(
        index: index,
        selected: provider.isRowSelected(index),
        onSelectChanged: (selected) {
          if (provider.isRowSelected(index) != selected) {
            provider.setRowSelected(index, selected ?? false);
          }
        },
        cells: getRowCells(index));
  }

  List<DataCell> getRowCells(int rowIdx) {
    var rowCells = provider.getRowFields(rowIdx).map((e) {
      final rowValue = e.getValueAsString(forDisplay: true, datesAsIs: true);

      return DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  rowValue,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          onTap: provider.isReadOnly ? () => provider.onCellTap(rowIdx, e) : null);
    }).toList();

    if (provider.addValidatorColumn) {
      final rowValid = provider.isRowValid(rowIdx);

      rowCells.insertAll(0, [
        DataCell(Center(
            child: rowValid
                ? Icon(
                    provider.validatorColumnIconValid ?? Icons.check_circle,
                    color: Colors.green,
                  )
                : isFirstInvalidRow(rowIdx)
                    ? Icon(
                        provider.validatorColumnIconInvalid ?? Icons.warning,
                        color: Colors.amber[800],
                      )
                    : const Text("")))
      ]);
    }

    if (provider.actions?.isNotEmpty ?? false) {
      rowCells.insertAll(
          rowCells.length,
          provider.actions
                  ?.map((e) => DataCell(Center(
                        child: IconButton(
                          padding: const EdgeInsets.all(8),
                          icon: e.icon!,
                          splashRadius: 28,
                          onPressed: () {
                            if (e.callback != null) {
                              e.callback!(context, rowIdx, e.title);
                            }
                          },
                        ),
                      )))
                  .toList() ??
              []);
    }
    List<TableActionButton> rowActionButtons = provider.getRowTableActionButtons(rowIdx);

    rowCells.add(DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: rowActionButtons
          .map((e) => IconButton(
                padding: const EdgeInsets.all(8),
                icon: e.icon!,
                splashRadius: 28,
                onPressed: () {
                  if (e.callback != null) {
                    e.callback!(context, rowIdx, e.title);
                  }
                },
              ))
          .toList(),
    )));

    return rowCells;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => provider.getRowCount();

  @override
  int get selectedRowCount => provider.getSelectedCount();

  bool isFirstInvalidRow(int rowIdx) {
    for (var i = 0; i < provider.getRowCount(); i++) {
      if (i >= rowIdx) {
        return true;
      }

      var rowValid = provider.isRowValid(i);

      if (!rowValid) {
        return false;
      }
    }

    return true;
  }
}
