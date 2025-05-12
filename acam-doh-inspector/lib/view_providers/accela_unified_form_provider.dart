import 'package:aca_mobile_app/description/drilldown.dart';
import 'package:aca_mobile_app/description/dropdown_value_description.dart';
import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

enum FieldModifySource { userChange, userBlur, event }

class AccelaUnifiedFormProvider extends ChangeNotifier {
  List<UnifiedFormField> fieldLists = [];
  List<UnifiedFormField> editFieldList = [];
  // This one is defined per field
  Map<String, Function> fieldCallBacks = {};
  // This one is called anytime a field value is changed
  Function? fieldValueChangedCallback;
  Function? onLoad;

  String parentComponentKey;
  bool editMode = false;
  bool forceReadOnly = false;

  AccelaUnifiedFormProvider({
    required List<UnifiedFieldDescription> fieldListDescription,
    required this.parentComponentKey,
  }) {
    fieldLists = fieldListDescription.map((e) => UnifiedFormField.fromDescription(e)).toList();
  }

  AccelaUnifiedFormProvider.fromFieldList({
    required this.fieldLists,
    required this.parentComponentKey,
  });

  initProvider() {
    // rebuildListeners();
    setDropDownsDrillDowns();
    onLoadEvent();
  }

  onLoadEvent() async {
    if (onLoad != null) {
      onLoad!();
    }
  }

  populateDefaultValues() {
    for (var field in getFieldList()) {
      field.populateDefaultValue();
    }
  }

  List<UnifiedFormField> getFieldList() {
    return editMode ? editFieldList : fieldLists;
  }

  setToEditMode() {
    if (editMode) {
      throw Exception("Already in edit mode");
    }
    editMode = true;
    editFieldList = List<UnifiedFormField>.from(fieldLists.map((e) => e.copyField()).toList());
  }

  discardEdits() {
    editMode = false;
    editFieldList = [];
  }

  saveEdits() {
    fieldLists = List<UnifiedFormField>.from(editFieldList.map((e) => e.copyField()).toList());
    editMode = false;
    editFieldList = [];
  }

  setDropDownsDrillDowns() {
    getFieldList().where((element) => element.hasDrilldown()).forEach((element) {
      String parentFieldId = element.getParentDrilldownFieldId();

      String parentValue = getFieldValueAsString(parentFieldId);
      if (parentValue.isEmpty) {
        element.setFieldReadOnly(true);
      } else {
        List<DrillDownValueMap> drillDownValueMap = element.getDrilldownMapping()?.valueMap ?? [];
        element.setDropdownValues(drillDownValueMap.firstWhere((element) => element.parentValue == parentValue).childValues);
        element.setFieldReadOnly(false);
      }
    });
  }

//   fieldValueChanged(String fieldId) {
//     var field = getFieldById(fieldId);

//     if (field != null) {
//       // For text input fields, the fieldModified event will be triggered when they lose focus
//       if (field.type == AccelaFieldTypes.checkbox ||
//           field.type == AccelaFieldTypes.date ||
//           field.type == AccelaFieldTypes.dropdown ||
//           field.type == AccelaFieldTypes.autocomplete ||
//           field.type == AccelaFieldTypes.time ||
//           field.type == AccelaFieldTypes.yesno) {
//         fieldModified(fieldId, fromEvent: true);
//       }
//     }
//   }

//   fieldFocusChanged(String fieldId, bool focused) {
//     var field = getFieldById(fieldId);
//     if (field != null) {
//       // Some fields trigger both change value and focus change events
//       if (field.type == AccelaFieldTypes.text ||
//           field.type == AccelaFieldTypes.textarea ||
//           field.type == AccelaFieldTypes.number ||
//           field.type == AccelaFieldTypes.money) {
//         if (!focused) {
//           fieldModified(fieldId, fromEvent: true, sourceUnfocus: true);
//         }
//       }
//     }
//   }

  fieldModified(String fieldId, FieldModifySource fieldModifySource) {
    var field = getFieldById(fieldId);
    if (field != null && (fieldModifySource == FieldModifySource.userBlur || fieldModifySource == FieldModifySource.userChange)) {
      var fieldValid = field.valid;
      if (fieldValid != field.validate()) {
        notifyListeners();
      }
    }

    if (fieldCallBacks.containsKey(fieldId)) {
      fieldCallBacks[fieldId]!(getFieldValue(fieldId));
    }

    if (fieldValueChangedCallback != null) {
      fieldValueChangedCallback!(fieldId, fieldModifySource);
    }

    // if (!supressExpression && fromEvent) {
    //   bool suppressNexExpression = field?.suppressNextEvent ?? false;
    //   // Unfocus events should always execute expressions
    //   if (!sourceUnfocus && suppressNexExpression) {
    //     field?.suppressNextEvent = false;
    //   } else {
    //     // If I change the value the listeners should handle executing expressions
    //     // expressionManager?.runExpression(fieldId);
    //     // expressionManagerProvider?.runExpression(parentComponentKey, fieldId);
    //   }
    // }
    if (field?.type == AccelaFieldTypes.dropdown || field?.type == AccelaFieldTypes.autocomplete) {
      setDropDownsDrillDowns();
    }
  }

  bool setFieldValues(Map<String, Object?> valuesObj, FieldModifySource fieldModifySource) {
    for (var element in getFieldList()) {
      if (valuesObj.containsKey(element.fieldId)) {
        element.setFieldValue(valuesObj[element.fieldId], updateController: fieldModifySource == FieldModifySource.event);
        fieldModified(element.fieldId, fieldModifySource);
      }
    }
    return true;
  }

  bool setFieldValuesFromStrings(Map<String, Object?> valuesObj, FieldModifySource fieldModifySource) {
    for (var element in getFieldList()) {
      if (valuesObj.containsKey(element.fieldId)) {
        var value = (valuesObj[element.fieldId] ?? '') as String;
        element.setFieldValueFromString(value);
        fieldModified(element.fieldId, fieldModifySource);
      }
    }
    return true;
  }

  bool setFieldValue(String fieldId, Object? value, FieldModifySource fieldModifySource) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldValue(value, updateController: fieldModifySource == FieldModifySource.event) ?? false;
    if (fieldChanged) {
      fieldModified(fieldId, fieldModifySource);
      notifyListeners();
    }
    return fieldChanged;
  }

  bool setFieldValueFromString(String fieldId, String value, FieldModifySource fieldModifySource) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldValueFromString(value) ?? false;
    if (fieldChanged) {
      fieldModified(fieldId, fieldModifySource);
      notifyListeners();
    }
    return fieldChanged;
  }

  bool clearFieldValue(String fieldId, FieldModifySource fieldModifySource) {
    bool fieldChanged = getFieldById(fieldId)?.clearValue(updateController: fieldModifySource == FieldModifySource.event) ?? false;
    if (fieldChanged) {
      fieldModified(fieldId, fieldModifySource);
      notifyListeners();
    }
    return fieldChanged;
  }

  List<UnifiedFormField> getDisplayFields() {
    return getFieldList().where((element) => !element.isHidden()).toList();
  }

  List<UnifiedFormField> getInvalidFields() {
    return getFieldList().where((element) => !element.valid).toList();
  }

  List<UnifiedFormField> getPopulatedDisplayFields() {
    return getDisplayFields().where((element) => element.getValueAsString().isNotEmpty).toList();
  }

  bool isNotEmpty() {
    return getPopulatedDisplayFields().isNotEmpty;
  }

  UnifiedFormField? getFieldById(String fieldId) {
    return getFieldList().firstWhereOrNull((element) {
      return element.isFieldId(fieldId);
    });
  }

  setFieldHidden(String fieldId, bool hidden) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldHidden(hidden) ?? false;
    if (fieldChanged) {
      notifyListeners();
    }
  }

  setFieldRequired(String fieldId, bool required) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldRequired(required) ?? false;
    if (fieldChanged) {
      notifyListeners();
    }
  }

  setFieldMessage(String fieldId, String message) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldMessage(message) ?? false;
    if (fieldChanged) {
      notifyListeners();
    }
  }

  setFieldReadOnly(String fieldId, bool readOnly) {
    bool fieldChanged = getFieldById(fieldId)?.setFieldReadOnly(readOnly) ?? false;
    if (fieldChanged) {
      notifyListeners();
    }
  }

  setFieldEmpty(String fieldId) {
    bool fieldChanged = getFieldById(fieldId)?.clearValue() ?? false;
    if (fieldChanged) {
      notifyListeners();
    }
  }

  dynamic getFieldValue(String fieldId) {
    return getFieldById(fieldId)?.getFieldValue() ?? "";
  }

  String getFieldValueAsString(String fieldId, {bool dateAsIs = false}) {
    return getFieldById(fieldId)?.getValueAsString(datesAsIs: dateAsIs) ?? "";
  }

  bool isFieldValueSame(String fieldId, String? newValue) {
    return (getFieldById(fieldId)?.getValueAsString() == (newValue ?? ''));
  }

  bool valuePopulated(String fieldId) {
    return getDisplayFieldValue(fieldId).isNotEmpty;
  }

  String getDisplayFieldValue(String fieldId) {
    return getFieldById(fieldId)?.getValueAsString() ?? "";
  }

  String getFieldLabel(String fieldId) {
    return getFieldById(fieldId)?.getLabel() ?? "";
  }

  bool isFieldHidden(String fieldId) {
    return getFieldById(fieldId)?.isHidden() ?? false;
  }

  Map<String, Object> getValuesAsStrings({bool forDisplay = false, bool datesAsIs = false, bool tryFromClone = false}) {
    var asiValues = <String, Object>{};
    for (var element in getFieldList()) {
      asiValues[element.fieldId] = element.getValueAsString(forDisplay: forDisplay);
    }
    return asiValues;
  }

  Map<String, Object?> getValues({bool forDisplay = false, bool datesAsIs = false, bool tryFromClone = false}) {
    var asiValues = <String, Object?>{};
    for (var element in getFieldList()) {
      asiValues[element.fieldId] = element.getFieldValue();
    }
    return asiValues;
  }

  bool isValid() {
    bool isValid = true;
    for (var field in getFieldList()) {
      var valid = field.validate();

      if (!valid) {
        isValid = false;
      }
    }

    notifyListeners();

    return isValid;
  }

  addFieldCallback(String fieldName, Function callback) {
    fieldCallBacks[fieldName] = callback;
  }

  removeFieldCallback(String fieldName) {
    if (fieldCallBacks.containsKey(fieldName)) {
      fieldCallBacks.remove(fieldName);
    }
  }

  List<DropDownValueDescription> getFieldDropdownValues(String fieldId) {
    return getFieldById(fieldId)?.valueList ?? [];
  }

  setFieldDropdownValues(String fieldId, List<DropDownValueDescription> values) {
    getFieldById(fieldId)?.setDropdownValues(values);
    notifyListeners();
  }

  clearValues() {
    for (var element in getFieldList()) {
      element.clearValue(updateController: true);
    }
  }

  setForceReadOnly(bool readOnly) {
    forceReadOnly = readOnly;
    notifyListeners();
  }
}
