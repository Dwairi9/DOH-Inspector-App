import 'package:aca_mobile_app/description/drilldown.dart';
import 'package:aca_mobile_app/description/dropdown_value_description.dart';
import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

enum AccelaFieldTypes {
  text(1),
  date(2),
  yesno(3),
  number(4),
  dropdown(5),
  textarea(6),
  time(7),
  money(8),
  checkbox(9),
  autocomplete(12);

  const AccelaFieldTypes(this.value);
  final num value;

  static AccelaFieldTypes getByValue(num i) {
    return AccelaFieldTypes.values.firstWhere((x) => x.value == i);
  }
}

class UnifiedFormField {
  late Key key;
  late String fieldId;
  late String fieldLabel;
  late final DrillDownMapping? drillDownMapping;
  AccelaFieldTypes type = AccelaFieldTypes.text;
  bool hidden = false;
  bool readOnly = false;
  bool required = false;
  bool valid = true;
  bool suppressNextEvent = false;
  String defaultFieldValue = '';
  String message = '';
  String unit = '';
  List<DropDownValueDescription> valueList = [];
  Object? value;
  TextEditingController textEditingController = TextEditingController();

  UnifiedFormField.fromDescription(UnifiedFieldDescription description)
      : this(description.fieldId, getDescFieldLabel(description), AccelaFieldTypes.getByValue(description.fieldType),
            valueList: description.valueList.map((e) => e.copyWith(text: e.text, value: e.value)).toList(),
            readOnly: description.readOnly,
            required: description.required,
            hidden: description.hidden,
            drillDownMapping: description.drillDownMapping,
            unit: description.unitDisp.isNotEmpty ? description.unitDisp : description.unit,
            defaultFieldValue: description.defaultValue);

  UnifiedFormField(this.fieldId, this.fieldLabel, this.type,
      {this.value = "",
      this.valueList = const [],
      this.readOnly = false,
      this.required = false,
      this.hidden = false,
      this.drillDownMapping,
      this.unit = "",
      this.defaultFieldValue = ""}) {
    key = Key(Utility.generateRandomString(10));
    textEditingController.text = getValueAsString(datesAsIs: true);
  }

  UnifiedFormField copyField() {
    return UnifiedFormField(fieldId, fieldLabel, type,
        value: value,
        valueList: valueList,
        readOnly: readOnly,
        required: required,
        hidden: hidden,
        drillDownMapping: drillDownMapping,
        unit: unit,
        defaultFieldValue: defaultFieldValue);
  }

  verifyDropdownValueIsInList() {
    // If the value is not in the list, add it to the list
    // Ideally this should never happen, but there is a lot of bad data and the app needs to handle it gracefully
    if (type != AccelaFieldTypes.dropdown) {
      return;
    }

    String valueStr = getValueAsString();

    if (valueStr.isEmpty) {
      return;
    }

    if (valueList.firstWhereOrNull((e) => e.value == valueStr) == null) {
      valueList.add(DropDownValueDescription(value: valueStr, text: valueStr));
    }
  }

  bool setFieldReadOnly(bool readOnly) {
    this.readOnly = readOnly;
    return true;
  }

  bool setFieldRequired(bool required) {
    this.required = required;
    return true;
  }

  bool setFieldHidden(bool hidden) {
    this.hidden = hidden;
    return true;
  }

  bool setFieldMessage(String message) {
    this.message = message;
    return true;
  }

  bool isRequired() {
    return required && !readOnly;
  }

  bool isReadOnly() {
    return readOnly;
  }

  bool isHidden() {
    return hidden;
  }

  String getFieldMessage() {
    return message;
  }

  String getFieldId() {
    return fieldId;
  }

  bool isFieldId(String otherFieldId) {
    return fieldId.toLowerCase() == otherFieldId.toLowerCase();
  }

  static String getDescFieldLabel(UnifiedFieldDescription description) {
    String fieldLabel = description.fieldLabel;

    if (description.alternativeLabelDisp.isNotEmpty) {
      fieldLabel = description.alternativeLabelDisp;
    } else if (description.alternativeLabel.isNotEmpty) {
      fieldLabel = description.alternativeLabel;
    } else if (description.labelAliasDisp.isNotEmpty) {
      fieldLabel = description.labelAliasDisp;
    } else if (description.labelAlias.isNotEmpty) {
      fieldLabel = description.labelAlias;
    } else if (description.fieldLabelDisp.isNotEmpty) {
      fieldLabel = description.fieldLabelDisp;
    }

    return fieldLabel;
  }

  String getLabel() {
    return fieldLabel;
  }

  String getDisplayLabel() {
    return fieldLabel + (isRequired() ? ' *' : '') + (unit.isNotEmpty ? ' ($unit)' : '');
  }

  bool hasDrilldown() {
    return type == AccelaFieldTypes.dropdown && (drillDownMapping?.parentField ?? '').isNotEmpty;
  }

  String getParentDrilldownFieldId() {
    return drillDownMapping?.parentField ?? '';
  }

  DrillDownMapping? getDrilldownMapping() {
    return drillDownMapping;
  }

  bool setFieldValueFromString(String? newValue, {bool datesAsIs = false}) {
    String strValue = newValue ?? '';
    bool valueChanged = isCurrentStringValue(newValue);
    if (type == AccelaFieldTypes.date) {
      if (strValue.isNotEmpty) {
        String dateFormat = datesAsIs ? 'dd/MM/yyyy' : 'MM/dd/yyyy';
        value = Utility.stringToDate(strValue, dateFormat);
      }
    } else if (type == AccelaFieldTypes.time) {
      if (strValue.isNotEmpty) {
        value = Utility.stringToTime(strValue);
      }
    } else if (type == AccelaFieldTypes.checkbox) {
      value = strValue == "CHECKED";
    } else if (type == AccelaFieldTypes.dropdown) {
      value = strValue;
      verifyDropdownValueIsInList();
    } else {
      value = strValue;
    }
    textEditingController.text = getValueAsString(datesAsIs: true);
    return valueChanged;
  }

  bool setFieldValue(Object? value, {bool updateController = false}) {
    this.value = value;
    if (updateController) {
      textEditingController.text = getValueAsString(datesAsIs: true);
    }
    return true;
  }

  Object? getFieldValue() {
    return value;
  }

  bool populateDefaultValue() {
    if (defaultFieldValue.isNotEmpty) {
      return setFieldValueFromString(defaultFieldValue);
    }
    return true;
  }

  // Values in Accela are stored as strings
  // When we set the values we convert from string to appropriate type (date, time, bool, etc)
  // When we get the values we convert from appropriate type to string
  // This is done to avoid having to convert the values every time the interface is built
  String getValueAsString({bool datesAsIs = false, bool forDisplay = false}) {
    String returnValue = '';

    if (type == AccelaFieldTypes.date) {
      if (value is DateTime) {
        String dateFormat = datesAsIs ? 'dd/MM/yyyy' : 'MM/dd/yyyy';
        // Return the date as it's shown, used by expression engine
        returnValue = Utility.dateToString(value as DateTime, dateFormat);
      }
    } else if (type == AccelaFieldTypes.time) {
      if (value is TimeOfDay) {
        returnValue = Utility.timeToString(value as TimeOfDay);
      }
    } else if (type == AccelaFieldTypes.checkbox) {
      if (value is bool) {
        returnValue = value == true ? 'CHECKED' : 'UNCHECKED';
      }
    } else if (type == AccelaFieldTypes.number) {
      if (value is String) {
        returnValue = Utility.replaceArabicNumberWithEnglishNumber(value as String);
      }
    } else if (type == AccelaFieldTypes.dropdown || type == AccelaFieldTypes.autocomplete) {
      if (value is String) {
        if (forDisplay) {
          var arr = valueList.where((val) => val.value == value).toList();
          if (arr.isNotEmpty) {
            returnValue = arr.first.text;
          }
        } else {
          returnValue = value as String;
        }
      }
    } else {
      if (value is String) {
        returnValue = value as String;
      }
    }
    return returnValue;
  }

  bool getValueAsBool() {
    if (value is bool) {
      return value as bool;
    }
    return false;
  }

  bool clearValue({bool updateController = false}) {
    bool fieldValueChanged = false;
    if (type == AccelaFieldTypes.date || type == AccelaFieldTypes.time || type == AccelaFieldTypes.checkbox) {
      if (value != null) {
        fieldValueChanged = true;
      }
      value = null;
    } else {
      if (value.toString().isNotEmpty) {
        fieldValueChanged = true;
      }
      value = '';
    }

    if (updateController) {
      textEditingController.text = getValueAsString(datesAsIs: true);
    }

    return fieldValueChanged;
  }

  bool setDropdownValues(List<DropDownValueDescription> dropDownValues) {
    valueList = dropDownValues;
    if (valueList.where((element) => element.value == getFieldValue()).toList().isEmpty) {
      clearValue();
    }
    return true;
  }

  bool isValid() {
    if (!isRequired() || isHidden()) {
      return true;
    }
    dynamic value = getFieldValue() ?? "";
    bool isValid = true;
    if (type == AccelaFieldTypes.checkbox) {
      isValid = getValueAsBool();
    } else if (type == AccelaFieldTypes.date || type == AccelaFieldTypes.time) {
      isValid = value != null;
    } else {
      isValid = !(value is String && value.isEmpty);
    }

    return isValid;
  }

  bool setValid(bool isValid) {
    valid = isValid;

    return true;
  }

  bool validate() {
    bool isFieldValid = isValid();
    valid = isFieldValid;
    return isFieldValid;
  }

  bool showLabel() {
    return type != AccelaFieldTypes.checkbox && type != AccelaFieldTypes.yesno;
  }

  bool isCurrentStringValue(String? value) {
    return value == getValueAsString();
  }
}
