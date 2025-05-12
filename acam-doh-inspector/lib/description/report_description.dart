import 'dart:convert';

import 'package:aca_mobile_app/description/report_param_description.dart';
import 'package:flutter/foundation.dart';

class ReportDescription {
  final String module;
  final String reportName;
  final String reportNameDisp;
  final String reportId;
  final String reportSingleWindow;
  final String reportPrintOnly;
  final String edmsMode;
  final List<ReportParamDescription> params;
  ReportDescription({
    required this.module,
    required this.reportName,
    required this.reportNameDisp,
    required this.reportId,
    required this.reportSingleWindow,
    required this.reportPrintOnly,
    required this.edmsMode,
    required this.params,
  });

  ReportDescription copyWith({
    String? module,
    String? reportName,
    String? reportNameDisp,
    String? reportId,
    String? reportSingleWindow,
    String? reportPrintOnly,
    String? edmsMode,
    List<ReportParamDescription>? params,
  }) {
    return ReportDescription(
      module: module ?? this.module,
      reportName: reportName ?? this.reportName,
      reportNameDisp: reportNameDisp ?? this.reportNameDisp,
      reportId: reportId ?? this.reportId,
      reportSingleWindow: reportSingleWindow ?? this.reportSingleWindow,
      reportPrintOnly: reportPrintOnly ?? this.reportPrintOnly,
      edmsMode: edmsMode ?? this.edmsMode,
      params: params ?? this.params,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'module': module,
      'reportName': reportName,
      'reportNameDisp': reportNameDisp,
      'reportId': reportId,
      'reportSingleWindow': reportSingleWindow,
      'reportPrintOnly': reportPrintOnly,
      'edmsMode': edmsMode,
      'params': params,
    };
  }

  factory ReportDescription.fromMap(Map<String, dynamic> map) {
    return ReportDescription(
      module: map['module'],
      reportName: map['reportName'],
      reportNameDisp: map['reportNameDisp'],
      reportId: map['reportId'],
      reportSingleWindow: map['reportSingleWindow'],
      reportPrintOnly: map['reportPrintOnly'],
      edmsMode: map['edmsMode'],
      params: List<ReportParamDescription>.from(map['params']?.map((x) => ReportParamDescription.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportDescription.fromJson(String source) => ReportDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportDescription(module: $module, reportName: $reportName, reportId: $reportId, reportSingleWindow: $reportSingleWindow, reportPrintOnly: $reportPrintOnly, edmsMode: $edmsMode, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportDescription &&
        other.module == module &&
        other.reportName == reportName &&
        other.reportId == reportId &&
        other.reportSingleWindow == reportSingleWindow &&
        other.reportPrintOnly == reportPrintOnly &&
        other.edmsMode == edmsMode &&
        listEquals(other.params, params);
  }

  @override
  int get hashCode {
    return module.hashCode ^
        reportName.hashCode ^
        reportId.hashCode ^
        reportSingleWindow.hashCode ^
        reportPrintOnly.hashCode ^
        edmsMode.hashCode ^
        params.hashCode;
  }
}
