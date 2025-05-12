import 'package:aca_mobile_app/description/dropdown_value_description.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_data_objects/unified_form_field.dart';
import 'package:aca_mobile_app/view_providers/accela_unified_form_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccelaUnifiedFormView extends ConsumerWidget {
  late final ChangeNotifierProvider<AccelaUnifiedFormProvider> accelaUnifiedFormProvider;
  final bool scrollable;
  final bool isEdit;

  AccelaUnifiedFormView(AccelaUnifiedFormProvider accelaUnifiedFormProvider, {Key? key, this.scrollable = false, this.isEdit = false}) : super(key: key) {
    this.accelaUnifiedFormProvider = ChangeNotifierProvider((ref) => accelaUnifiedFormProvider);
    if (isEdit) {
      accelaUnifiedFormProvider.setToEditMode();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(accelaUnifiedFormProvider);
    List<UnifiedFormField> fieldList = provider.getDisplayFields();
    var isRtl = Utility.isRTL(context);

    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(14.0, 6, 14, 6),
        scrollDirection: Axis.vertical,
        physics: scrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: fieldList.length,
        itemBuilder: (context, index) {
          final field = fieldList[index];
          return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (field.showLabel())
                    Container(
                      alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
                      child: Text(field.getDisplayLabel(), style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  if (field.type == AccelaFieldTypes.yesno)
                    Container(
                      alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
                      child: Text(
                        field.getDisplayLabel(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: !field.valid ? themeNotifier.errorColor : null),
                      ),
                    ),
                  if (field.type != AccelaFieldTypes.checkbox) const SizedBox(height: 2),
                  getWidgetByFieldType(field, provider, themeNotifier),
                  if (field.message.isNotEmpty /* || !field.valid*/)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
                      child: Container(
                        alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
                        child: Text(
                          field.message,
                          //   field.valid ? field.message : "required field".tr(),
                          style: TextStyle(color: themeNotifier.errorColor),
                        ),
                      ),
                    ),
                ],
              ));
        });
  }

  Widget getWidgetByFieldType(UnifiedFormField field, AccelaUnifiedFormProvider provider, ThemeNotifier themeNotifier) {
    if ((field.readOnly || provider.forceReadOnly)) {
      return AcamReadonlyWidget(
        field: field,
        value: field.getValueAsString(forDisplay: true, datesAsIs: true),
      );
    } else if (field.type == AccelaFieldTypes.text) {
      return AcamTextField(field, provider);
    } else if (field.type == AccelaFieldTypes.date) {
      return AcamDateField(field, provider);
    } else if (field.type == AccelaFieldTypes.yesno) {
      return AcamYesNoField(field, provider);
    } else if (field.type == AccelaFieldTypes.number) {
      return AcamNumberField(field, provider);
    } else if (field.type == AccelaFieldTypes.dropdown) {
      return AcamDropdownFieldWidget(field, provider);
    } else if (field.type == AccelaFieldTypes.textarea) {
      return AcamTextAreaField(field, provider);
    } else if (field.type == AccelaFieldTypes.time) {
      return AcamTimeField(field, provider);
    } else if (field.type == AccelaFieldTypes.money) {
      return AcamTextField(field, provider);
    } else if (field.type == AccelaFieldTypes.checkbox) {
      return AcamCheckboxField(field, provider);
    }

    return const Text('Not implemented');
  }
}

class AcamReadonlyWidget extends ConsumerWidget {
  const AcamReadonlyWidget({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  final UnifiedFormField field;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    if (field.type == AccelaFieldTypes.checkbox) {
      return Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          if (value.toUpperCase() == "CHECKED" || value.toUpperCase() == "YES")
            Icon(
              Icons.check_box,
              color: themeNotifier.iconColor,
            ),
          if (value.toUpperCase() != "CHECKED" && value.toUpperCase() != "YES")
            Icon(
              Icons.check_box_outline_blank,
              color: themeNotifier.iconColor,
            ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: AutoSizeText(
              field.getLabel(),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ],
      );
    } else if (field.type == AccelaFieldTypes.yesno) {
      return Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          if (value.toUpperCase() == "YES")
            Icon(
              Icons.radio_button_checked,
              color: themeNotifier.iconColor,
            )
          else
            Icon(
              Icons.radio_button_off,
              color: themeNotifier.iconColor,
            ),
          const SizedBox(
            width: 5,
          ),
          AutoSizeText(
            "Yes".tr(),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxLines: 1,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            width: 20,
          ),
          if (value.toUpperCase() == "NO")
            Icon(
              Icons.radio_button_checked,
              color: themeNotifier.iconColor,
            )
          else
            Icon(
              Icons.radio_button_off,
              color: themeNotifier.iconColor,
            ),
          const SizedBox(
            width: 5,
          ),
          AutoSizeText(
            "No".tr(),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxLines: 1,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      );
    } else {
      return Container(
          height: field.type == AccelaFieldTypes.textarea ? 90 : 48,
          decoration: BoxDecoration(
            border: Border.all(color: themeNotifier.light3Color, width: 0.0),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              if (field.type == AccelaFieldTypes.date) ...[
                Center(
                  child: Icon(
                    Icons.date_range,
                    color: themeNotifier.iconColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
              if (field.type == AccelaFieldTypes.time) ...[
                Center(
                  child: Icon(
                    Icons.timer,
                    color: themeNotifier.iconColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
              Expanded(child: SingleChildScrollView(child: Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14)))),
              if (field.type == AccelaFieldTypes.dropdown ||
                  field.type == AccelaFieldTypes.autocomplete ||
                  field.type == AccelaFieldTypes.date ||
                  field.type == AccelaFieldTypes.time)
                Center(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: themeNotifier.iconColor,
                  ),
                ),
              const SizedBox(
                width: 6,
              )
            ],
          ));
    }
  }
}

class AcamDropdownFieldWidget extends ConsumerWidget {
  const AcamDropdownFieldWidget(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);

    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: field.valid ? themeNotifier.getColor("light3") : themeNotifier.getColor("error"), width: 0.0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: field.getValueAsString(),
          elevation: 16,
          isExpanded: true,
          style: TextStyle(color: themeNotifier.primaryColor),
          onChanged: (String? value) {
            if (value != null) {
              provider.setFieldValue(field.fieldId, value, FieldModifySource.userChange);
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: field.valid ? themeNotifier.light4Color : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color,
          ),
          items: [
            DropdownMenuItem<String>(
              value: "",
              child: Text("--Select--".tr(), style: Theme.of(context).textTheme.headlineMedium),
            ),
            ...field.valueList.map<DropdownMenuItem<String>>((DropDownValueDescription item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Text(
                  item.text,
                  //   minFontSize: 10,
                  //   stepGranularity: 1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: themeNotifier.dark2Color),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}

class AcamCheckboxField extends ConsumerWidget {
  const AcamCheckboxField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);

    return InkWell(
      onTap: () {
        provider.setFieldValue(field.fieldId, !field.getValueAsBool(), FieldModifySource.userChange);
      },
      child: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
              color: Colors.white,
              width: 16,
              height: 16,
              child: Checkbox(
                checkColor: Colors.white,
                value: field.getValueAsBool(),
                onChanged: (bool? value) {
                  provider.setFieldValue(field.fieldId, value, FieldModifySource.userChange);
                },
              )),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: AutoSizeText(
              field.getDisplayLabel(),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: !field.valid ? themeNotifier.errorColor : null),
            ),
          )
        ],
      ),
    );
  }
}

class AcamYesNoField extends ConsumerWidget {
  const AcamYesNoField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Radio<String>(
            fillColor: MaterialStateProperty.all<Color>(themeNotifier.primaryColor),
            key: Key("${field.key}yes"),
            groupValue: field.getValueAsString().toUpperCase(),
            value: "YES",
            onChanged: (String? value) {
              provider.setFieldValue(field.getFieldId(), value, FieldModifySource.userChange);
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        AutoSizeText(
          "Yes".tr(),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxLines: 1,
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Radio<String>(
            fillColor: MaterialStateProperty.all<Color>(themeNotifier.primaryColor),
            key: Key("${field.key}no"),
            groupValue: field.getValueAsString().toUpperCase(),
            value: "NO",
            onChanged: (String? value) {
              provider.setFieldValue(field.getFieldId(), value, FieldModifySource.userChange);
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        AutoSizeText(
          "No".tr(),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxLines: 1,
        ),
      ],
    );
  }
}

class AcamTextField extends ConsumerWidget {
  const AcamTextField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController textEditingController = TextEditingController()..text = field.getValueAsString();
    // field.textEditingController.text = provider.getFieldValueAsString(field.fieldId);
    final themeNotifier = ref.watch(themeProvider);
    return Focus(
      child: TextField(
        key: field.key,
        controller: field.textEditingController,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: themeNotifier.light4Color),
          labelStyle: Theme.of(context).textTheme.labelMedium,
          errorText: field.valid ? null : "required field".tr(),
          hintText: field.unit,
        ),
        onChanged: (value) {
          // expressions are only triggered on field unfocus
          provider.setFieldValue(field.fieldId, value, FieldModifySource.userChange);
        },
      ),
      onFocusChange: (focused) {
        if (!focused) {
          provider.setFieldValue(field.fieldId, field.textEditingController.text, FieldModifySource.userBlur);
        } else {
          field.textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: field.textEditingController.text.length));
        }
      },
    );
  }
}

class AcamTextAreaField extends ConsumerWidget {
  const AcamTextAreaField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController textEditingController = TextEditingController()..text = field.getValueAsString();
    // field.textEditingController.text = provider.getFieldValueAsString(field.fieldId);
    return SizedBox(
      height: 90,
      child: Focus(
        child: TextField(
          key: field.key,
          controller: field.textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 3,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            errorText: field.valid ? null : "required field".tr(),
            hintText: field.unit,
          ),
          onChanged: (value) {
            // expressions are only triggered on field unfocus
            provider.setFieldValue(field.fieldId, value, FieldModifySource.userChange);
          },
        ),
        onFocusChange: (focused) {
          if (!focused) {
            provider.setFieldValue(field.fieldId, field.textEditingController.text, FieldModifySource.userBlur);
          } else {
            field.textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: field.textEditingController.text.length));
          }
        },
      ),
    );
  }
}

class AcamNumberField extends ConsumerWidget {
  const AcamNumberField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController textEditingController = TextEditingController()..text = field.getValueAsString();
    // field.textEditingController.text = provider.getFieldValueAsString(field.fieldId);
    return Focus(
      child: TextField(
        key: field.key,
        controller: field.textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(4),
          errorText: field.valid ? null : "required field".tr(),
          hintText: field.unit,
        ),
        onChanged: (value) {
          // expressions are only triggered on field unfocus
          provider.setFieldValue(field.fieldId, value, FieldModifySource.userChange);
        },
      ),
      onFocusChange: (focused) {
        if (!focused) {
          provider.setFieldValue(field.fieldId, field.textEditingController.text, FieldModifySource.userBlur);
        } else {
          field.textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: field.textEditingController.text.length));
        }
      },
    );
  }
}

class AcamTimeField extends ConsumerWidget {
  const AcamTimeField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    var timeOfDay = field.getFieldValue();

    TimeOfDay initialTime = timeOfDay is TimeOfDay ? timeOfDay : TimeOfDay.now();
    field.textEditingController.text = provider.getFieldValueAsString(field.fieldId);
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: themeNotifier.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: themeNotifier.dark3Color,
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                  foregroundColor: themeNotifier.primaryColor,
                  textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifier.primaryColor),
                )),
              ),
              child: child!,
            );
          },
        );
        if (picked == null) {
          return;
        }
        provider.setFieldValue(field.fieldId, picked, FieldModifySource.userChange);
        field.textEditingController.text = provider.getFieldValueAsString(field.fieldId);
      },
      child: IgnorePointer(
        child: TextField(
          controller: field.textEditingController,
          readOnly: true,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          // enabled: false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            prefixIcon: Icon(Icons.timer, color: field.valid ? null : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color),
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: field.valid ? null : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color),
            errorText: field.valid ? null : "required field".tr(),
          ),
        ),
      ),
    );
  }
}

class AcamDateField extends ConsumerWidget {
  const AcamDateField(
    this.field,
    this.provider, {
    Key? key,
  }) : super(key: key);
  final AccelaUnifiedFormProvider provider;
  final UnifiedFormField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    // String dateStr = '';

    var date = field.getFieldValue();
    // if (date is DateTime) {
    //   dateStr = Utility.dateToString(date, "dd/MM/yyyy");
    // }
    DateTime initialDate = date is DateTime ? date : DateTime.now();
    field.textEditingController.text = provider.getFieldValueAsString(field.fieldId, dateAsIs: true);
    // TextEditingController textEditingController = TextEditingController()..text = dateStr;
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: themeNotifier.primaryColor,
                    onPrimary: Colors.white,
                    onSurface: themeNotifier.dark3Color,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                    foregroundColor: themeNotifier.primaryColor,
                    textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifier.primaryColor),
                  )),
                ),
                child: child!,
              );
            },
            initialDate: initialDate,
            selectableDayPredicate: (DateTime val) => true,
            firstDate: DateTime(1901, 12),
            lastDate: DateTime(2400, 12));
        if (picked == null) {
          return;
        }
        provider.setFieldValue(field.fieldId, picked, FieldModifySource.userChange);
        field.textEditingController.text = provider.getFieldValueAsString(field.fieldId, dateAsIs: true);
      },
      child: IgnorePointer(
        child: TextField(
          controller: field.textEditingController,
          readOnly: true,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          // enabled: false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            prefixIcon: Icon(Icons.date_range, color: field.valid ? null : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color),
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: field.valid ? null : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color),
            errorText: field.valid ? null : "required field".tr(),
          ),
        ),
      ),
    );
  }
}
