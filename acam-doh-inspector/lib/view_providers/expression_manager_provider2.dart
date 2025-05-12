import 'package:aca_mobile_app/data_models/expression_field_result.dart';
import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/description/expression_description.dart';
import 'package:aca_mobile_app/description/offline_expression_description.dart';
import 'package:aca_mobile_app/description/offline_expression_field.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:flutter/foundation.dart';

enum ExpressionPortletType { asi, asit, address, contact, lp, parcel }

class ExpressionManagerProvider2 extends ChangeNotifier {
  List<BaseComponentViewProvider> provders = [];
  bool useAnonymousToken = false;
  RecordId? recordId;

  ExpressionManagerProvider2({this.recordId, this.useAnonymousToken = false});

  bool shouldExecuteExpression(AccelaUnifiedFormProvider provider, String fieldId, FieldModifySource fieldModifiedSource) {
    var field = provider.getFieldById(fieldId);
    if (field != null) {
      if (fieldModifiedSource == FieldModifySource.event) {
        return false;
      } else if (fieldModifiedSource == FieldModifySource.userBlur) {
        return field.type == AccelaFieldTypes.text ||
            field.type == AccelaFieldTypes.textarea ||
            field.type == AccelaFieldTypes.number ||
            field.type == AccelaFieldTypes.money;
      } else if (fieldModifiedSource == FieldModifySource.userChange) {
        return field.type == AccelaFieldTypes.checkbox ||
            field.type == AccelaFieldTypes.date ||
            field.type == AccelaFieldTypes.dropdown ||
            field.type == AccelaFieldTypes.autocomplete ||
            field.type == AccelaFieldTypes.time ||
            field.type == AccelaFieldTypes.yesno;
      }
    }
    return false;
  }

  void addProvider(BaseComponentViewProvider provider) {
    provders.add(provider);
    if (provider.type == ComponentType.asi) {
      AsiComponentViewProvider asiProvider = provider as AsiComponentViewProvider;
      asiProvider.accelaUnifiedFormProvider.fieldValueChangedCallback = (String fieldName, FieldModifySource fieldModifySource) {
        if (shouldExecuteExpression(asiProvider.accelaUnifiedFormProvider, fieldName, fieldModifySource)) {
          runExpression(asiProvider.getUniqueId(), fieldName);
        } else {}
      };
    } else if (provider.type == ComponentType.asit) {
      AsitComponentViewProvider asitProvider = provider as AsitComponentViewProvider;
      asitProvider.fieldValueChangedCallback = (String fieldName, FieldModifySource fieldModifySource) {
        if (asitProvider.currentAccelaUnifiedFormProvider == null) {
          return;
        }
        if (shouldExecuteExpression(asitProvider.currentAccelaUnifiedFormProvider!, fieldName, fieldModifySource)) {
          runExpression(asitProvider.getUniqueId(), fieldName);
        } else {}
      };
    }
    notifyListeners();
  }

  void removeProvider(BaseComponentViewProvider provider) {
    provders.remove(provider);
    notifyListeners();
  }

  void clearProviders() {
    provders.clear();
    notifyListeners();
  }

  bool fieldHasExpression(ExpressionDescription expressionDescription, String subgroupName, String fieldName) {
    return expressionDescription.expressionFields
        .where((element) => element.fieldName.toLowerCase() == fieldName.toLowerCase() && element.subgroup.toLowerCase() == subgroupName.toLowerCase())
        .isNotEmpty;
  }

  ExpressionField getExpressionField(ExpressionDescription expressionDescription, String subgroupName, String fieldName) {
    return expressionDescription.expressionFields
        .where((element) => element.fieldName.toLowerCase() == fieldName.toLowerCase() && element.subgroup.toLowerCase() == subgroupName.toLowerCase())
        .first;
  }

  bool fieldHasOfflineExpression(OfflineExpressionDescription offlineExpressionDescription, String fieldName) {
    return offlineExpressionDescription.offlineExpressionFields.where((element) => element.fieldName.toLowerCase() == fieldName.toLowerCase()).isNotEmpty;
  }

  OfflineExpressionField getOfflineExpressionField(OfflineExpressionDescription offlineExpressionDescription, String fieldName) {
    return offlineExpressionDescription.offlineExpressionFields.where((element) => element.fieldName.toLowerCase() == fieldName.toLowerCase()).first;
  }

  BaseComponentViewProvider? getProvider(String providerName) {
    var arr = provders.where((element) => element.getUniqueId() == providerName);
    if (arr.isNotEmpty) {
      return arr.first;
    }

    return null;
  }

  List<BaseComponentViewProvider> getProvidersByType(ComponentType type) {
    return provders.where((element) => element.type == type).toList();
  }

  ExpressionFieldResult? applyResults(String invokingProvider, List<ExpressionFieldResult> expressionFieldResults) {
    ExpressionFieldResult? blockSubmitExpressionField;
    var provider = getProvider(invokingProvider);
    if (provider != null) {
      // For ASI we apply the expression results on all the other ASI subgroups as well
      if (provider.type == ComponentType.asi) {
        getProvidersByType(ComponentType.asi).forEach((element) {
          AsiComponentViewProvider asiProvider = element as AsiComponentViewProvider;
          var expressionResult = processExpressionResult(expressionFieldResults, asiProvider.accelaUnifiedFormProvider);

          blockSubmitExpressionField ??= expressionResult;
        });
      } else if (provider.type == ComponentType.asit) {
        AsitComponentViewProvider asitProvider = provider as AsitComponentViewProvider;
        if (asitProvider.currentAccelaUnifiedFormProvider != null) {
          AccelaUnifiedFormProvider? accelaUnifiedFormProvider = asitProvider.currentAccelaUnifiedFormProvider;

          int rowIndex = 0;
          if (asitProvider.currentEditIndex != -1) {
            rowIndex = asitProvider.currentEditIndex;
          } else {
            rowIndex = asitProvider.getAsitRows().length;
          }
          var results = expressionFieldResults.where((element) => element.rowIndex == rowIndex).toList();
          if (results.isNotEmpty) {
            var expressionResult = processExpressionResult(results, accelaUnifiedFormProvider!);

            blockSubmitExpressionField ??= expressionResult;
          } else {}
        }
      }
    }

    return blockSubmitExpressionField;
  }

  ExpressionFieldResult? processExpressionResult(List<ExpressionFieldResult> expressionFieldResult, AccelaUnifiedFormProvider accelaUnifiedFormProvider) {
    ExpressionFieldResult? blockSubmitExpressionField;
    for (var expressionField in expressionFieldResult) {
      var field = accelaUnifiedFormProvider.getFieldById(expressionField.fieldName);

      if (expressionField.blockSubmit && blockSubmitExpressionField == null) {
        blockSubmitExpressionField = expressionField;
      }

      if (field != null) {
        if (expressionField.message.isNotEmpty) {
          field.message = expressionField.message;
        } else {
          field.message = "";
        }

        if (expressionField.value.isNotEmpty) {
          accelaUnifiedFormProvider.setFieldValueFromString(field.fieldId, expressionField.value, FieldModifySource.event);
        } else {
          accelaUnifiedFormProvider.clearFieldValue(field.fieldId, FieldModifySource.event);
        }

        if (expressionField.readOnly == "Y") {
          accelaUnifiedFormProvider.setFieldReadOnly(field.fieldId, true);
        } else if (expressionField.readOnly == "N") {
          accelaUnifiedFormProvider.setFieldReadOnly(field.fieldId, false);
        }

        if (expressionField.required == "Y") {
          accelaUnifiedFormProvider.setFieldRequired(field.fieldId, true);
        } else if (expressionField.required == "N") {
          accelaUnifiedFormProvider.setFieldRequired(field.fieldId, false);
        }

        if (expressionField.hidden == "Y") {
          accelaUnifiedFormProvider.setFieldHidden(field.fieldId, true);
        } else if (expressionField.hidden == "N") {
          accelaUnifiedFormProvider.setFieldHidden(field.fieldId, false);
        }
      }
    }

    return blockSubmitExpressionField;
  }

  Map<String, Object> getValues(AccelaUnifiedFormProvider accelaUnifiedFormProvider, ExpressionDescription expressionDescription) {
    return accelaUnifiedFormProvider.getValuesAsStrings(datesAsIs: true, tryFromClone: true).map((key, value) {
      String prefix = "";
      if (expressionDescription.viewId == -1) {
        prefix = "ASI::";
      } else if (expressionDescription.viewId == -2) {
        prefix = "ASIT::";
      }
      prefix += "${expressionDescription.asiSubgroup ?? ""}::";
      return MapEntry(prefix + key, value);
    });
  }

  String getCustomId() {
    return recordId?.customId ?? "";
  }

  runOnload() {
    // onload only truly runs for ASI
    var asiProvidersArr = getProvidersByType(ComponentType.asi);

    // if there are no ASI providers with onLoad, then we don't need to run onload
    var asiProvidersWithOnLoad = asiProvidersArr.where((element) => element.expressionsDescription?.onLoad ?? false);
    var hasOnload = asiProvidersWithOnLoad.isNotEmpty;
    if (!hasOnload) {
      return;
    }

    var expressionDescription = asiProvidersArr.first.expressionsDescription;

    if (expressionDescription == null) {
      return;
    }

    var values = {};
    for (var element in asiProvidersArr) {
      AsiComponentViewProvider asiProvider = element as AsiComponentViewProvider;
      values.addAll(getValues(asiProvider.accelaUnifiedFormProvider, asiProvider.expressionsDescription!));
    }

    AccelaServiceManager.emseRequest(
            'runExpression',
            {
              "viewId": expressionDescription.viewId,
              "executeVariable": "onLoad",
              "asiGroup": expressionDescription.asiGroup,
              // "subgroup": expressionDescription.asiSubgroup,
              "values": values,
              "customId": getCustomId()
            },
            useAnonymousToken: useAnonymousToken)
        .then((dataResult) {
      if (dataResult.success) {
        var expressionResult = List<ExpressionFieldResult>.from(dataResult.content?['fields']?.map((x) => ExpressionFieldResult.fromMap(x)));
        applyResults(asiProvidersWithOnLoad.first.getUniqueId(), expressionResult);
      }
      return null;
    });
  }

  void runExpression(String invokingProvider, String fieldName) async {
    var provider = getProvider(invokingProvider);
    if (provider == null) {
      return null;
    }

    var expressionDescription = provider.expressionsDescription;

    if (expressionDescription == null) {
      return null;
    }

    if (!fieldHasExpression(expressionDescription, expressionDescription.asiSubgroup ?? "", fieldName)) {
      return null;
    }

    ExpressionField expressionField = getExpressionField(expressionDescription, expressionDescription.asiSubgroup ?? "", fieldName);

    var values = {};
    List<Map<String, Object?>> asitRows = [];
    if (expressionDescription.viewId == -1) {
      getProvidersByType(ComponentType.asi).forEach((element) {
        AsiComponentViewProvider asiProvider = element as AsiComponentViewProvider;
        values.addAll(getValues(asiProvider.accelaUnifiedFormProvider, asiProvider.expressionsDescription!));
      });
    } else if (expressionDescription.viewId == -2) {
      AsitComponentViewProvider asitProvider = provider as AsitComponentViewProvider;
      asitRows = asitProvider.getAsitRows();

      // In case of an edit, we need to get the current edited row and replace its values in the values map
      // This is because the values map is not updated when the user edits a row, but the expression is run on the row
      // In case of a new row, we need to append the current row to the values map
      if (asitProvider.currentAccelaUnifiedFormProvider != null) {
        Map<String, Object> rowValues = getValues(asitProvider.currentAccelaUnifiedFormProvider!, asitProvider.expressionsDescription!);

        // new row
        if (asitProvider.currentEditIndex == -1) {
          asitRows.add(rowValues);
        } else {
          // edit row
          asitRows.removeAt(asitProvider.currentEditIndex);
          asitRows.insert(asitProvider.currentEditIndex, rowValues);
        }
      }
    } else {
      // TODO: handle other components
    }

    var dataResult = await AccelaServiceManager.emseRequest(
        'runExpression',
        {
          "viewId": expressionDescription.viewId,
          "executeVariable": expressionField.variableKey,
          "subgroup": expressionField.subgroup,
          "asiGroup": expressionDescription.asiGroup,
          "values": expressionDescription.viewId == -2 ? asitRows : values,
          "customId": getCustomId(),
        },
        useAnonymousToken: useAnonymousToken);

    if (dataResult.success) {
      var expressionResult = List<ExpressionFieldResult>.from(dataResult.content?['fields']?.map((x) => ExpressionFieldResult.fromMap(x)));
      applyResults(provider.getUniqueId(), expressionResult);
    }
    return null;
  }

// TODO: Clean it up and test it thoroughly
  Future<ExpressionFieldResult?> runOnAsitRowSubmit(String invokingProvider, bool isAsitRow) async {
    var provider = getProvider(invokingProvider);
    if (provider == null) {
      return Future.value(null);
    }

    var expressionDescription = provider.expressionsDescription;

    if (expressionDescription == null) {
      return Future.value(null);
    }

    var values = {};
    List<Map<String, Object?>> asitRows = [];
    if (expressionDescription.viewId == -1) {
      //   getProvidersByType(ComponentType.asi).forEach((element) {
      //     AsiComponentViewProvider asiProvider = element as AsiComponentViewProvider;
      //     values.addAll(getValues(asiProvider.accelaUnifiedFormProvider, asiProvider.expressionsDescription!));
      //   });
    } else if (expressionDescription.viewId == -2) {
      AsitComponentViewProvider asitProvider = provider as AsitComponentViewProvider;
      asitRows = asitProvider.getAsitRows();

      // In case of an edit, we need to get the current edited row and replace its values in the values map
      // This is because the values map is not updated when the user edits a row, but the expression is run on the row
      // In case of a new row, we need to append the current row to the values map
      if (asitProvider.currentAccelaUnifiedFormProvider != null) {
        Map<String, Object> rowValues = getValues(asitProvider.currentAccelaUnifiedFormProvider!, asitProvider.expressionsDescription!);

        // new row
        if (asitProvider.currentEditIndex == -1) {
          asitRows.add(rowValues);
        } else {
          // edit row
          asitRows.removeAt(asitProvider.currentEditIndex);
          asitRows.insert(asitProvider.currentEditIndex, rowValues);
        }
      }
    } else {
      // TODO: handle other components
    }

    var dataResult = await AccelaServiceManager.emseRequest(
        'runExpression',
        {
          "viewId": expressionDescription.viewId,
          "executeVariable": isAsitRow ? "onAsitRowSubmit" : "onSubmit",
          "subgroup": expressionDescription.asiSubgroup,
          "asiGroup": expressionDescription.asiGroup,
          "values": expressionDescription.viewId == -2 ? asitRows : values,
          "customId": getCustomId(),
        },
        useAnonymousToken: useAnonymousToken);

    if (dataResult.success) {
      var expressionResult = List<ExpressionFieldResult>.from(dataResult.content?['fields']?.map((x) => ExpressionFieldResult.fromMap(x)));
      ExpressionFieldResult? blockSubmitExpressionField = applyResults(provider.getUniqueId(), expressionResult);
      return Future.value(blockSubmitExpressionField);
    }
    return Future.value(null);
  }

// This is called when submitting a Form
  Future<ExpressionFieldResult?> runOnSubmitForm() async {
    // Get all providers eligible for onsubmit (currently only ASI supported, TODO: add the rest)
    var asiProvidersArr = getProvidersByType(ComponentType.asi);

    // if there are no providers with onLoad, then we don't need to run onload
    var asiProvidersWithOnSubmit = asiProvidersArr.where((element) => element.expressionsDescription?.onSubmit ?? false);
    var hasOnload = asiProvidersWithOnSubmit.isNotEmpty;
    if (!hasOnload) {
      return Future.value(null);
    }

    var expressionDescription = asiProvidersArr.first.expressionsDescription;

    if (expressionDescription == null) {
      return Future.value(null);
    }

    var values = {};
    for (var element in asiProvidersArr) {
      AsiComponentViewProvider asiProvider = element as AsiComponentViewProvider;
      values.addAll(getValues(asiProvider.accelaUnifiedFormProvider, asiProvider.expressionsDescription!));
    }

    var dataResult = await AccelaServiceManager.emseRequest(
        'runExpression',
        {
          "viewId": expressionDescription.viewId,
          "executeVariable": "onSubmit",
          "asiGroup": expressionDescription.asiGroup,
          // "subgroup": expressionDescription.asiSubgroup,
          "values": values,
          "customId": getCustomId()
        },
        useAnonymousToken: useAnonymousToken);

    if (dataResult.success) {
      var expressionResult = List<ExpressionFieldResult>.from(dataResult.content?['fields']?.map((x) => ExpressionFieldResult.fromMap(x)));
      ExpressionFieldResult? blockSubmitExpressionField = applyResults(asiProvidersWithOnSubmit.first.getUniqueId(), expressionResult);
      return Future.value(blockSubmitExpressionField);
    }
    return Future.value(null);
  }
}
