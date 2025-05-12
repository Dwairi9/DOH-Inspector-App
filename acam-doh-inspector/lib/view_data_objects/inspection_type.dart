import 'dart:convert';

class InspectionType {
  final String groupCode;
  final String groupName;
  final String type;
  final String groupCodeDisp;
  final String groupNameDisp;
  final String typeDisp;
  final bool required;
  final String resultGroup;
  final bool editable;
  final bool displayInAca;
  final String sequenceNumber;
  InspectionType({
    required this.groupCode,
    required this.groupName,
    required this.type,
    required this.groupCodeDisp,
    required this.groupNameDisp,
    required this.typeDisp,
    required this.required,
    required this.resultGroup,
    required this.editable,
    required this.displayInAca,
    required this.sequenceNumber,
  });

  InspectionType copyWith({
    String? groupCode,
    String? groupName,
    String? type,
    String? groupCodeDisp,
    String? groupNameDisp,
    String? typeDisp,
    bool? required,
    String? resultGroup,
    bool? editable,
    bool? displayInAca,
    String? sequenceNumber,
  }) {
    return InspectionType(
      groupCode: groupCode ?? this.groupCode,
      groupName: groupName ?? this.groupName,
      type: type ?? this.type,
      groupCodeDisp: groupCodeDisp ?? this.groupCodeDisp,
      groupNameDisp: groupNameDisp ?? this.groupNameDisp,
      typeDisp: typeDisp ?? this.typeDisp,
      required: required ?? this.required,
      resultGroup: resultGroup ?? this.resultGroup,
      editable: editable ?? this.editable,
      displayInAca: displayInAca ?? this.displayInAca,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupCode': groupCode,
      'groupName': groupName,
      'type': type,
      'groupCodeDisp': groupCodeDisp,
      'groupNameDisp': groupNameDisp,
      'typeDisp': typeDisp,
      'required': required,
      'resultGroup': resultGroup,
      'editable': editable,
      'displayInAca': displayInAca,
      'sequenceNumber': sequenceNumber,
    };
  }

  factory InspectionType.fromMap(Map<String, dynamic> map) {
    return InspectionType(
      groupCode: map['groupCode'] ?? '',
      groupName: map['groupName'] ?? '',
      type: map['type'] ?? '',
      groupCodeDisp: map['groupCodeDisp'] ?? '',
      groupNameDisp: map['groupNameDisp'] ?? '',
      typeDisp: map['typeDisp'] ?? '',
      required: map['required'] ?? false,
      resultGroup: map['resultGroup'] ?? '',
      editable: map['editable'] ?? false,
      displayInAca: map['displayInAca'] ?? false,
      sequenceNumber: map['sequenceNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InspectionType.fromJson(String source) => InspectionType.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InspectionType(groupCode: $groupCode, groupName: $groupName, type: $type, groupCodeDisp: $groupCodeDisp, groupNameDisp: $groupNameDisp, typeDisp: $typeDisp, required: $required, resultGroup: $resultGroup, editable: $editable, displayInAca: $displayInAca, sequenceNumber: $sequenceNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspectionType &&
        other.groupCode == groupCode &&
        other.groupName == groupName &&
        other.type == type &&
        other.groupCodeDisp == groupCodeDisp &&
        other.groupNameDisp == groupNameDisp &&
        other.typeDisp == typeDisp &&
        other.required == required &&
        other.resultGroup == resultGroup &&
        other.editable == editable &&
        other.displayInAca == displayInAca &&
        other.sequenceNumber == sequenceNumber;
  }

  @override
  int get hashCode {
    return groupCode.hashCode ^
        groupName.hashCode ^
        type.hashCode ^
        groupCodeDisp.hashCode ^
        groupNameDisp.hashCode ^
        typeDisp.hashCode ^
        required.hashCode ^
        resultGroup.hashCode ^
        editable.hashCode ^
        displayInAca.hashCode ^
        sequenceNumber.hashCode;
  }
}
