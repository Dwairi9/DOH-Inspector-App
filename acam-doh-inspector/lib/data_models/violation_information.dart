class ViolationInformation{
  final String relatedAuditRequestNumber;
  final String category;
  final String violationDate;
  String? violationCapId;
  String? violationCustomId;

  ViolationInformation({
    required this.violationCapId,
    required this.violationCustomId,
    required this.relatedAuditRequestNumber,
    required this.category,
    required this.violationDate
  });

  factory ViolationInformation.fromMap(Map<String, dynamic> map) {
    return ViolationInformation(
        violationCapId: map['violationCapId'],
        violationCustomId: map['violationCustomId'],
        relatedAuditRequestNumber: map['relatedAuditRequestNumber'] ?? '',
        category: map['violationCategory'] ?? '',
        violationDate: map['violationDate'] ?? ''
    );
  }
}

