import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/table_view_provider.dart';
import 'package:aca_mobile_app/views/table_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsitComponentView extends ConsumerWidget {
  late final ChangeNotifierProvider<AsitComponentViewProvider> asitComponentViewProvider;

  AsitComponentView(AsitComponentViewProvider asitComponentViewProvider, {super.key}) {
    this.asitComponentViewProvider = ChangeNotifierProvider<AsitComponentViewProvider>((ref) => asitComponentViewProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(asitComponentViewProvider);
    ref.listen(asitComponentViewProvider, (AsitComponentViewProvider? previous, AsitComponentViewProvider next) {
      if (next.currentReadOnlyEditIndex != -1) {
        editRow(context, next, index: next.currentReadOnlyEditIndex, title: 'View Row');
        next.currentReadOnlyEditIndex = -1;
      }
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          TableView(provider.tableProvider),
          if (!provider.isReadOnly)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AcamIcon(icon: Icons.add, text: 'Add'.tr(), onTap: () => addRow(context, provider)),
                const SizedBox(width: 14),
                AcamIcon(icon: Icons.edit, text: 'Edit'.tr(), onTap: () => editRow(context, provider)),
                const SizedBox(width: 14),
                AcamIcon(icon: Icons.delete, text: 'Delete'.tr(), iconColor: themeNotifier.deleteColor, onTap: () => deleteRow(context, provider)),
              ],
            ),
        ],
      ),
    );
  }

  addRow(BuildContext context, AsitComponentViewProvider provider) async {
    var accelaUnifiedFormProvider =
        AccelaUnifiedFormProvider(fieldListDescription: provider.asitSubgroupDescription.unifiedFields, parentComponentKey: provider.getUniqueId());

    accelaUnifiedFormProvider.initProvider();
    accelaUnifiedFormProvider.populateDefaultValues();
    accelaUnifiedFormProvider.fieldValueChangedCallback = provider.fieldValueChangedCallback;

    provider.currentAccelaUnifiedFormProvider = accelaUnifiedFormProvider;
    provider.currentEditIndex = -1;

    WidgetUtil.editAccelaUnifiedForm(context, accelaUnifiedFormProvider, title: 'Add Row'.tr(), onSave: (BuildContext context) {
      var formValues = accelaUnifiedFormProvider.getValuesAsStrings();

      provider.tableProvider.addRow(formValues, valid: true);
      provider.currentAccelaUnifiedFormProvider = null;
    }, onClose: (BuildContext context) {
      provider.currentAccelaUnifiedFormProvider = null;
    }, onBeforeSave: (BuildContext context, AccelaUnifiedFormProvider accelaUnifiedFormProvider) async {
      // var result = await provider.expressionsManagerProvider?.runOnSubmit(provider.getUniqueName(), true);
      // if (result != null) {
      //   Utility.showAlert(
      //     context,
      //     "Form Submit".tr(),
      //     result.message,
      //   );
      // }

      // return result == null;
      return true;
    });
  }

  editRow(BuildContext context, AsitComponentViewProvider provider, {int index = -1, String title = 'Edit Row'}) {
    TableViewRow? tableRow;
    if (index == -1) {
      if (provider.tableProvider.getSelectedCount() == 0) {
        Utility.showAlert(context, "Edit Row".tr(), "You need to select a Row to edit".tr());
        return;
      }

      if (provider.tableProvider.getSelectedCount() > 1) {
        Utility.showAlert(context, "Edit Row".tr(), "You can edit one Row at a time".tr());
        return;
      }

      tableRow = provider.tableProvider.getFirstSelectedRow();
    } else {
      tableRow = provider.tableProvider.getTableRow(index);
    }

    if (tableRow == null) {
      return;
    }

    var accelaUnifiedFormProvider =
        AccelaUnifiedFormProvider(fieldListDescription: provider.asitSubgroupDescription.unifiedFields, parentComponentKey: provider.getUniqueId());
    accelaUnifiedFormProvider.setFieldValues(tableRow.getRowValues(), FieldModifySource.event);
    // superComponentProvider.setValuesFromFormGroup(tableRow.formGroup);
    accelaUnifiedFormProvider.forceReadOnly = provider.isReadOnly;
    accelaUnifiedFormProvider.initProvider();

    provider.currentAccelaUnifiedFormProvider = accelaUnifiedFormProvider;
    provider.currentEditIndex = provider.tableProvider.getFirstSelectedRowIndex();
    accelaUnifiedFormProvider.fieldValueChangedCallback = provider.fieldValueChangedCallback;

    WidgetUtil.editAccelaUnifiedForm(context, accelaUnifiedFormProvider, title: title.tr(), showSaveButton: !provider.isReadOnly,
        onSave: (BuildContext context) {
      //   var formGroup = superComponentProvider.form;

      //   var formValues = FormUtilities.getFormValues(formGroup, superComponentProvider.getFieldListDescription(), false);

      //   FormUtilities.setFormValues(tableRow.formGroup, provider.asitSubgroupDescription.fieldList, formValues);

      //   var contactValid = provider.validateForm(contactDetails.contactType!, contactDetails.values);
      //   contactDetails.valid = contactValid;
      //   tableRow.valid = contactValid;
      tableRow?.setValuesFromString(accelaUnifiedFormProvider.getValuesAsStrings());

      provider.tableProvider.refresh();

      provider.currentAccelaUnifiedFormProvider = null;
      provider.currentEditIndex = -1;
    }, onClose: (BuildContext context) {
      provider.currentAccelaUnifiedFormProvider = null;
      provider.currentEditIndex = -1;
    });
  }

  deleteRow(BuildContext context, AsitComponentViewProvider provider) {
    if (provider.tableProvider.getSelectedCount() == 0) {
      Utility.showAlert(context, "Delete Row".tr(), "You need to select a row to delete".tr());
      return;
    }

    Utility.showOptionsDialog(
      context,
      'Delete Row'.tr(),
      (provider.tableProvider.getSelectedCount() > 1
          ? 'Are you sure you want to delete the selected rows?'.tr(args: ['${provider.tableProvider.getSelectedCount()}'])
          : 'Are you sure you want to delete the selected row?'.tr()),
      // 'Are you sure you want to delete the selected ' +
      //     '${provider.tableProvider.getSelectedCount() > 1 ? provider.tableProvider.getSelectedCount() : ""}' +
      //     'row${provider.tableProvider.getSelectedCount() > 1 ? "s" : ""}?',
      [
        ActionButton(
            title: 'Confirm'.tr(),
            callback: (context) {
              provider.tableProvider.deleteSelectedRows();
              Navigator.of(context).pop();
            }),
        ActionButton(
            title: 'Cancel'.tr(),
            callback: (context) {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
