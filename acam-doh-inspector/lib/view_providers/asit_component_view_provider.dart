import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/table_view_provider.dart';

class AsitComponentViewProvider extends BaseComponentViewProvider {
  final AsiSubgroupCompleteDescription asitSubgroupDescription;
  late TableViewProvider tableProvider;
  AccelaUnifiedFormProvider? currentAccelaUnifiedFormProvider;
  Function? fieldValueChangedCallback;
  int currentEditIndex = -1;
  bool isReadOnly = false;
  int currentReadOnlyEditIndex = -1;

  AsitComponentViewProvider(this.asitSubgroupDescription,
      {this.isReadOnly = false, List<Map<String, Object?>>? values, super.title, super.uniqueId, super.expressionsDescription})
      : super(ComponentType.asit) {
    if (!isReadOnly) {
      isReadOnly = asitSubgroupDescription.permission != "F";
    }

    tableProvider =
        TableViewProvider(fieldListDescriptions: asitSubgroupDescription.unifiedFields, tableSelectStyle: TableSelectStyle.multiSelect, isReadOnly: isReadOnly);

    tableProvider.onCellTapEvent = (int rowIdx, UnifiedFormField formField) {
      currentReadOnlyEditIndex = rowIdx;
      notifyListeners();
    };
    setAsitValues(values ?? []);
  }

  List<Map<String, Object?>> getAsitRows() {
    return tableProvider.getRowsValues();
  }

  List<Map<String, Object?>> getAsitRowsAsStrings() {
    return tableProvider.getRowValuesAsStrings();
  }

  @override
  Map<String, Object> getViewValues() {
    var valuesArr = getAsitRows();

    return {"type": type, "group": asitSubgroupDescription.group, "subgroup": asitSubgroupDescription.subgroup, "values": valuesArr};
  }

  setAsitValues(List<Map<String, Object?>> valuesArr) {
    for (var values in valuesArr) {
      tableProvider.addRow(values);
    }

    notifyListeners();
  }

  @override
  bool isValid() {
    return true;
  }

  String getGroupName() {
    return asitSubgroupDescription.subgroup;
  }
}
