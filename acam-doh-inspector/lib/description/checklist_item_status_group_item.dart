import 'dart:convert';

class ChecklistItemStatusGroupItem {
  final int displayOrder;
  final String criticalScore;
  final String nonCriticalScore;
  final String guideSheetItemStatusDisp;
  final String guideSheetItemStatus;
  final String langId;
  final bool majorViolation;
  final String resultType;
  final String statusGroup;
  final String resId;
  ChecklistItemStatusGroupItem({
    required this.displayOrder,
    required this.criticalScore,
    required this.nonCriticalScore,
    required this.guideSheetItemStatusDisp,
    required this.guideSheetItemStatus,
    required this.langId,
    required this.majorViolation,
    required this.resultType,
    required this.statusGroup,
    required this.resId,
  });

  ChecklistItemStatusGroupItem copyWith({
    int? displayOrder,
    String? criticalScore,
    String? nonCriticalScore,
    String? guideSheetItemStatusDisp,
    String? guideSheetItemStatus,
    String? langId,
    bool? majorViolation,
    String? resultType,
    String? statusGroup,
    String? resId,
  }) {
    return ChecklistItemStatusGroupItem(
      displayOrder: displayOrder ?? this.displayOrder,
      criticalScore: criticalScore ?? this.criticalScore,
      nonCriticalScore: nonCriticalScore ?? this.nonCriticalScore,
      guideSheetItemStatusDisp: guideSheetItemStatusDisp ?? this.guideSheetItemStatusDisp,
      guideSheetItemStatus: guideSheetItemStatus ?? this.guideSheetItemStatus,
      langId: langId ?? this.langId,
      majorViolation: majorViolation ?? this.majorViolation,
      resultType: resultType ?? this.resultType,
      statusGroup: statusGroup ?? this.statusGroup,
      resId: resId ?? this.resId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayOrder': displayOrder,
      'criticalScore': criticalScore,
      'nonCriticalScore': nonCriticalScore,
      'guideSheetItemStatusDisp': guideSheetItemStatusDisp,
      'guideSheetItemStatus': guideSheetItemStatus,
      'langId': langId,
      'majorViolation': majorViolation,
      'resultType': resultType,
      'statusGroup': statusGroup,
      'resId': resId,
    };
  }

  factory ChecklistItemStatusGroupItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItemStatusGroupItem(
      displayOrder: map['displayOrder']?.toInt() ?? 0,
      criticalScore: map['criticalScore'] ?? '',
      nonCriticalScore: map['nonCriticalScore'] ?? '',
      guideSheetItemStatusDisp: map['guideSheetItemStatusDisp'] ?? '',
      guideSheetItemStatus: map['guideSheetItemStatus'] ?? '',
      langId: map['langId'] ?? '',
      majorViolation: map['majorViolation'] ?? false,
      resultType: map['resultType'] ?? '',
      statusGroup: map['statusGroup'] ?? '',
      resId: map['resId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistItemStatusGroupItem.fromJson(String source) => ChecklistItemStatusGroupItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChecklistItemStatusGroupItem(displayOrder: $displayOrder, criticalScore: $criticalScore, nonCriticalScore: $nonCriticalScore, guideSheetItemStatusDisp: $guideSheetItemStatusDisp, guideSheetItemStatus: $guideSheetItemStatus, langId: $langId, majorViolation: $majorViolation, resultType: $resultType, statusGroup: $statusGroup, resId: $resId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChecklistItemStatusGroupItem &&
        other.displayOrder == displayOrder &&
        other.criticalScore == criticalScore &&
        other.nonCriticalScore == nonCriticalScore &&
        other.guideSheetItemStatusDisp == guideSheetItemStatusDisp &&
        other.guideSheetItemStatus == guideSheetItemStatus &&
        other.langId == langId &&
        other.majorViolation == majorViolation &&
        other.resultType == resultType &&
        other.statusGroup == statusGroup &&
        other.resId == resId;
  }

  @override
  int get hashCode {
    return displayOrder.hashCode ^
        criticalScore.hashCode ^
        nonCriticalScore.hashCode ^
        guideSheetItemStatusDisp.hashCode ^
        guideSheetItemStatus.hashCode ^
        langId.hashCode ^
        majorViolation.hashCode ^
        resultType.hashCode ^
        statusGroup.hashCode ^
        resId.hashCode;
  }
}
