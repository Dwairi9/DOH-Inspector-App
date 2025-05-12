// ignore: unused_import
import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AsiComponentViewProvider extends BaseComponentViewProvider {
  late final AccelaUnifiedFormProvider accelaUnifiedFormProvider;
  final AsiSubgroupCompleteDescription asiSubgroupDescription;
  bool forceReadOnly = false;

  AsiComponentViewProvider(this.asiSubgroupDescription,
      {this.forceReadOnly = false, Map<String, Object?>? values, super.title, super.uniqueId, super.expressionsDescription})
      : super(ComponentType.asi) {
    accelaUnifiedFormProvider = AccelaUnifiedFormProvider(
      fieldListDescription: asiSubgroupDescription.unifiedFields,
      parentComponentKey: getUniqueId(),
    );
    accelaUnifiedFormProvider.forceReadOnly = forceReadOnly;
    if (values != null) {
      setValuesFromStrings(values);
    }

    accelaUnifiedFormProvider.initProvider();
  }

//   @override
//   Future<ExpressionFieldResult?> expressionOnSubmit() async {
//     return expressionManagerProvider?.runOnSubmit(getUniqueName(), false);
//   }

  @override
  bool isValid() {
    return accelaUnifiedFormProvider.isValid();
  }

  @override
  List<String> getInvalidItems() {
    return accelaUnifiedFormProvider.getInvalidFields().map((e) => e.getLabel()).toList().map((e) => "* ${"Field".tr()} $e ${"required".tr()}").toList();
  }

  @override
  Map<String, Object> getViewValues() {
    var asiValues = accelaUnifiedFormProvider.getValuesAsStrings();

    return {"type": type, "group": asiSubgroupDescription.group, "subgroup": asiSubgroupDescription.type, "values": asiValues};
  }

  Map<String, Object> getAsiValuesAsStrings() {
    return accelaUnifiedFormProvider.getValuesAsStrings();
  }

  setValues(Map<String, Object?> values) {
    accelaUnifiedFormProvider.setFieldValues(values, FieldModifySource.event);
    notifyListeners();
  }

  setValuesFromStrings(Map<String, Object?> values) {
    accelaUnifiedFormProvider.setFieldValuesFromStrings(values, FieldModifySource.event);
    notifyListeners();
  }

  String getGroupName() {
    return asiSubgroupDescription.subgroup;
  }
}
