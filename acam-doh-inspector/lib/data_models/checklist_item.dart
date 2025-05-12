import 'dart:convert';

import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/utils/accela_json_parsing.dart';
import 'package:aca_mobile_app/view_providers/checklist_item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChecklistItem {
  final String idNumber;
  final String checklistId;
  final String entityType;
  String status;
  String previousStatus;
  String statusEdit;
  final String statusGroupName;
  final bool isStatusVisible;
  final String text;
  final String guidelines;
  final bool isTextVisible;
  final String type;
  final bool isCritical;
  bool guidelinesExpanded;
  final bool isRequired;
  final String displayOrder;
  final String asiGroup;
  final bool isAsiVisible;
  final String asitGroup;
  final bool isAsitVisible;
  final int maxPoints;
  int score;
  int scoreEdit;
  String scoreError;
  String comment;
  String commentEdit;
  final bool isCommentVisible;
  final bool isScoreVisible;
  final bool isMaxPointsVisible;
  final String textDisp;
  final Map<String, Map<String, Object?>> asiValues;
  final Map<String, List<Map<String, Object?>>> asitValues;
  List<Attachment> attachments;
  ChangeNotifierProvider<ChecklistItemProvider>? provider;

  ChangeNotifierProvider<ChecklistItemProvider> getChecklistItemProvder() {
    provider ??= ChangeNotifierProvider((ref) => ChecklistItemProvider(this));
    return provider!;
  }

  ChecklistItem({
    required this.idNumber,
    required this.checklistId,
    required this.entityType,
    required this.status,
    required this.previousStatus,
    required this.statusEdit,
    required this.statusGroupName,
    required this.isStatusVisible,
    required this.text,
    required this.guidelines,
    required this.isTextVisible,
    required this.type,
    required this.isCritical,
    required this.guidelinesExpanded,
    required this.isRequired,
    required this.displayOrder,
    required this.asiGroup,
    required this.isAsiVisible,
    required this.asitGroup,
    required this.isAsitVisible,
    required this.maxPoints,
    required this.score,
    required this.scoreEdit,
    required this.scoreError,
    required this.comment,
    required this.commentEdit,
    required this.isCommentVisible,
    required this.isScoreVisible,
    required this.isMaxPointsVisible,
    required this.textDisp,
    required this.asiValues,
    required this.asitValues,
    required this.attachments,
  });

  ChecklistItem copyWith(
      {String? idNumber,
      String? checklistId,
      String? entityType,
      String? status,
      String? previousStatus,
      String? statusEdit,
      String? statusGroupName,
      bool? isStatusVisible,
      String? text,
      String? guidelines,
      bool? isTextVisible,
      String? type,
      bool? isCritical,
      bool? guidelinesExpanded,
      bool? isRequired,
      String? displayOrder,
      String? asiGroup,
      bool? isAsiVisible,
      String? asitGroup,
      bool? isAsitVisible,
      int? maxPoints,
      int? score,
      int? scoreEdit,
      String? scoreError,
      String? comment,
      String? commentEdit,
      bool? isCommentVisible,
      bool? isScoreVisible,
      bool? isMaxPointsVisible,
      String? textDisp,
      Map<String, Map<String, Object?>>? asiValues,
      Map<String, List<Map<String, Object?>>>? asitValues,
      List<Attachment>? attachments}) {
    return ChecklistItem(
      idNumber: idNumber ?? this.idNumber,
      checklistId: checklistId ?? this.checklistId,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      previousStatus: previousStatus ?? this.previousStatus,
      statusEdit: statusEdit ?? this.statusEdit,
      statusGroupName: statusGroupName ?? this.statusGroupName,
      isStatusVisible: isStatusVisible ?? this.isStatusVisible,
      text: text ?? this.text,
      guidelines: guidelines ?? this.guidelines,
      isTextVisible: isTextVisible ?? this.isTextVisible,
      type: type ?? this.type,
      isCritical: isCritical ?? this.isCritical,
      guidelinesExpanded: guidelinesExpanded ?? this.guidelinesExpanded,
      isRequired: isRequired ?? this.isRequired,
      displayOrder: displayOrder ?? this.displayOrder,
      asiGroup: asiGroup ?? this.asiGroup,
      isAsiVisible: isAsiVisible ?? this.isAsiVisible,
      asitGroup: asitGroup ?? this.asitGroup,
      isAsitVisible: isAsitVisible ?? this.isAsitVisible,
      maxPoints: maxPoints ?? this.maxPoints,
      score: score ?? this.score,
      scoreEdit: scoreEdit ?? this.scoreEdit,
      scoreError: scoreError ?? this.scoreError,
      comment: comment ?? this.comment,
      commentEdit: commentEdit ?? this.commentEdit,
      isCommentVisible: isCommentVisible ?? this.isCommentVisible,
      isScoreVisible: isScoreVisible ?? this.isScoreVisible,
      isMaxPointsVisible: isMaxPointsVisible ?? this.isMaxPointsVisible,
      textDisp: textDisp ?? this.textDisp,
      asiValues: asiValues ?? this.asiValues,
      asitValues: asitValues ?? this.asitValues,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNumber': idNumber,
      'checklistId': checklistId,
      'entityType': entityType,
      'status': status,
      'statusEdit': statusEdit,
      'statusGroupName': statusGroupName,
      'isStatusVisible': isStatusVisible,
      'text': text,
      'guidelines': guidelines,
      'isTextVisible': isTextVisible,
      'type': type,
      'isCritical': isCritical,
      'guidelinesExpanded': guidelinesExpanded,
      'isRequired': isRequired,
      'displayOrder': displayOrder,
      'asiGroup': asiGroup,
      'isAsiVisible': isAsiVisible,
      'asitGroup': asitGroup,
      'isAsitVisible': isAsitVisible,
      'maxPoints': maxPoints,
      'score': score,
      'scoreEdit': scoreEdit,
      'scoreError': scoreError,
      'comment': comment,
      'commentEdit': commentEdit,
      'isCommentVisible': isCommentVisible,
      'isScoreVisible': isScoreVisible,
      'isMaxPointsVisible': isMaxPointsVisible,
      'textDisp': textDisp,
      'asiValues': asiValues,
      'asitValues': asitValues,
      'attachments': attachments.map((x) => x.toMap()).toList(),
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      idNumber: map['idNumber'],
      checklistId: map['checklistId'],
      entityType: map['entityType'] ?? '',
      status: map['status'] ?? '',
      previousStatus: map['previousStatus'] ?? '',
      statusEdit: map['statusEdit'] ?? '',
      statusGroupName: map['statusGroupName'] ?? '',
      isStatusVisible: map['isStatusVisible'] ?? false,
      text: map['text'] ?? '',
      guidelines: map['guidelines'] ?? '',
      isTextVisible: map['isTextVisible'] ?? false,
      type: map['type'] ?? '',
      isCritical: map['isCritical'] ?? false,
      guidelinesExpanded: map['guidelinesExpanded'] ?? false,
      isRequired: map['isRequired'] ?? false,
      displayOrder: map['displayOrder'] ?? '',
      asiGroup: map['asiGroup'] ?? '',
      isAsiVisible: map['isAsiVisible'] ?? false,
      asitGroup: map['asitGroup'] ?? '',
      isAsitVisible: map['isAsitVisible'] ?? false,
      maxPoints: map['maxPoints']?.toInt() ?? -1,
      score: map['score']?.toInt() ?? 0,
      scoreEdit: map['scoreEdit']?.toInt() ?? -1,
      scoreError: map['scoreError'] ?? '',
      comment: map['comment'] ?? '',
      commentEdit: map['commentEdit'] ?? '',
      isCommentVisible: map['isCommentVisible'] ?? false,
      isScoreVisible: map['isScoreVisible'] ?? false,
      isMaxPointsVisible: map['isMaxPointsVisible'] ?? false,
      textDisp: map['textDisp'] ?? '',
      asiValues: AccelaJsonParsing.parseAsiValues(map['asiValues']) ?? {},
      asitValues: AccelaJsonParsing.parseAsitValues(map['asitValues']) ?? {},
      attachments: List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistItem.fromJson(String source) => ChecklistItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChecklistItem(idNumber: $idNumber, checklistId: $checklistId, entityType: $entityType, status: $status, statusGroupName: $statusGroupName, isStatusVisible: $isStatusVisible, text: $text, isTextVisible: $isTextVisible, type: $type, isCritical: $isCritical, isRequired: $isRequired, displayOrder: $displayOrder, asiGroup: $asiGroup, isAsiVisible: $isAsiVisible, asitGroup: $asitGroup, isAsitVisible: $isAsitVisible, maxPoints: $maxPoints, score: $score, comment: $comment, isCommentVisible: $isCommentVisible, isScoreVisible: $isScoreVisible, isMaxPointsVisible: $isMaxPointsVisible, textDisp: $textDisp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChecklistItem &&
        other.idNumber == idNumber &&
        other.checklistId == checklistId &&
        other.entityType == entityType &&
        other.status == status &&
        other.statusGroupName == statusGroupName &&
        other.isStatusVisible == isStatusVisible &&
        other.text == text &&
        other.isTextVisible == isTextVisible &&
        other.type == type &&
        other.isCritical == isCritical &&
        other.isRequired == isRequired &&
        other.displayOrder == displayOrder &&
        other.asiGroup == asiGroup &&
        other.isAsiVisible == isAsiVisible &&
        other.asitGroup == asitGroup &&
        other.isAsitVisible == isAsitVisible &&
        other.maxPoints == maxPoints &&
        other.score == score &&
        other.comment == comment &&
        other.isCommentVisible == isCommentVisible &&
        other.isScoreVisible == isScoreVisible &&
        other.isMaxPointsVisible == isMaxPointsVisible &&
        other.textDisp == textDisp;
  }

  @override
  int get hashCode {
    return idNumber.hashCode ^
        checklistId.hashCode ^
        entityType.hashCode ^
        status.hashCode ^
        statusGroupName.hashCode ^
        isStatusVisible.hashCode ^
        text.hashCode ^
        isTextVisible.hashCode ^
        type.hashCode ^
        isCritical.hashCode ^
        isRequired.hashCode ^
        displayOrder.hashCode ^
        asiGroup.hashCode ^
        isAsiVisible.hashCode ^
        asitGroup.hashCode ^
        isAsitVisible.hashCode ^
        maxPoints.hashCode ^
        score.hashCode ^
        comment.hashCode ^
        isCommentVisible.hashCode ^
        isScoreVisible.hashCode ^
        isMaxPointsVisible.hashCode ^
        textDisp.hashCode;
  }

  double getStatusInt() {
    return double.tryParse(status) ?? 0;
  }
}
