import 'package:aca_mobile_app/data_models/violationCategory.dart';
import 'package:flutter/material.dart';

class ViolationClause{
  bool isSelected;
  String violationMode;
  String violationModeError;
  String violationType;
  String violationTypeError;
  String violationDate;

  List<ViolationCategory> availableTypes;

  String violationReference = "";
  String violationAmount = "";
  String violationOccurrence = "";
  String violationFollowUp = "";
  String violationAction = "";
  String violationRemarks = "";
  String violationFeeNumber = "";

  TextEditingController violationRemarksController = TextEditingController();

  ViolationClause({
    this.isSelected = false,
    this.violationMode = "",
    this.violationModeError = "",
    this.violationType = "",
    this.violationTypeError = "",
    this.availableTypes = const [],
    this.violationReference = "",
    this.violationAmount = "",
    this.violationOccurrence = "",
    this.violationFollowUp = "",
    this.violationAction = "",
    this.violationRemarks = "",
    this.violationFeeNumber = "",
    this.violationDate = "",
    violationRemarksController
  });

  factory ViolationClause.fromMap(Map<String, dynamic> map) {
    return ViolationClause(
      violationMode: map['violationMode'] ?? '',
      violationType: map['violationType'] ?? '',
      violationReference: map['violationReference'] ?? '',
      violationAmount: map['violationAmount'] ?? '',
      violationOccurrence: map['occurrence'] ?? '',
      violationFollowUp: map['followUpDays'] ?? '',
      violationAction: map['action'] ?? '',
      violationRemarks: map['remarks'] ?? '',
      violationFeeNumber: map['number'] ?? '',
      violationDate: map['violationDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'violationReference': violationReference,
      'violationMode': violationMode,
      'violationType': violationType,
      'violationAmount': violationAmount,
      'violationDate': violationDate,
      'remarks': violationRemarks,
      'occurrence': violationOccurrence,
      'followUpDays': violationFollowUp,
      'action': violationAction,
      'number': violationFeeNumber
    };
  }
}

