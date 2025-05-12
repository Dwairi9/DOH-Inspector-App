import 'dart:convert';

class ReportParamDescription {
  final int parameterOrder;
  final int parameterId;
  final int reportId;
  final int viewID;
  final String defaultValue;
  final String parameterName;
  final String parameterRequired;
  final String parameterSource;
  final String parameterType;
  final String parameterVisible;
  ReportParamDescription({
    required this.parameterOrder,
    required this.parameterId,
    required this.reportId,
    required this.viewID,
    required this.defaultValue,
    required this.parameterName,
    required this.parameterRequired,
    required this.parameterSource,
    required this.parameterType,
    required this.parameterVisible,
  });

  ReportParamDescription copyWith({
    int? parameterOrder,
    int? parameterId,
    int? reportId,
    int? viewID,
    String? defaultValue,
    String? parameterName,
    String? parameterRequired,
    String? parameterSource,
    String? parameterType,
    String? parameterVisible,
  }) {
    return ReportParamDescription(
      parameterOrder: parameterOrder ?? this.parameterOrder,
      parameterId: parameterId ?? this.parameterId,
      reportId: reportId ?? this.reportId,
      viewID: viewID ?? this.viewID,
      defaultValue: defaultValue ?? this.defaultValue,
      parameterName: parameterName ?? this.parameterName,
      parameterRequired: parameterRequired ?? this.parameterRequired,
      parameterSource: parameterSource ?? this.parameterSource,
      parameterType: parameterType ?? this.parameterType,
      parameterVisible: parameterVisible ?? this.parameterVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parameterOrder': parameterOrder,
      'parameterId': parameterId,
      'reportId': reportId,
      'viewID': viewID,
      'defaultValue': defaultValue,
      'parameterName': parameterName,
      'parameterRequired': parameterRequired,
      'parameterSource': parameterSource,
      'parameterType': parameterType,
      'parameterVisible': parameterVisible,
    };
  }

  factory ReportParamDescription.fromMap(Map<String, dynamic> map) {
    return ReportParamDescription(
      parameterOrder: map['parameterOrder']?.toInt() ?? 0,
      parameterId: map['parameterId']?.toInt() ?? 0,
      reportId: map['reportId']?.toInt() ?? 0,
      viewID: map['viewID']?.toInt() ?? 0,
      defaultValue: map['defaultValue'] ?? '',
      parameterName: map['parameterName'] ?? '',
      parameterRequired: map['parameterRequired'] ?? '',
      parameterSource: map['parameterSource'] ?? '',
      parameterType: map['parameterType'] ?? '',
      parameterVisible: map['parameterVisible'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportParamDescription.fromJson(String source) => ReportParamDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportParamDescription(parameterOrder: $parameterOrder, parameterId: $parameterId, reportId: $reportId, viewID: $viewID, defaultValue: $defaultValue, parameterName: $parameterName, parameterRequired: $parameterRequired, parameterSource: $parameterSource, parameterType: $parameterType, parameterVisible: $parameterVisible)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportParamDescription &&
        other.parameterOrder == parameterOrder &&
        other.parameterId == parameterId &&
        other.reportId == reportId &&
        other.viewID == viewID &&
        other.defaultValue == defaultValue &&
        other.parameterName == parameterName &&
        other.parameterRequired == parameterRequired &&
        other.parameterSource == parameterSource &&
        other.parameterType == parameterType &&
        other.parameterVisible == parameterVisible;
  }

  @override
  int get hashCode {
    return parameterOrder.hashCode ^
        parameterId.hashCode ^
        reportId.hashCode ^
        viewID.hashCode ^
        defaultValue.hashCode ^
        parameterName.hashCode ^
        parameterRequired.hashCode ^
        parameterSource.hashCode ^
        parameterType.hashCode ^
        parameterVisible.hashCode;
  }
}
