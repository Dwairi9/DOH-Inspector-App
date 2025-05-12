import 'dart:convert';

import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/mobile_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import 'checklist.dart';

class Inspection {
  final int idNumber;
  final String group;
  final String status;
  final String statusDisp;
  final String type;
  final String typeDisp;
  final String recordId;
  final String customId;
  final String capAlias;
  final String capAliasDisp;
  final String inspSequenceNumber;
  final String activityDate;
  final String statusDate;
  final String requestDate;
  final String scheduledDate;
  final String taskDueDate;
  final String standardCommentGroup;
  final String balance;
  final String capType;
  final String documentDescription;
  final String address;
  final String fullName;
  final String userID;
  final String deptOfUser;
  final String latitude;
  final String longitude;
  final bool isCancelable;
  final bool editable;
  bool selectedForResult = true;
  MobileCard? mobileCard;
  final List<Checklist> checklists;
  List<Attachment> attachments;
  // this property will be used to determine if the inspection is access through record inspections
  // if it is, then you won't be able to view the record inspection from within the inspection itself to avoid infinite cycles
  bool isRecordInspection = false;
  Inspection({
    required this.idNumber,
    required this.group,
    required this.status,
    required this.statusDisp,
    required this.type,
    required this.typeDisp,
    required this.recordId,
    required this.customId,
    required this.inspSequenceNumber,
    required this.activityDate,
    required this.statusDate,
    required this.requestDate,
    required this.scheduledDate,
    required this.taskDueDate,
    required this.standardCommentGroup,
    required this.balance,
    required this.capType,
    required this.capAlias,
    required this.capAliasDisp,
    required this.documentDescription,
    required this.address,
    required this.fullName,
    required this.userID,
    required this.deptOfUser,
    required this.latitude,
    required this.longitude,
    required this.mobileCard,
    required this.checklists,
    required this.attachments,
    required this.isCancelable,
    required this.editable,
    required this.selectedForResult,
  });

  Inspection copyWith(
      {int? idNumber,
      String? group,
      String? status,
      String? statusDisp,
      String? type,
      String? typeDisp,
      String? recordId,
      String? customId,
      String? inspSequenceNumber,
      String? activityDate,
      String? statusDate,
      String? requestDate,
      String? scheduledDate,
      String? taskDueDate,
      String? standardCommentGroup,
      String? balance,
      String? capType,
      String? capAlias,
      String? capAliasDisp,
      String? documentDescription,
      String? address,
      String? fullName,
      String? userID,
      String? deptOfUser,
      String? latitude,
      String? longitude,
      bool? isCancelable,
      bool? editable,
      bool? selectedForResult,
      MobileCard? mobileCard,
      List<Checklist>? checklists,
      List<Attachment>? attachments}) {
    return Inspection(
      idNumber: idNumber ?? this.idNumber,
      group: group ?? this.group,
      status: status ?? this.status,
      statusDisp: statusDisp ?? this.statusDisp,
      type: type ?? this.type,
      typeDisp: typeDisp ?? this.typeDisp,
      recordId: recordId ?? this.recordId,
      customId: customId ?? this.customId,
      inspSequenceNumber: inspSequenceNumber ?? this.inspSequenceNumber,
      activityDate: activityDate ?? this.activityDate,
      statusDate: statusDate ?? this.statusDate,
      requestDate: requestDate ?? this.requestDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      taskDueDate: taskDueDate ?? this.taskDueDate,
      standardCommentGroup: standardCommentGroup ?? this.standardCommentGroup,
      balance: balance ?? this.balance,
      capType: capType ?? this.capType,
      capAlias: capAlias ?? this.capAlias,
      capAliasDisp: capAliasDisp ?? this.capAliasDisp,
      documentDescription: documentDescription ?? this.documentDescription,
      address: address ?? this.address,
      fullName: fullName ?? this.fullName,
      userID: userID ?? this.userID,
      deptOfUser: deptOfUser ?? this.deptOfUser,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mobileCard: mobileCard ?? this.mobileCard,
      checklists: checklists ?? this.checklists,
      attachments: attachments ?? this.attachments,
      isCancelable: isCancelable ?? this.isCancelable,
      editable: editable ?? this.editable,
      selectedForResult: selectedForResult ?? this.selectedForResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNumber': idNumber,
      'group': group,
      'status': status,
      'statusDisp': statusDisp,
      'type': type,
      'typeDisp': typeDisp,
      'recordId': recordId,
      'customId': customId,
      'inspSequenceNumber': inspSequenceNumber,
      'activityDate': activityDate,
      'statusDate': statusDate,
      'requestDate': requestDate,
      'scheduledDate': scheduledDate,
      'taskDueDate': taskDueDate,
      'standardCommentGroup': standardCommentGroup,
      'balance': balance,
      'capType': capType,
      'capAlias': capAlias,
      'capAliasDisp': capAliasDisp,
      'documentDescription': documentDescription,
      'address': address,
      'fullName': fullName,
      'userID': userID,
      'deptOfUser': deptOfUser,
      'latitude': latitude,
      'longitude': longitude,
      'mobileCard': mobileCard,
      'isCancelable': isCancelable,
      'editable': editable,
      'selectedForResult': selectedForResult,
      'checklists': checklists.map((x) => x.toMap()).toList(),
      'attachments': checklists.map((x) => x.toMap()).toList(),
    };
  }

  factory Inspection.fromMap(Map<String, dynamic> map) {
    return Inspection(
      idNumber: map['idNumber']?.toInt() ?? 0,
      group: map['group'] ?? '',
      status: map['status'] ?? '',
      statusDisp: map['statusDisp'] ?? '',
      type: map['type'] ?? '',
      typeDisp: map['typeDisp'] ?? '',
      recordId: map['recordId'] ?? '',
      customId: map['customId'] ?? '',
      inspSequenceNumber: map['inspSequenceNumber'] ?? '',
      activityDate: map['activityDate'] ?? '',
      statusDate: map['statusDate'] ?? '',
      requestDate: map['requestDate'] ?? '',
      scheduledDate: map['scheduledDate'] ?? '',
      taskDueDate: map['taskDueDate'] ?? '',
      standardCommentGroup: map['standardCommentGroup'] ?? '',
      balance: map['balance'] ?? '',
      capType: map['capType'] ?? '',
      capAlias: map['capAlias'] ?? '',
      capAliasDisp: map['capAliasDisp'] ?? '',
      documentDescription: map['documentDescription'] ?? '',
      address: map['address'] ?? '',
      fullName: map['fullName'] ?? '',
      userID: map['userID'] ?? '',
      deptOfUser: map['deptOfUser'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      isCancelable: map['isCancelable'] ?? false,
      editable: map['editable'] ?? false,
      selectedForResult: map['selectedForResult'] ?? true,
      mobileCard: map['mobileCard'] != null ? MobileCard.fromMap(map['mobileCard']) : null,
      checklists: List<Checklist>.from(map['checklists']?.map((x) => Checklist.fromMap(x)) ?? []),
      attachments: List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Inspection.fromJson(String source) => Inspection.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Inspection(idNumber: $idNumber, group: $group, status: $status, type: $type, recordId: $recordId, customId: $customId, inspSequenceNumber: $inspSequenceNumber, activityDate: $activityDate, statusDate: $statusDate, requestDate: $requestDate, scheduledDate: $scheduledDate, taskDueDate: $taskDueDate, standardCommentGroup: $standardCommentGroup, balance: $balance, capType: $capType, documentDescription: $documentDescription, address: $address, fullName: $fullName, userID: $userID, deptOfUser: $deptOfUser, latitude: $latitude, longitude: $longitude, checklists: $checklists)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Inspection &&
        other.idNumber == idNumber &&
        other.group == group &&
        other.status == status &&
        other.type == type &&
        other.recordId == recordId &&
        other.customId == customId &&
        other.inspSequenceNumber == inspSequenceNumber &&
        other.activityDate == activityDate &&
        other.statusDate == statusDate &&
        other.requestDate == requestDate &&
        other.scheduledDate == scheduledDate &&
        other.taskDueDate == taskDueDate &&
        other.standardCommentGroup == standardCommentGroup &&
        other.balance == balance &&
        other.capType == capType &&
        other.documentDescription == documentDescription &&
        other.address == address &&
        other.fullName == fullName &&
        other.userID == userID &&
        other.deptOfUser == deptOfUser &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        listEquals(other.checklists, checklists);
  }

  @override
  int get hashCode {
    return idNumber.hashCode ^
        group.hashCode ^
        status.hashCode ^
        type.hashCode ^
        recordId.hashCode ^
        customId.hashCode ^
        inspSequenceNumber.hashCode ^
        activityDate.hashCode ^
        statusDate.hashCode ^
        requestDate.hashCode ^
        scheduledDate.hashCode ^
        taskDueDate.hashCode ^
        standardCommentGroup.hashCode ^
        balance.hashCode ^
        capType.hashCode ^
        documentDescription.hashCode ^
        address.hashCode ^
        fullName.hashCode ^
        userID.hashCode ^
        deptOfUser.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        checklists.hashCode;
  }

  String getDisplayInspectionType() {
    return typeDisp.isNotEmpty ? typeDisp : type;
  }

  String getDisplayStatus() {
    return statusDisp.isNotEmpty ? statusDisp : status;
  }

  MobileCard getMobileCard() {
    if (mobileCard != null) {
      return mobileCard!;
    }
    MobileCard card = MobileCard.empty();
    card.entries.add(CardEntry(value: getDisplayInspectionType(), label: "Inspection Type".tr()));
    card.entries.add(CardEntry(value: getDisplayStatus(), label: "Status".tr()));
    card.entries.add(CardEntry(value: customId, label: "Custom ID".tr()));
    card.entries.add(CardEntry(value: scheduledDate, type: "date", dateFormat: "yyyy-MM-dd HH:mm:ss", label: "Scheduled Date".tr()));
    if (address.isNotEmpty) {
      card.footerEntries.add(CardEntry(value: address, label: "Address".tr()));
    }

    return card;
  }

  bool areAllChecklistsComplete() {
    for (var i = 0; i < checklists.length; i++) {
      var checklist = checklists[i];
      for (var w = 0; w < checklist.checklistItems.length; w++) {
        if (checklist.checklistItems[w].status.isEmpty) {
          return false;
        }
      }
    }

    return true;
  }
}
