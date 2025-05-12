import 'dart:convert';

import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:flutter/foundation.dart';

import 'contact_type_description.dart';

class ContactDescription {
  final bool allowMultiple;
  final bool hasContactAddress;
  final List<ContactTypeDescription> contactTypes;
  final List<UnifiedFieldDescription>? searchFormDescription;
  final List<UnifiedFieldDescription>? searchResultTableDescription;
  final List<UnifiedFieldDescription>? selectFromAccountTableDescription;
  final List<UnifiedFieldDescription>? completeFieldList;
  List<UnifiedFieldDescription>? contactListTableDescription;
  List<UnifiedFieldDescription>? contactAddressDescription;
  List<UnifiedFieldDescription>? contactAddressTableDescription;

  ContactDescription({
    required this.allowMultiple,
    required this.contactTypes,
    required this.hasContactAddress,
    this.searchFormDescription,
    this.searchResultTableDescription,
    this.selectFromAccountTableDescription,
    this.completeFieldList,
    this.contactListTableDescription,
    this.contactAddressDescription,
    this.contactAddressTableDescription,
  });

  ContactDescription copyWith({
    required bool allowMultiple,
    required bool hasContactAddress,
    required List<ContactTypeDescription> contactTypes,
    required List<UnifiedFieldDescription> searchFormDescription,
    required List<UnifiedFieldDescription> searchResultTableDescription,
    required List<UnifiedFieldDescription> searchTableDescription,
    required List<UnifiedFieldDescription> completeFieldList,
    List<UnifiedFieldDescription>? contactListTableDescription,
    List<UnifiedFieldDescription>? contactAddressDescription,
    List<UnifiedFieldDescription>? contactAddressTableDescription,
  }) {
    return ContactDescription(
        allowMultiple: allowMultiple,
        hasContactAddress: hasContactAddress,
        contactTypes: contactTypes,
        searchFormDescription: searchFormDescription,
        selectFromAccountTableDescription: searchTableDescription,
        contactListTableDescription: contactListTableDescription,
        completeFieldList: completeFieldList,
        contactAddressDescription: contactAddressDescription,
        contactAddressTableDescription: contactAddressTableDescription,
        searchResultTableDescription: searchResultTableDescription);
  }

  Map<String, dynamic> toMap() {
    return {
      'allowMultiple': allowMultiple,
      'contactTypes': contactTypes.map((x) => x.toMap()).toList(),
    };
  }

  static List<UnifiedFieldDescription> buildCompleteFieldList(
      List<UnifiedFieldDescription> contactListTableDescription, List<ContactTypeDescription> contactTypes) {
    List<UnifiedFieldDescription> completeFieldList = List<UnifiedFieldDescription>.from(contactListTableDescription);

    for (var contactType in contactTypes) {
      for (var contactTypeField in contactType.unifiedFieldsList) {
        if (completeFieldList.where((field) => field.fieldId == contactTypeField.fieldId).isEmpty) {
          completeFieldList.add(contactTypeField);
        }
      }
    }

    return completeFieldList;
  }

  factory ContactDescription.fromMap(Map<String, dynamic> map) {
    bool allowMultipleFlag = map['allowMultiple'] is String ? map['allowMultiple'].toLowerCase() == "true" : map['allowMultiple'];
    bool hasContactAddressFlag = map['description']['hasContactAddress'] is String
        ? map['description']['hasContactAddress'].toLowerCase() == "true"
        : map['description']['hasContactAddress'];
    var contactTypes = List<ContactTypeDescription>.from(map['description']['contactTypes']?.map((x) => ContactTypeDescription.fromMap(x)));
    var searchFormDescription = List<UnifiedFieldDescription>.from(map['description']['searchForm']?.map((x) => UnifiedFieldDescription.fromMap(x)));

    var searchResultTableDescription =
        List<UnifiedFieldDescription>.from(map['description']['searchResultTable']?.map((x) => UnifiedFieldDescription.fromMap(x)));
    var contactListTableDescription = List<UnifiedFieldDescription>.from(map['description']['listTable']?.map((x) => UnifiedFieldDescription.fromMap(x)) ?? []);
    var selectFromAccountTableDescription =
        List<UnifiedFieldDescription>.from(map['description']['searchResultTable']?.map((x) => UnifiedFieldDescription.fromMap(x)));
    var contactAddressDescription = <UnifiedFieldDescription>[];
    var contactAddressTableDescription = <UnifiedFieldDescription>[];

    if (hasContactAddressFlag) {
      contactAddressDescription =
          List<UnifiedFieldDescription>.from(map['description']['contactAddress']?.map((x) => UnifiedFieldDescription.fromMap(x)) ?? []);
      contactAddressTableDescription =
          List<UnifiedFieldDescription>.from(map['description']['contactAddressTable']?.map((x) => UnifiedFieldDescription.fromMap(x)) ?? []);
    }

    List<UnifiedFieldDescription> completeFieldList = buildCompleteFieldList(contactListTableDescription, contactTypes);

    // new List<UnifiedFieldDescription>.from(contactListTableDescription);

    // contactTypes.forEach((contactType) {
    //   contactType.unifiedFieldsList.forEach((contactTypeField) {
    //     if (completeFieldList.where((field) => field.fieldId == contactTypeField.fieldId).isEmpty) {
    //       completeFieldList.add(contactTypeField);
    //     }
    //   });
    // });

    return ContactDescription(
        allowMultiple: allowMultipleFlag,
        hasContactAddress: hasContactAddressFlag,
        contactTypes: contactTypes,
        searchFormDescription: searchFormDescription,
        searchResultTableDescription: searchResultTableDescription,
        contactListTableDescription: contactListTableDescription,
        selectFromAccountTableDescription: selectFromAccountTableDescription,
        contactAddressDescription: contactAddressDescription,
        contactAddressTableDescription: contactAddressTableDescription,
        completeFieldList: completeFieldList);
  }

  String toJson() => json.encode(toMap());

  factory ContactDescription.fromJson(String source) => ContactDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactProfessionalDescription(allowMultiple: $allowMultiple, ContactTypes: $contactTypes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactDescription && other.allowMultiple == allowMultiple && listEquals(other.contactTypes, contactTypes);
  }

  @override
  int get hashCode {
    return allowMultiple.hashCode ^ contactTypes.hashCode;
  }
}
