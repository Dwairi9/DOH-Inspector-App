import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum TableSelectStyle { noSelect, singleSelect, multiSelect }

class TableViewProvider extends ChangeNotifier {
  List<TableViewRow> tableRows = [];
  List<UnifiedFieldDescription> fieldListDescriptions = [];
  bool sortAsc = true;

  // TODO: Workaround for processing status table, implement more elegantly
  bool showFirstInvalidOnly = false;
  int sortColumnIndex = 0;
  int rowsPerPage = 10;
  int currentRow = 0;

  bool addValidatorColumn;
  String? validatorColumnLabel;
  IconData? validatorColumnIconValid;
  IconData? validatorColumnIconInvalid;
  TableSelectStyle tableSelectStyle;
  bool isReadOnly = false;
  Function? onCellTapEvent;

  List<TableActionButton>? actions = [];

  TableViewProvider(
      {required this.fieldListDescriptions,
      this.rowsPerPage = 10,
      this.sortAsc = true,
      this.addValidatorColumn = false,
      this.actions,
      this.validatorColumnLabel,
      this.validatorColumnIconValid,
      this.validatorColumnIconInvalid,
      this.showFirstInvalidOnly = false,
      this.isReadOnly = false,
      this.tableSelectStyle = TableSelectStyle.noSelect});

  List<UnifiedFormField> getRowFields(int idx) {
    if (tableRows.length <= idx) {
      throw "Index not found in Table $idx";
    }
    return tableRows[idx].rowFields;
  }

  TableViewRow getTableRow(int idx) {
    if (tableRows.length <= idx) {
      throw "Index not found in Table $idx";
    }
    return tableRows[idx];
  }

  bool isSelectable() {
    return (tableSelectStyle == TableSelectStyle.singleSelect || tableSelectStyle == TableSelectStyle.multiSelect) && !isReadOnly;
  }

  List<UnifiedFormField> getSelectedRowFields() {
    return getRowFields(getSelectedRowIndex());
  }

  Map<String, Object?> getSelectedRowValues() {
    return getRowValuesByIdx(getSelectedRowIndex());
  }

  Map<String, Object?> getRowValuesByIdx(int idx) {
    return getRowValues(getTableRow(idx));
  }

  Map<String, Object?> getRowValues(TableViewRow row) {
    return row.getRowValues();
  }

  UnifiedFormField? getRowField(int idx, String fieldId) {
    return getTableRow(idx).getField(fieldId);
  }

  int getRowCount() {
    return tableRows.length;
  }

  setCurrentRow(int page) {
    currentRow = page;
    notifyListeners();
  }

  int getRowsPerPage() {
    int rowCount = getRowCount();

    if (rowCount == 0) {
      return 1;
    }

    // if (currentRow == 18) {
    //   return 10;
    // }

    // return rowsPerPage;

    // return rowCount % rowsPerPage == 0 ? rowsPerPage : rowCount % rowsPerPage;

    // int totalPages = (rowCount / rowsPerPage).ceil();

    if (currentRow + rowsPerPage <= rowCount) {
      return rowsPerPage;
    } else {
      return rowCount - currentRow;
    }
  }

  List<TableViewRow> getRows() {
    return tableRows;
  }

  List<Map<String, Object?>> getRowsValues() {
    return tableRows.map((e) => e.getRowValues()).toList();
  }

  List<Map<String, Object?>> getRowValuesAsStrings() {
    return tableRows.map((e) => e.getRowValuesAsString()).toList();
  }

  List<TableActionButton> getRowTableActionButtons(int rowIdx) {
    return tableRows[rowIdx].rowActionsButtons;
  }

  Object? getRowValue(int idx, String fieldId) {
    return getRowField(idx, fieldId)?.getFieldValue();
  }

  String getRowValueString(int idx, String fieldId) {
    return getRowField(idx, fieldId)?.getValueAsString() ?? '';
  }

  void onCellTap(int idx, UnifiedFormField formField) {
    if (onCellTapEvent != null) {
      onCellTapEvent!(idx, formField);
    }
  }

  UnifiedFieldDescription? getUnifiedFieldDescription(String fieldId) {
    var arr = fieldListDescriptions.where((element) => element.fieldId == fieldId).toList();

    if (arr.isNotEmpty) {
      return arr[0];
    }

    return null;
  }

  refresh() {
    notifyListeners();
  }

  void sortRows(String fieldId, int sortColumnIndex, bool asc) {
    sortAsc = asc;
    this.sortColumnIndex = sortColumnIndex;
    tableRows.sort((TableViewRow a, TableViewRow b) {
      var aValue = a.getFieldValueAsString(fieldId);
      var bValue = b.getFieldValueAsString(fieldId);

      if (asc) {
        return bValue.compareTo(aValue);
      } else {
        return aValue.compareTo(bValue);
      }
    });
    notifyListeners();
  }

  void addRow(Map<String, dynamic> values,
      {bool valid = true,
      Map<String, Object> additionalProperties = const {},
      List<TableActionButton> rowActionsButtons = const [],
      bool addSilently = false}) {
    var rowFields = fieldListDescriptions.map((e) => UnifiedFormField.fromDescription(e)).toList();
    var tableRow = TableViewRow(rowFields, selected: false, valid: valid, additionalProperties: additionalProperties, rowActionsButtons: rowActionsButtons);
    tableRow.setValuesFromString(values);

    tableRows.add(tableRow);
    if (!addSilently) {
      notifyListeners();
    }
  }

  void removeRow(int idx) {
    tableRows.removeAt(idx);
    notifyListeners();
  }

  void clearTable({bool clearSilently = false}) {
    tableRows.clear();
    if (!clearSilently) {
      notifyListeners();
    }
  }

  bool isRowSelected(int idx) {
    return tableRows[idx].selected;
  }

  void setRowSelected(int idx, bool selected) {
    if (isRowSelected(idx) != selected) {
      // this is used only for Select from account/ look up if only 1 row allowed to be selected
      if (tableSelectStyle == TableSelectStyle.singleSelect) {
        for (var element in tableRows) {
          element.selected = false;
        }
      }
      tableRows[idx].selected = selected;
      notifyListeners();
    }
  }

  void validateRows() {
    getRows().forEach((row) {
      row.valid = row.isValid();
    });

    notifyListeners();
  }

  bool isRowValid(int idx) {
    return getTableRow(idx).valid;
  }

  void setRowValidFlag(int idx, bool valid) {
    if (isRowSelected(idx) != valid) {
      tableRows[idx].valid = valid;
      notifyListeners();
    }
  }

  int getSelectedCount() {
    return tableRows.where((element) => element.selected).toList().length;
  }

  int getInValidRowsCount() {
    return tableRows.where((element) => !element.valid).toList().length;
  }

  List<TableViewRow> getSelectedRows() {
    return tableRows.where((element) => element.selected).toList();
  }

  List<int> getSelectedRowsIndices() {
    List<int> indices = [];
    for (var i = 0; i < tableRows.length; i++) {
      if (tableRows[i].selected) {
        indices.add(i);
      }
    }

    return indices;
  }

  deleteSelectedRows() {
    var arr = getSelectedRowsIndices();

    for (var i = arr.length - 1; i >= 0; i--) {
      removeRow(arr[i]);
    }
  }

  TableViewRow? getFirstSelectedRow() {
    var selectedRows = getSelectedRows();
    if (selectedRows.isNotEmpty) {
      return selectedRows.first;
    }
    return null;
  }

  int getFirstSelectedRowIndex() {
    var idx = tableRows.indexWhere((element) => element.selected);
    return idx;
  }

  void deleteFirstSelectedRow() {
    var idx = tableRows.indexWhere((element) => element.selected);
    removeRow(idx);
  }

  // this function used only if table is used in select from Account, lookup when only 1 row is allowed to be selected
  int getSelectedRowIndex() {
    var idx = tableRows.indexWhere((element) => element.selected);
    return idx;
  }

  isSelectorFieldExistInFieldList(List<UnifiedFieldDescription> fieldList, String fieldId) {
    return fieldList.where((element) => element.fieldId == fieldId).toList().isNotEmpty;
  }

  List<DataColumn> getColumns(BuildContext context) {
    // row fields contains all the information needed to create the columns
    var columnsArr = fieldListDescriptions.map((e) => UnifiedFormField.fromDescription(e)).toList();
    var cols = columnsArr
        .map((e) => DataColumn(
              onSort: (columnIndex, ascending) => {sortRows(e.fieldId, columnIndex, ascending)},
              label: Text(e.getLabel(), style: Theme.of(context).textTheme.headlineMedium),
              numeric: e.type == AccelaFieldTypes.number,
              tooltip: e.getLabel(),
            ))
        .toList();

    if (addValidatorColumn) {
      cols.insertAll(0, [
        DataColumn(
          onSort: null,
          label: Text(validatorColumnLabel ?? 'Valid'.tr()),
          numeric: false,
          tooltip: validatorColumnLabel ?? 'Valid'.tr(),
        )
      ]);
    }

    if (actions?.isNotEmpty ?? false) {
      cols.insertAll(
          cols.length,
          actions
                  ?.map((e) => const DataColumn(
                        onSort: null,
                        label: Text(""),
                        numeric: false,
                        tooltip: "",
                      ))
                  .toList() ??
              []);
    }

    cols.add(DataColumn(
      onSort: (columnIndex, ascending) => {},
      label: const Text(""),
      numeric: false,
      tooltip: "",
    ));
    return cols;
  }
}

class TableViewRow {
  List<UnifiedFormField> rowFields = [];
  bool selected = false;
  bool valid = true;
  Map<String, Object>? additionalProperties;
  List<TableActionButton> rowActionsButtons = [];

  TableViewRow(this.rowFields, {this.selected = false, this.valid = true, this.additionalProperties, this.rowActionsButtons = const []});

  UnifiedFormField? getField(String fieldId) {
    var arr = rowFields.where((element) => element.isFieldId(fieldId)).toList();
    if (arr.isNotEmpty) {
      return arr[0];
    }

    return null;
  }

  Object? getFieldValue(String fieldId) {
    return getField(fieldId)?.getFieldValue();
  }

  String getFieldValueAsString(String fieldId) {
    return getField(fieldId)?.getValueAsString() ?? '';
  }

  Map<String, Object?> getRowValues() {
    Map<String, Object?> rowValues = {};

    for (var e in rowFields) {
      rowValues[e.fieldId] = e.getFieldValue();
    }

    return rowValues;
  }

  Map<String, Object?> getRowValuesAsString() {
    Map<String, Object?> rowValues = {};

    for (var e in rowFields) {
      rowValues[e.fieldId] = e.getValueAsString();
    }

    return rowValues;
  }

//   bool setValues(Map<String, Object?> valuesObj) {
//     for (var element in rowFields) {
//       if (valuesObj.containsKey(element.fieldId)) {
//         var value = (valuesObj[element.fieldId] ?? '') as String;
//         element.setFieldValueFromString(value);
//       }
//     }
//     return true;
//   }

  bool setValuesFromString(Map<String, Object?> valuesObj) {
    for (var element in rowFields) {
      if (valuesObj.containsKey(element.fieldId)) {
        var value = (valuesObj[element.fieldId] ?? '') as String;
        element.setFieldValueFromString(value);
      }
    }
    return true;
  }

  bool isValid() {
    bool isValid = true;
    for (var field in rowFields) {
      var valid = field.validate();

      if (!valid) {
        isValid = false;
      }
    }

    return isValid;
  }
}

class TableActionButton {
  String title;
  Icon? icon;
  void Function(BuildContext context, int rowIdx, String title)? callback;

  TableActionButton({required this.title, this.callback, this.icon});
}
