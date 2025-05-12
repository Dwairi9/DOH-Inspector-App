import 'dart:convert';
import 'dart:developer';

import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/facility_information.dart';
import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/data_models/inspection_with_config.dart';
import 'package:aca_mobile_app/description/inspection_result_group_item.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/providers/error_message_provider.dart';
import 'package:aca_mobile_app/repositories/dohaudits/audit_visits_repository.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/repositories/attachment_repository.dart';
import 'package:aca_mobile_app/repositories/inspection_repository.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:aca_mobile_app/views/draw_view2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../data_models/professional_information.dart';
import '../../data_models/violationCategory.dart';
import '../../data_models/violation_information.dart';

//final auditVisitViewProvider = ChangeNotifierProvider((ref) => AuditVisitViewProvider());

class AuditVisitViewProvider extends ChangeNotifier implements AttachmentObserver {
  AuditVisitViewProvider(this.customId, this.userType, {this.originAuditVisit});

  String customId;
  String userType;
  final infoMessageProvider = ChangeNotifierProvider((ref) {
    final themeNotifier = ref.watch(themeProvider);
    return InfoMessageProvider(themeNotifier);
  });

  List<ChangeNotifierProvider<InspectionProvider>> inspectionProviders = [];
  bool inspectionListExpanded = true;
  String inspectionResult = "";
  String inspectionResultComment = "";
  String otherPartySignatureNotAvailableReason = "";
  PainterController inspectorPainterController = _newController();
  bool inspectorSignatureUploaded = false;
  bool isLoading = false;
  bool isSaving = false;
  bool otherPartySignatureNotAvailable = false;
  PainterController otherPartyPainterController = _newController();
  bool otherPartySignatureUploaded = false;
  ChangeNotifierProviderRef<Object?>? ref;
  double uploadProgress = 0.0;
  ScrollController resultViewScrollController = ScrollController();
  TextEditingController commentController = TextEditingController();
  TextEditingController otherPartySignatureNotAvailableReasonController = TextEditingController();
  String criticalErrorMessage = "";
  AuditVisit? originAuditVisit;
  AuditVisit? auditVisit;

  //*****Submit Violation Page******
  bool isViolationExists = false;
  bool isLoadingViolationExistingCall = false;
  List<ViolationCategory>? violationCategories;
  String selectedViolationCategory = "";

  String violationDate = "";
  ViolationInformation? violationInformation;

  //Facility controllers
  FacilityInformation? facilityInformation;
  final TextEditingController facilityLicenseNumberController = TextEditingController();
  final TextEditingController facilityNameInEnglishController = TextEditingController();
  final TextEditingController facilityNameInArabicController = TextEditingController();
  final TextEditingController facilityCategoryController = TextEditingController();
  final TextEditingController facilityTypeController = TextEditingController();
  final TextEditingController facilitySubTypeController = TextEditingController();
  final TextEditingController facilityLicenseIssueDateController = TextEditingController();
  final TextEditingController facilityLicenseExpiryDateController = TextEditingController();
  final TextEditingController facilityRegionController = TextEditingController();
  final TextEditingController facilityCityController = TextEditingController();

  //Professional controllers
  ProfessionalInformation? professionalInformation;
  final TextEditingController professionalLicenseNumberController = TextEditingController();
  final TextEditingController professionalNameInEnglishController = TextEditingController();
  final TextEditingController professionalNameInArabicController = TextEditingController();
  final TextEditingController professionalCategoryController = TextEditingController();
  final TextEditingController professionalMajorController = TextEditingController();
  final TextEditingController professionalProfessionController = TextEditingController();
  final TextEditingController professionalLicenseIssueDateController = TextEditingController();
  final TextEditingController professionalLicenseExpiryDateController = TextEditingController();

  @override
  List<Attachment> get getAttachments {
    return auditVisit?.attachments ?? [];
  }

  @override
  set setAttachments(List<Attachment> attachments) {
    auditVisit?.attachments = attachments;
    notifyListeners();
  }

  setRef(ChangeNotifierProviderRef<Object?> ref) {
    this.ref = ref;
  }

  initProvider() async {
    await loadAuditVisit();
    await loadViolationCategories();

    getViolationData(customId);

    notifyListeners();
  }

  loadAuditVisit() async {
    setLoading(true);
    setCriticalErrorMessage("");
    var res = await AuditVisitsRepository.getAuditVisit(customId);
    log('response of audit visit ' + res.toString());
    if (!res.success) {
      setCriticalErrorMessage(res.message);
      setLoading(false);
      return;
    }
    auditVisit = AuditVisit.fromMap(res.content);

    clearProviderValues();
    // for (var inspection in inspectionRecord?.inspections ?? []) {
    //   inspection.isRecordInspection = true;
    // }
    setupInspectionProviders();
    setLoading(false);
    notifyListeners();
  }

  clearProviderValues() {
    inspectionProviders = [];
    inspectorPainterController = _newController();
    inspectorSignatureUploaded = false;
    isLoading = false;
    isSaving = false;
    otherPartyPainterController = _newController();
    otherPartySignatureUploaded = false;
    uploadProgress = 0.0;
    resultViewScrollController = ScrollController();
    commentController = TextEditingController();
    otherPartySignatureNotAvailableReasonController = TextEditingController();
    inspectionResult = "";
    inspectionResultComment = "";
    otherPartySignatureNotAvailableReason = "";
    otherPartySignatureNotAvailable = false;
  }

  setupInspectionProviders() {
    inspectionProviders = [];
    for (InspectionWithConfig inspectionWithConfig in auditVisit?.inspectionsWithConfig ?? []) {
      final inspectionProvider = ChangeNotifierProvider((ref) {
        var inspProvider =
            InspectionProvider(inspectionWithConfig.inspection.customId, inspectionWithConfig.inspection.idNumber, parentRecordProvider: null, userType);
        inspProvider.setRef(ref);
        inspProvider.setupInspection(inspectionWithConfig);

        return inspProvider;
      });
      inspectionProviders.add(inspectionProvider);
    }
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  setAsiValues(String subgroupName, Map<String, Object> values) {
    if (auditVisit?.asiValues.containsKey(subgroupName) ?? false) {
      auditVisit?.asiValues[subgroupName] = values;
    }

    notifyListeners();
  }

  setAsitValues(String subgroupName, List<Map<String, Object?>> values) {
    if (auditVisit?.asitValues.containsKey(subgroupName) ?? false) {
      auditVisit?.asitValues[subgroupName] = values;
    }

    notifyListeners();
  }

  Future<ActionObject> updateRecordAsi() async {
    String asiGroup = "";
    if (auditVisit?.asiGroups.isNotEmpty ?? false) {
      asiGroup = auditVisit?.asiGroups.first.group ?? "";
    }
    var res = await InspectionRepository.updateRecordAsiAsit(customId, asiGroup, auditVisit?.asiValues ?? {}, {});

    return res;
  }

  Future<ActionObject> updateRecordAsit() async {
    var res = await InspectionRepository.updateRecordAsiAsit(customId, "", {}, auditVisit?.asitValues ?? {});
    if (res.success) {
      res.message = "Record ASIT Saved Successfully".tr();
    }

    return res;
  }

  Future<ActionObject> updateRecordAsitAsit() async {
    String asiGroup = "";
    if (auditVisit?.asiGroups.isNotEmpty ?? false) {
      asiGroup = auditVisit?.asiGroups.first.group ?? "";
    }
    var res = await InspectionRepository.updateRecordAsiAsit(customId, asiGroup, auditVisit?.asiValues ?? {}, auditVisit?.asitValues ?? {});
    if (res.success) {
      res.message = "Record ASI Saved Successfully".tr();
    }

    return res;
  }

  clearErrorMessage() {
    ref?.read(infoMessageProvider).closeMessage();
  }

  setErrorMessage(String message) {
    ref?.read(infoMessageProvider).setErrorMessage(message);
  }

  signatureUpdated() {
    notifyListeners();
  }

  bool preventBarActions() {
    return isSaving;
  }

  setInspectionResult(String result) {
    inspectionResult = result;
    notifyListeners();
  }

  setInspectionResultComment(String comment) {
    inspectionResultComment = comment;
    notifyListeners();
  }

  setInspectionSelectedForResult(Inspection inspection, bool selected) {
    inspection.selectedForResult = selected;
    notifyListeners();
  }

  List<InspectionResultGroupItem> getInspectionResultGroupItems() {
    var inspectionDescription = auditVisit?.inspectionsWithConfig.firstWhereOrNull((element) => element.inspectionDescription.inspectionResultGroup.isNotEmpty);
    return inspectionDescription?.inspectionDescription.inspectionResultGroup ?? [];
  }

  String generateFileName(String prefix, String extension) {
    var now = DateTime.now();
    // var myInspections = getResultedInspectionIds(true);
    // String inspectionIds = myInspections.join("_");
    String userId = ref?.read(userSessionProvider).userId ?? "";

    return "$prefix-$userId-${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.$extension";
  }

  Future<ActionObject> uploadSignatures() async {
    if (!inspectorSignatureUploaded) {
      var signatureHasContent = inspectorPainterController.hasContent();
      if (signatureHasContent) {
        var file = await inspectorPainterController.finish().toFile(generateFileName("inspector-signature", "png"));
        var res = await AttachmentRepository.uploadEntityDocument(DocumentEntityType.record, file,
            recordId: auditVisit?.recordId ?? "", group: "HAAV", category: "Other", sendProgress: (int sent, int total) {
          setUploadProgress(sent / total);
        });
        if (!res.success) {
          return res;
        }
      }
      inspectorSignatureUploaded = true;
    }

    if (!otherPartySignatureUploaded && !otherPartySignatureNotAvailable) {
      var signatureHasContent = inspectorPainterController.hasContent();
      if (signatureHasContent) {
        var file = await otherPartyPainterController.finish().toFile(generateFileName("other-party-signature", "png"));
        var res = await AttachmentRepository.uploadEntityDocument(DocumentEntityType.record, file,
            recordId: auditVisit?.recordId ?? "", group: "HAAV", category: "Other", sendProgress: (int sent, int total) {
          setUploadProgress(sent / total);
        });
        if (!res.success) {
          return res;
        }
      }
      otherPartySignatureUploaded = true;
    }

    return ActionObject(success: true, message: "");
  }

  Future<ActionObject> verifyAllChecklistsAreSaved() async {
    // for (var i = 0; i < inspection!.checklists.length; i++) {
    //   var checklist = inspection!.checklists[i];
    //   if (!checklist.isSaved) {
    //     var res = await saveChecklist(i);
    //     if (!res.success) {
    //       return res;
    //     } else {
    //       checklist.isSaved = true;
    //     }
    //   }
    // }

    return ActionObject(success: true, message: "");
  }

  List<InspectionProvider> getInspectionProviders(bool myInspectionsOnly) {
    final userSession = ref?.read(userSessionProvider);
    List<InspectionProvider> results = [];
    for (var inspectionWithConfig in inspectionProviders) {
      var inspProvider = ref?.read(inspectionWithConfig);
      if (!myInspectionsOnly || inspProvider?.inspection?.userID.toUpperCase() == userSession?.userId.toUpperCase()) {
        results.add(inspProvider!);
      }
    }

    return results;
  }

  List<Inspection> getInspections(bool myInspections) {
    return getInspectionProviders(myInspections).map((e) => e.inspection!).toList();
  }

  List<Inspection> getIncompleteInspections(bool myInspections) {
    return getInspectionProviders(myInspections).where((element) => !element.areAllChecklistsComplete()).map((e) => e.inspection!).toList();
  }

  List<Inspection> getInspectionsSelectedForResult() {
    return getInspectionProviders(true).where((element) => element.isInspectionSelectedForResult()).map((e) => e.inspection!).toList();
  }

  hasScheduledInspections(bool myInspections) {
    return getInspectionProviders(myInspections).where((element) => element.inspection?.documentDescription == "Insp Scheduled").isNotEmpty;
  }

  List<int> getResultedInspectionIds(bool myInspections) {
    return getInspectionsSelectedForResult().map((e) => e.idNumber).toList();
  }

  prepareInspectionsSelectedForResult() {
    getIncompleteInspections(true).forEach((element) {
      element.selectedForResult = false;
    });
    notifyListeners();
  }

  Future<ActionObject> resultAuditVisit() async {
    if (isSaving) {
      return ActionObject(success: false, message: "");
    }
    resultViewScrollController.jumpTo(0);
    clearErrorMessage();
    setSaving(true);
    if (inspectionResult.isEmpty) {
      setSaving(false);
      return ActionObject(success: false, message: "Please Select an Inspection Result".tr());
    }

    if (inspectionResultComment.isEmpty) {
      setSaving(false);
      return ActionObject(success: false, message: "Please Enter an Inspection Result Comment".tr());
    }

    if (inspectionResult.toLowerCase() == "complete") {
      //   var incompleteInspections = getIncompleteInspections(true);
      //   if (incompleteInspections.isNotEmpty) {
      //     setSaving(false);
      //     return ActionObject(
      //         success: false,
      //         message:
      //             "${"The following inspections are incomplete".tr()}:<br />${incompleteInspections.map((e) => e.getDisplayInspectionType()).toList().join("<br />")}");
      //   }

      var inspectionsSelectedForResult = getInspectionsSelectedForResult();
      if (inspectionsSelectedForResult.isEmpty) {
        setSaving(false);
        return ActionObject(success: false, message: "Please Select at least one Incomplete Inspection to Result".tr());
      }

      if (!inspectorUploadedSignature()) {
        if (!inspectorPainterController.hasContent() || (!otherPartyPainterController.hasContent() && !otherPartySignatureNotAvailable)) {
          setSaving(false);
          return ActionObject(success: false, message: "Please Sign the Inspection".tr());
        }

        if (otherPartySignatureNotAvailable && otherPartySignatureNotAvailableReason.isEmpty) {
          setSaving(false);
          return ActionObject(success: false, message: "Please Enter the Justification for not having a Signature".tr());
        }
        var res = await uploadSignatures();
        if (!res.success) {
          setSaving(false);
          return res;
        }
      }
    }

    var res = await verifyAllChecklistsAreSaved();
    if (!res.success) {
      setSaving(false);
      return res;
    }

    res = await AuditVisitsRepository.resultAuditVisit(
        customId, getResultedInspectionIds(true), inspectionResult, inspectionResultComment, userType, otherPartySignatureNotAvailableReason);

    setSaving(false);

    return res;
  }

  setUploadProgress(uploadProgress) {
    this.uploadProgress = uploadProgress;
    notifyListeners();
  }

  setSaving(saving) {
    isSaving = saving;
    notifyListeners();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 4.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  String getDepartmentUserFullNameByUserId(String userId) {
    var user = auditVisit?.auditDepartmentInspectors.firstWhereOrNull((element) => element.username.toUpperCase() == userId.toUpperCase());
    if (user != null) {
      return "${user.firstName} ${user.lastName}";
    }
    return userId.toUpperCase();
  }

  setOtherPartySignatureNotAvailable(bool notAvailable) {
    otherPartySignatureNotAvailable = notAvailable;
    notifyListeners();
  }

  setOtherPartySignatureNotAvailableReason(String reason) {
    otherPartySignatureNotAvailableReason = reason;
    notifyListeners();
  }

  bool inspectorUploadedSignature() {
    String userId = ref?.read(userSessionProvider).userId ?? "";

    return auditVisit?.attachments
            .where((element) =>
                element.category == "Other" &&
                element.group == "HAAV" &&
                element.docName.startsWith("inspector-signature-") &&
                element.docName.contains(userId))
            .isNotEmpty ??
        false;
  }

  setCriticalErrorMessage(String message) {
    criticalErrorMessage = message;
    notifyListeners();
  }

  String getAuditVisitTitle() {
    return auditVisit?.getDisplayRecordAlias() ?? originAuditVisit?.getDisplayRecordAlias() ?? "";
  }

  String getAuditVisitSubtitle() {
    return auditVisit?.getDisplaySubtitle() ?? originAuditVisit?.getDisplaySubtitle() ?? "";
  }

  ///Violation api calls
  void getViolationData(String customId) async {
    isLoadingViolationExistingCall = true;
    notifyListeners();
    var res = await AuditVisitsRepository.getViolationsExistsInformation(customId);
    log('i am printing response ' + res.toString());
    isLoadingViolationExistingCall = false;
    if (res.success) {
      isViolationExists = true;
    }
    notifyListeners();
  }

  // void getViolationCategoryList() async {
  //
  // }
  loadViolationCategories() async {
    String userId = ref?.read(userSessionProvider).userId ?? "";
    setLoading(true);
    setCriticalErrorMessage("");
    var res = await AuditVisitsRepository.getViolationCategoryList(userId, 'en');
    log('response of ViolationCategories' + res.toString());

    if (!res.success) {
      setCriticalErrorMessage(res.message);
      setLoading(false);
      return;
    }

    var resultList = res.content.map((x) => ViolationCategory.fromMap(x));
    violationCategories = List<ViolationCategory>.from(resultList);

    setLoading(false);
  }

  //Submit Violation Page

  List<ViolationCategory> getViolationCategoryList() {
    return violationCategories ?? [];
  }

  Future<FacilityInformation?> getViolationFacilityInfo() async{
    String userId = ref?.read(userSessionProvider).userId ?? "";
    setLoading(true);
    setCriticalErrorMessage("");

    var facilityInfo = await AuditVisitsRepository.getViolationFacilityInfo(customId, userId, 'en');

    setLoading(false);
    return facilityInfo;
  }

  Future<ProfessionalInformation?> getViolationProfessionalInfo(String licenseNumber) async{
    setLoading(true);
    setCriticalErrorMessage("");

    var professionalInfo = await AuditVisitsRepository.getViolationProfessionalInfo(licenseNumber);
    setLoading(false);

    return professionalInfo;
  }

  void setViolationCategory(String value) async{
    selectedViolationCategory = value;

    facilityInformation = null;
    facilityLicenseNumberController.text = "";
    facilityNameInEnglishController.text = "";
    facilityNameInArabicController.text = "";
    facilityCategoryController.text = "";
    facilityTypeController.text = "";
    facilitySubTypeController.text = "";
    facilityLicenseIssueDateController.text = "";
    facilityLicenseExpiryDateController.text = "";
    facilityRegionController.text = "";
    facilityCityController.text = "";

    professionalInformation = null;
    professionalNameInEnglishController.text = "";
    professionalLicenseNumberController.text = "";
    professionalNameInArabicController.text = "";
    professionalCategoryController.text = "";
    professionalMajorController.text = "";
    professionalProfessionController.text = "";
    professionalLicenseIssueDateController.text = "";
    professionalLicenseExpiryDateController.text = "";

    notifyListeners();

    if(value == "Facility") {
      setLoading(true);

      var facilityInfo = await getViolationFacilityInfo();
      if (facilityInfo == null) {
        setCriticalErrorMessage("Could not get facility information");
        setLoading(false);
        return;
      }

      facilityLicenseNumberController.text = facilityInfo.facilityLicenseNumber;
      facilityNameInEnglishController.text = facilityInfo.facilityNameInEnglish;
      facilityNameInArabicController.text = facilityInfo.facilityNameInArabic;
      facilityCategoryController.text = facilityInfo.facilityCategory;
      facilityTypeController.text = facilityInfo.facilityType;
      facilitySubTypeController.text = facilityInfo.facilitySubType;
      facilityLicenseIssueDateController.text = facilityInfo.facilityLicenseIssueDate;
      facilityLicenseExpiryDateController.text = facilityInfo.facilityLicenseExpiryDate;
      facilityRegionController.text = facilityInfo.facilityRegion;
      facilityCityController.text = facilityInfo.facilityCity;
      facilityInformation = FacilityInformation(facilityLicenseNumber: facilityInfo.facilityLicenseNumber, facilityNameInEnglish: facilityInfo.facilityNameInEnglish,
        facilityNameInArabic: facilityInfo.facilityNameInArabic, facilityCategory: facilityInfo.facilityCategory, facilityType: facilityInfo.facilityType,
        facilitySubType: facilityInfo.facilitySubType, facilityLicenseIssueDate: facilityInfo.facilityLicenseIssueDate, facilityLicenseExpiryDate: facilityInfo.facilityLicenseExpiryDate,
        facilityRegion: facilityInfo.facilityRegion, facilityCity: facilityInfo.facilityCity);

      notifyListeners();

      setLoading(false);
    }
  }

  void setProfessionalInfo(String licenseNumber) async{
    professionalInformation = null;
    professionalLicenseNumberController.text = "";
    professionalNameInEnglishController.text = "";
    professionalNameInArabicController.text = "";
    professionalCategoryController.text = "";
    professionalMajorController.text = "";
    professionalProfessionController.text = "";
    professionalLicenseIssueDateController.text = "";
    professionalLicenseExpiryDateController.text = "";

    notifyListeners();

    setLoading(true);

    var professionalInfo = await getViolationProfessionalInfo(licenseNumber);
    if (professionalInfo == null) {
      setCriticalErrorMessage("Could not get professional information");
      setLoading(false);
      return;
    }
    professionalLicenseNumberController.text = licenseNumber;
    professionalNameInEnglishController.text = professionalInfo.professionalNameInEnglish;
    professionalNameInArabicController.text = professionalInfo.professionalNameInArabic;
    professionalCategoryController.text = professionalInfo.professionalCategory;
    professionalMajorController.text = professionalInfo.professionalMajor;
    professionalProfessionController.text = professionalInfo.professionalProfession;
    professionalLicenseIssueDateController.text = professionalInfo.professionalLicenseIssueDate;
    professionalLicenseExpiryDateController.text = professionalInfo.professionalLicenseExpiryDate;
    professionalInformation = ProfessionalInformation(professionalLicenseNumber: licenseNumber, professionalNameInEnglish: professionalInfo.professionalNameInEnglish,
        professionalNameInArabic: professionalInfo.professionalNameInArabic, professionalCategory: professionalInfo.professionalCategory,
        professionalMajor: professionalInfo.professionalMajor, professionalProfession: professionalInfo.professionalProfession,
        professionalLicenseIssueDate: professionalInfo.professionalLicenseIssueDate, professionalLicenseExpiryDate: professionalInfo.professionalLicenseExpiryDate);

    setLoading(false);
    notifyListeners();
  }

  Future<ActionObject> submitViolation() async {
    setLoading(true);

    if (isSaving) {
      return ActionObject(success: false, message: "");
    }

    clearErrorMessage();
    setSaving(true);

    if (selectedViolationCategory.isEmpty) {
      setSaving(false);
      return ActionObject(success: false, message: "Please Select a Violation Category".tr());
    }

    if (selectedViolationCategory == 'Professional' && professionalLicenseNumberController.text.isEmpty) {
      setSaving(false);
      return ActionObject(success: false, message: "Please Enter a Professional License Number".tr());
    }

    violationInformation = ViolationInformation(relatedAuditRequestNumber: customId, category: selectedViolationCategory, violationDate: violationDate);
    var result = await AuditVisitsRepository.submitViolation(violationInformation, facilityInformation, professionalInformation);

    setSaving(false);
    setLoading(false);

    return result;
  }

  @override
  void dispose() {
    facilityLicenseNumberController.dispose();
    facilityNameInEnglishController.dispose();
    facilityNameInArabicController.dispose();
    facilityCategoryController.dispose();
    facilityTypeController.dispose();
    facilitySubTypeController.dispose();
    facilityLicenseIssueDateController.dispose();
    facilityLicenseExpiryDateController.dispose();
    facilityRegionController.dispose();
    facilityCityController.dispose();

    professionalLicenseNumberController.dispose();
    professionalNameInEnglishController.dispose();
    professionalNameInArabicController.dispose();
    professionalCategoryController.dispose();
    professionalMajorController.dispose();
    professionalProfessionController.dispose();
    professionalLicenseIssueDateController.dispose();
    professionalLicenseExpiryDateController.dispose();

    super.dispose();
  }
  ///


}


// setLoading(true);
// setCriticalErrorMessage("");
// var res = await AuditVisitsRepository.getAuditVisit(customId);
// if (!res.success) {
// setCriticalErrorMessage(res.message);
// setLoading(false);
// return;
// }
// auditVisit = AuditVisit.fromMap(res.content);
//
// clearProviderValues();
// // for (var inspection in inspectionRecord?.inspections ?? []) {
// //   inspection.isRecordInspection = true;
// // }
// setupInspectionProviders();
// setLoading(false);
// notifyListeners();