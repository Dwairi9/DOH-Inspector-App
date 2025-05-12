import 'dart:convert';

class Attachment {
  final String uploadDate;
  final int size;
  final String documentNo;
  final String category;
  final String categoryDisp;
  final String description;
  final String group;
  final String docName;
  final String status;
  final String fileType;
  final String entityID;
  final String entityType;
  final String fileUpLoadBy;
  final String fileName;
  final String checklistItemText;
  final String checklistItemTextDisp;
  final Map<String, dynamic> asiValues;
  Attachment({
    required this.uploadDate,
    required this.size,
    required this.documentNo,
    required this.category,
    required this.categoryDisp,
    required this.description,
    required this.group,
    required this.docName,
    required this.status,
    required this.fileType,
    required this.entityID,
    required this.entityType,
    required this.fileUpLoadBy,
    required this.fileName,
    required this.checklistItemText,
    required this.checklistItemTextDisp,
    required this.asiValues,
  });

  Attachment copyWith({
    String? uploadDate,
    int? size,
    String? documentNo,
    String? category,
    String? categoryDisp,
    String? description,
    String? group,
    String? docName,
    String? status,
    String? fileType,
    String? entityID,
    String? entityType,
    String? fileUpLoadBy,
    String? fileName,
    String? checklistItemText,
    String? checklistItemTextDisp,
    Map<String, dynamic>? asiValues,
  }) {
    return Attachment(
      uploadDate: uploadDate ?? this.uploadDate,
      size: size ?? this.size,
      documentNo: documentNo ?? this.documentNo,
      category: category ?? this.category,
      categoryDisp: categoryDisp ?? this.categoryDisp,
      description: description ?? this.description,
      group: group ?? this.group,
      docName: docName ?? this.docName,
      status: status ?? this.status,
      fileType: fileType ?? this.fileType,
      entityID: entityID ?? this.entityID,
      entityType: entityType ?? this.entityType,
      fileUpLoadBy: fileUpLoadBy ?? this.fileUpLoadBy,
      fileName: fileName ?? this.fileName,
      checklistItemText: checklistItemText ?? this.checklistItemText,
      checklistItemTextDisp: checklistItemTextDisp ?? this.checklistItemTextDisp,
      asiValues: asiValues ?? this.asiValues,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uploadDate': uploadDate,
      'size': size,
      'documentNo': documentNo,
      'category': category,
      'categoryDisp': categoryDisp,
      'description': description,
      'group': group,
      'docName': docName,
      'status': status,
      'fileType': fileType,
      'entityID': entityID,
      'entityType': entityType,
      'fileUpLoadBy': fileUpLoadBy,
      'fileName': fileName,
      'checklistItemText': checklistItemText,
      'checklistItemTextDisp': checklistItemTextDisp,
      'asiValues': asiValues,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      uploadDate: map['uploadDate'] ?? "",
      size: map['size']?.toInt() ?? 0,
      documentNo: map['documentNo'] ?? "",
      category: map['category'] ?? "",
      categoryDisp: map['categoryDisp'] ?? "",
      description: map['description'] ?? "",
      group: map['group'] ?? "",
      docName: map['docName'] ?? "",
      status: map['status'] ?? "",
      fileType: map['fileType'] ?? "",
      entityID: map['entityID'] ?? "",
      entityType: map['entityType'] ?? "",
      fileUpLoadBy: map['fileUpLoadBy'] ?? "",
      fileName: map['fileName'] ?? "",
      checklistItemText: map['checklistItemText'] ?? "",
      checklistItemTextDisp: map['checklistItemTextDisp'] ?? "",
      asiValues: map['asiValues'] ?? {},
    );
  }

  String toJson() => json.encode(toMap());

  factory Attachment.fromJson(String source) => Attachment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Attachment(uploadDate: $uploadDate, size: $size, documentNo: $documentNo, category: $category, description: $description, group: $group, docName: $docName, status: $status, fileType: $fileType, entityID: $entityID, entityType: $entityType, fileUpLoadBy: $fileUpLoadBy, fileName: $fileName, asiValues: $asiValues)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attachment &&
        other.uploadDate == uploadDate &&
        other.size == size &&
        other.documentNo == documentNo &&
        other.category == category &&
        other.description == description &&
        other.group == group &&
        other.docName == docName &&
        other.status == status &&
        other.fileType == fileType &&
        other.entityID == entityID &&
        other.entityType == entityType &&
        other.fileUpLoadBy == fileUpLoadBy &&
        other.fileName == fileName &&
        other.asiValues == asiValues;
  }

  @override
  int get hashCode {
    return uploadDate.hashCode ^
        size.hashCode ^
        documentNo.hashCode ^
        category.hashCode ^
        description.hashCode ^
        group.hashCode ^
        docName.hashCode ^
        status.hashCode ^
        fileType.hashCode ^
        entityID.hashCode ^
        entityType.hashCode ^
        fileUpLoadBy.hashCode ^
        fileName.hashCode ^
        asiValues.hashCode;
  }
}
