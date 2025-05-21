import 'package:aca_mobile_app/data_models/violationCategory.dart';
import 'package:flutter/material.dart';

class ViolationClause{
  bool isSelected;
  String? violationMode;
  String? violationType;
  List<ViolationCategory> availableTypes;

  String violationReference = "";
  String violationAmount = "";
  String violationOccurrence = "";
  String violationFollowUp = "";
  String violationAction = "";
  String violationRemarks = "";

  TextEditingController violationRemarksController = TextEditingController();

  ViolationClause({
    this.isSelected = false,
    this.violationMode,
    this.violationType,
    this.availableTypes = const [],
    this.violationReference = "",
    this.violationAmount = "",
    this.violationOccurrence = "",
    this.violationFollowUp = "",
    this.violationAction = "",
    this.violationRemarks = "",
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
      violationRemarks: map['remarks'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'violationReference': violationReference,
      'violationMode': violationMode,
      'violationType': violationType,
      'violationAmount': violationAmount,
      'remarks': violationRemarks,
      'occurrence': violationOccurrence,
      'followUpDays': violationFollowUp,
      'action': violationAction
    };
  }
}

