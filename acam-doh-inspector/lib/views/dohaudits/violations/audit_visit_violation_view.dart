import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_view_provider.dart';
import 'package:aca_mobile_app/view_widgets/tappable_list_item_widget.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_attachment_view.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_clauses_view.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_facility_widget.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_professional_widget.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_section_head_view.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_workflow_decision_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aca_mobile_app/utility/utility.dart';

import '../../../data_models/violationCategory.dart';
import '../../../description/inspection_result_group_item.dart';
import 'violation_signature_view.dart';
import 'violation_title_subtitle_view.dart';

class AuditVisitViolationView extends ConsumerWidget {
  const AuditVisitViolationView(this.auditVisit, { required this.auditVisitViewProvider, super.key});
  final AuditVisit auditVisit;
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final provider = ref.watch(auditVisitViewProvider);
    final notifier = ref.read(auditVisitViewProvider.notifier);

    DateTime dateValue = DateTime.now();
    final locale = Utility.isRTL(context) ? 'ar' : 'en_US';

    final day = DateFormat('dd', locale).format(dateValue);
    final month = DateFormat('MMM', locale).format(dateValue);
    final year = DateFormat('yyyy', locale).format(dateValue);
    provider.violationDate = DateFormat('dd/MM/yyyy', locale).format(dateValue);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: provider.isLoadingViolationExistingCall ?
            const Center(child: CircularProgressIndicator(),)
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text('Violation Heading',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                      const SizedBox(height: 10,),
                    ],
                  )),
                  SizedBox(width: 50),
                  Expanded(child:  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 20, color: Theme.of(context).primaryColor),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            day,
                            //'14',
                            //DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                            style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //   dateValue!.year.toString(),
                                //'2024',
                                year,
                                //DateFormat.y(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString(),
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 0.8),
                              ),
                              const SizedBox(height: 2,),
                              Text(
                                //'DEC',
                                month,
                                //  DateFormat.MMM(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toUpperCase(),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1),
                              )
                            ],
                          )
                        ],
                      ),
                      Text('Violation Date',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
                      ),
                    ],
                  ),)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                   ViolationTitleSubtitleView(title: auditVisit.customId ,subTitle: 'Related Audit Number', width: 0.9),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10,),

              InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeNotifier.light3Color, width: 0.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedViolationCategory,
                      elevation: 16,
                      isExpanded: true,
                      style: TextStyle(color: themeNotifier.primaryColor),
                      onChanged: (String? value) {
                        if (value != null) {
                          notifier.setViolationCategory(value);
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: themeNotifier.light4Color,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: "",
                          child: Text("Set Status".tr(), style: Theme.of(context).textTheme.headlineMedium),
                        ),
                        ...provider.getViolationCategoryList().map<DropdownMenuItem<String>>((ViolationCategory item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: AutoSizeText(
                              item.text,
                              minFontSize: 11,
                              stepGranularity: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  )),


              const SizedBox(height: 1,),
              Text('Violation Category',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
              ),
              if(provider.selectedViolationCategory == 'Facility') ...[
                ViolationFacilityWidget(licenseNumber: provider.facilityLicenseNumberController.text, englishName: provider.facilityNameInEnglishController.text,
                    arabicName: provider.facilityNameInArabicController.text, category: provider.facilityCategoryController.text,
                    type: provider.facilityTypeController.text, subType: provider.facilitySubTypeController.text, licenseIssueDate: provider.facilityLicenseIssueDateController.text,
                    licenseExpiryDate: provider.facilityLicenseExpiryDateController.text, region: provider.facilityRegionController.text, city: provider.facilityCityController.text,)
              ]
              else if(provider.selectedViolationCategory == 'Professional')
                ViolationProfessionalWidget(licenseNumber: provider.professionalLicenseNumberController.text, englishName: provider.professionalNameInEnglishController.text,
                    arabicName: provider.professionalNameInArabicController.text, category: provider.professionalCategoryController.text,
                    profession: provider.professionalProfessionController.text, major: provider.professionalMajorController.text,
                    licenseIssueDate: provider.professionalLicenseIssueDateController.text, licenseExpiryDate: provider.professionalLicenseExpiryDateController.text,
                    onProfessionalLicenseNumberChanged: (lecenseNumber){
                      provider.setProfessionalInfo(lecenseNumber);
                    },),
              Divider(
                height: 25,
                color: Colors.grey.shade700,
              ),
              // Row(
              //   children: [
              //     Text('Comment',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
              //     const Spacer(),
              //     Text('Show comment to the facility',style: Theme.of(context).textTheme.bodySmall!),
              //     Checkbox(
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       value: false,
              //       onChanged: (value) => {
              //         // provider.setRememberPassword(value ?? false),
              //       },
              //     ),
              //
              //
              //   ]
              // ),
              // TextField(
              //   maxLines: 3,
              //   style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              //   decoration: InputDecoration(
              //     contentPadding: const EdgeInsets.all(8),
              //     //errorText: field.valid ? null : "required field".tr(),
              //     hintText: 'Enter the general comment about the violation',
              //   ),
              // ),
              SizedBox(height: 20,),
              TappableListItem(
                  themeNotifier: themeNotifier,
                  title: 'Section Head Decision'.tr(),
                  subtitle: 'Draft',
                  icon: Icons.quickreply_outlined,
                  count: 0,
                  showCount: false,
                  onTap: () {
                    showViolationSectionHead(context);
                    // showViolation(context, auditVisit);
                  }),
              TappableListItem(
                  themeNotifier: themeNotifier,
                  title: 'Violation Caluses'.tr(),
                  icon: Icons.notes,
                  count: 0,
                  showCount: false,
                  onTap: () {

                     showViolationClauses(context);
                  }),
              TappableListItem(
                  themeNotifier: themeNotifier,
                  title: 'Attachments'.tr(),
                  icon: Icons.attachment,
                  count: 0,
                  showCount: false,
                  onTap: () {

                     showViolationAttachments(context);
                  }),
              TappableListItem(
                  themeNotifier: themeNotifier,
                  title: 'Signature'.tr(),
                  icon: Icons.verified_outlined,
                  count: 0,
                  showCount: false,
                  onTap: () {
                    showViolationSignature(context);
                  }),
              TappableListItem(
                  themeNotifier: themeNotifier,
                  title: 'Workflow and Decisions'.tr(),
                  icon: Icons.workspaces_outline,
                  count: 0,
                  showCount: false,
                  onTap: () {
                    showViolationWorkflowDecision(context);
                  }),
              SizedBox(height: 50,),

              if (provider.isLoading)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  showViolationAttachments(BuildContext context) {
    WidgetUtil.showFullScreenDialog(context, ViolationAttachmentView(), "Attachments".tr(), subtitle: 'PTL-HAVR-2024-0001385 - Draft', [
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }
  showViolationSignature(BuildContext context) {
    WidgetUtil.showFullScreenDialog(context, ViolationSignatureView(),"Signature".tr(), subtitle: 'PTL-HAVR-2024-0001385 - Draft', [
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }
  showViolationSectionHead(BuildContext context) {
    WidgetUtil.showFullScreenDialog(context, ViolationSectionHeadView(),"Section Head Decision".tr(), subtitle: 'PTL-HAVR-2024-0001385 - In Progress', [
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  showViolationClauses(context) {
    WidgetUtil.showFullScreenDialog(context, ViolationClausesView(),"Violation Clauses".tr(), subtitle: 'PTL-HAVR-2024-0001385 - In Progress', [
      FullScreenActionButton(
          title: "Save".tr(),
          callback: (context, loader) async {

          })
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  showViolationWorkflowDecision(context) {
    WidgetUtil.showFullScreenDialog(context, ViolationWorkflowDecisionView(),"Workflow and Decision".tr(), subtitle: 'PTL-HAVR-2024-0001385 - In Progress', [
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

}