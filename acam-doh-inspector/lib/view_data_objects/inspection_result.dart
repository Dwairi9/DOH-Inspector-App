import 'dart:convert';

class VisitInspectionResult {
  final String customId;
  final String idNumber;
  final String status;
  final String comment;
  final String userType;
  VisitInspectionResult({
    required this.customId,
    required this.idNumber,
    required this.status,
    required this.comment,
    required this.userType,
  });

  VisitInspectionResult copyWith({
    String? customId,
    String? idNumber,
    String? status,
    String? comment,
    String? userType,
  }) {
    return VisitInspectionResult(
      customId: customId ?? this.customId,
      idNumber: idNumber ?? this.idNumber,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customId': customId,
      'idNumber': idNumber,
      'status': status,
      'comment': comment,
      'userType': userType,
    };
  }

  factory VisitInspectionResult.fromMap(Map<String, dynamic> map) {
    return VisitInspectionResult(
      customId: map['customId'] ?? '',
      idNumber: map['idNumber'] ?? '',
      status: map['status'] ?? '',
      comment: map['comment'] ?? '',
      userType: map['userType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitInspectionResult.fromJson(String source) => VisitInspectionResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InspectionResult(customId: $customId, idNumber: $idNumber, status: $status, comment: $comment, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VisitInspectionResult &&
        other.customId == customId &&
        other.idNumber == idNumber &&
        other.status == status &&
        other.comment == comment &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return customId.hashCode ^ idNumber.hashCode ^ status.hashCode ^ comment.hashCode ^ userType.hashCode;
  }
}
