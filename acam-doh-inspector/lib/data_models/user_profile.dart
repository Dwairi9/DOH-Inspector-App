import 'dart:convert';

class UserProfile {
  final String comment;
  final String fullName;
  final String auditStatus;
  final String title;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String businessName;
  final String auditDate;
  final String auditID;
  final String birthDate;
  final String salutation;
  final String fax;
  final String gender;
  final String maskedSsn;
  final String fein;
  final String faxCountryCode;
  final String serviceProviderCode;
  final String namesuffix;
  final String contactType;
  final String phone1;
  final String phone2;
  final String phone3;
  final String postOfficeBox;
  final String noticeConditions;
  final String phone1CountryCode;
  final String phone2CountryCode;
  final String phone3CountryCode;
  final String socialSecurityNumber;
  final String relation;
  final String preferredChannel;
  final String race;
  final String birthRegion;
  final String tradeName;
  final String deceasedDate;
  final String stateIDNbr;
  final String peopleAKAList;
  final String accountOwner;
  final String businessName2;
  final String birthCity;
  final String birthState;
  final String passportNumber;
  final String driverLicenseState;
  final String driverLicenseNbr;
  final String contractorPeopleStatus;
  final String contactSeqNumber;
  final String displayName;
  final bool needChangePassword;
  UserProfile({
    required this.comment,
    required this.fullName,
    required this.auditStatus,
    required this.title,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.businessName,
    required this.auditDate,
    required this.auditID,
    required this.birthDate,
    required this.salutation,
    required this.fax,
    required this.gender,
    required this.maskedSsn,
    required this.fein,
    required this.faxCountryCode,
    required this.serviceProviderCode,
    required this.namesuffix,
    required this.contactType,
    required this.phone1,
    required this.phone2,
    required this.phone3,
    required this.postOfficeBox,
    required this.noticeConditions,
    required this.phone1CountryCode,
    required this.phone2CountryCode,
    required this.phone3CountryCode,
    required this.socialSecurityNumber,
    required this.relation,
    required this.preferredChannel,
    required this.race,
    required this.birthRegion,
    required this.tradeName,
    required this.deceasedDate,
    required this.stateIDNbr,
    required this.peopleAKAList,
    required this.accountOwner,
    required this.businessName2,
    required this.birthCity,
    required this.birthState,
    required this.passportNumber,
    required this.driverLicenseState,
    required this.driverLicenseNbr,
    required this.contractorPeopleStatus,
    required this.contactSeqNumber,
    required this.displayName,
    required this.needChangePassword,
  });

  UserProfile copyWith({
    String? comment,
    String? fullName,
    String? auditStatus,
    String? title,
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    String? businessName,
    String? auditDate,
    String? auditID,
    String? birthDate,
    String? salutation,
    String? fax,
    String? gender,
    String? maskedSsn,
    String? fein,
    String? faxCountryCode,
    String? serviceProviderCode,
    String? namesuffix,
    String? contactType,
    String? phone1,
    String? phone2,
    String? phone3,
    String? postOfficeBox,
    String? noticeConditions,
    String? phone1CountryCode,
    String? phone2CountryCode,
    String? phone3CountryCode,
    String? socialSecurityNumber,
    String? relation,
    String? preferredChannel,
    String? race,
    String? birthRegion,
    String? tradeName,
    String? deceasedDate,
    String? stateIDNbr,
    String? peopleAKAList,
    String? accountOwner,
    String? businessName2,
    String? birthCity,
    String? birthState,
    String? passportNumber,
    String? driverLicenseState,
    String? driverLicenseNbr,
    String? contractorPeopleStatus,
    String? contactSeqNumber,
    String? displayName,
    bool? needChangePassword,
  }) {
    return UserProfile(
      comment: comment ?? this.comment,
      fullName: fullName ?? this.fullName,
      auditStatus: auditStatus ?? this.auditStatus,
      title: title ?? this.title,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      auditDate: auditDate ?? this.auditDate,
      auditID: auditID ?? this.auditID,
      birthDate: birthDate ?? this.birthDate,
      salutation: salutation ?? this.salutation,
      fax: fax ?? this.fax,
      gender: gender ?? this.gender,
      maskedSsn: maskedSsn ?? this.maskedSsn,
      fein: fein ?? this.fein,
      faxCountryCode: faxCountryCode ?? this.faxCountryCode,
      serviceProviderCode: serviceProviderCode ?? this.serviceProviderCode,
      namesuffix: namesuffix ?? this.namesuffix,
      contactType: contactType ?? this.contactType,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      phone3: phone3 ?? this.phone3,
      postOfficeBox: postOfficeBox ?? this.postOfficeBox,
      noticeConditions: noticeConditions ?? this.noticeConditions,
      phone1CountryCode: phone1CountryCode ?? this.phone1CountryCode,
      phone2CountryCode: phone2CountryCode ?? this.phone2CountryCode,
      phone3CountryCode: phone3CountryCode ?? this.phone3CountryCode,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      relation: relation ?? this.relation,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      race: race ?? this.race,
      birthRegion: birthRegion ?? this.birthRegion,
      tradeName: tradeName ?? this.tradeName,
      deceasedDate: deceasedDate ?? this.deceasedDate,
      stateIDNbr: stateIDNbr ?? this.stateIDNbr,
      peopleAKAList: peopleAKAList ?? this.peopleAKAList,
      accountOwner: accountOwner ?? this.accountOwner,
      businessName2: businessName2 ?? this.businessName2,
      birthCity: birthCity ?? this.birthCity,
      birthState: birthState ?? this.birthState,
      passportNumber: passportNumber ?? this.passportNumber,
      driverLicenseState: driverLicenseState ?? this.driverLicenseState,
      driverLicenseNbr: driverLicenseNbr ?? this.driverLicenseNbr,
      contractorPeopleStatus: contractorPeopleStatus ?? this.contractorPeopleStatus,
      contactSeqNumber: contactSeqNumber ?? this.contactSeqNumber,
      displayName: displayName ?? this.displayName,
      needChangePassword: needChangePassword ?? this.needChangePassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'fullName': fullName,
      'auditStatus': auditStatus,
      'title': title,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'businessName': businessName,
      'auditDate': auditDate,
      'auditID': auditID,
      'birthDate': birthDate,
      'salutation': salutation,
      'fax': fax,
      'gender': gender,
      'maskedSsn': maskedSsn,
      'fein': fein,
      'faxCountryCode': faxCountryCode,
      'serviceProviderCode': serviceProviderCode,
      'namesuffix': namesuffix,
      'contactType': contactType,
      'phone1': phone1,
      'phone2': phone2,
      'phone3': phone3,
      'postOfficeBox': postOfficeBox,
      'noticeConditions': noticeConditions,
      'phone1CountryCode': phone1CountryCode,
      'phone2CountryCode': phone2CountryCode,
      'phone3CountryCode': phone3CountryCode,
      'socialSecurityNumber': socialSecurityNumber,
      'relation': relation,
      'preferredChannel': preferredChannel,
      'race': race,
      'birthRegion': birthRegion,
      'tradeName': tradeName,
      'deceasedDate': deceasedDate,
      'stateIDNbr': stateIDNbr,
      'peopleAKAList': peopleAKAList,
      'accountOwner': accountOwner,
      'businessName2': businessName2,
      'birthCity': birthCity,
      'birthState': birthState,
      'passportNumber': passportNumber,
      'driverLicenseState': driverLicenseState,
      'driverLicenseNbr': driverLicenseNbr,
      'contractorPeopleStatus': contractorPeopleStatus,
      'contactSeqNumber': contactSeqNumber,
      'displayName': displayName,
      'needChangePassword': needChangePassword,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      comment: map['comment'] ?? '',
      fullName: map['fullName'] ?? '',
      auditStatus: map['auditStatus'] ?? '',
      title: map['title'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      businessName: map['businessName'] ?? '',
      auditDate: map['auditDate'] ?? '',
      auditID: map['auditID'] ?? '',
      birthDate: map['birthDate'] ?? '',
      salutation: map['salutation'] ?? '',
      fax: map['fax'] ?? '',
      gender: map['gender'] ?? '',
      maskedSsn: map['maskedSsn'] ?? '',
      fein: map['fein'] ?? '',
      faxCountryCode: map['faxCountryCode'] ?? '',
      serviceProviderCode: map['serviceProviderCode'] ?? '',
      namesuffix: map['namesuffix'] ?? '',
      contactType: map['contactType'] ?? '',
      phone1: map['phone1'] ?? '',
      phone2: map['phone2'] ?? '',
      phone3: map['phone3'] ?? '',
      postOfficeBox: map['postOfficeBox'] ?? '',
      noticeConditions: map['noticeConditions'] ?? '',
      phone1CountryCode: map['phone1CountryCode'] ?? '',
      phone2CountryCode: map['phone2CountryCode'] ?? '',
      phone3CountryCode: map['phone3CountryCode'] ?? '',
      socialSecurityNumber: map['socialSecurityNumber'] ?? '',
      relation: map['relation'] ?? '',
      preferredChannel: map['preferredChannel'] ?? '',
      race: map['race'] ?? '',
      birthRegion: map['birthRegion'] ?? '',
      tradeName: map['tradeName'] ?? '',
      deceasedDate: map['deceasedDate'] ?? '',
      stateIDNbr: map['stateIDNbr'] ?? '',
      peopleAKAList: map['peopleAKAList'] ?? '',
      accountOwner: map['accountOwner'] ?? '',
      businessName2: map['businessName2'] ?? '',
      birthCity: map['birthCity'] ?? '',
      birthState: map['birthState'] ?? '',
      passportNumber: map['passportNumber'] ?? '',
      driverLicenseState: map['driverLicenseState'] ?? '',
      driverLicenseNbr: map['driverLicenseNbr'] ?? '',
      contractorPeopleStatus: map['contractorPeopleStatus'] ?? '',
      contactSeqNumber: map['contactSeqNumber'] ?? '',
      displayName: map['displayName'] ?? '',
      needChangePassword: map['needChangePassword'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(comment: $comment, fullName: $fullName, auditStatus: $auditStatus, title: $title, email: $email, firstName: $firstName, middleName: $middleName, lastName: $lastName, businessName: $businessName, auditDate: $auditDate, auditID: $auditID, birthDate: $birthDate, salutation: $salutation, fax: $fax, gender: $gender, maskedSsn: $maskedSsn, fein: $fein, faxCountryCode: $faxCountryCode, serviceProviderCode: $serviceProviderCode, namesuffix: $namesuffix, contactType: $contactType, phone1: $phone1, phone2: $phone2, phone3: $phone3, postOfficeBox: $postOfficeBox, noticeConditions: $noticeConditions, phone1CountryCode: $phone1CountryCode, phone2CountryCode: $phone2CountryCode, phone3CountryCode: $phone3CountryCode, socialSecurityNumber: $socialSecurityNumber, relation: $relation, preferredChannel: $preferredChannel, race: $race, birthRegion: $birthRegion, tradeName: $tradeName, deceasedDate: $deceasedDate, stateIDNbr: $stateIDNbr, peopleAKAList: $peopleAKAList, accountOwner: $accountOwner, businessName2: $businessName2, birthCity: $birthCity, birthState: $birthState, passportNumber: $passportNumber, driverLicenseState: $driverLicenseState, driverLicenseNbr: $driverLicenseNbr, contractorPeopleStatus: $contractorPeopleStatus, contactSeqNumber: $contactSeqNumber, displayName: $displayName, needChangePassword: $needChangePassword)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.comment == comment &&
        other.fullName == fullName &&
        other.auditStatus == auditStatus &&
        other.title == title &&
        other.email == email &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.businessName == businessName &&
        other.auditDate == auditDate &&
        other.auditID == auditID &&
        other.birthDate == birthDate &&
        other.salutation == salutation &&
        other.fax == fax &&
        other.gender == gender &&
        other.maskedSsn == maskedSsn &&
        other.fein == fein &&
        other.faxCountryCode == faxCountryCode &&
        other.serviceProviderCode == serviceProviderCode &&
        other.namesuffix == namesuffix &&
        other.contactType == contactType &&
        other.phone1 == phone1 &&
        other.phone2 == phone2 &&
        other.phone3 == phone3 &&
        other.postOfficeBox == postOfficeBox &&
        other.noticeConditions == noticeConditions &&
        other.phone1CountryCode == phone1CountryCode &&
        other.phone2CountryCode == phone2CountryCode &&
        other.phone3CountryCode == phone3CountryCode &&
        other.socialSecurityNumber == socialSecurityNumber &&
        other.relation == relation &&
        other.preferredChannel == preferredChannel &&
        other.race == race &&
        other.birthRegion == birthRegion &&
        other.tradeName == tradeName &&
        other.deceasedDate == deceasedDate &&
        other.stateIDNbr == stateIDNbr &&
        other.peopleAKAList == peopleAKAList &&
        other.accountOwner == accountOwner &&
        other.businessName2 == businessName2 &&
        other.birthCity == birthCity &&
        other.birthState == birthState &&
        other.passportNumber == passportNumber &&
        other.driverLicenseState == driverLicenseState &&
        other.driverLicenseNbr == driverLicenseNbr &&
        other.contractorPeopleStatus == contractorPeopleStatus &&
        other.contactSeqNumber == contactSeqNumber &&
        other.displayName == displayName &&
        other.needChangePassword == needChangePassword;
  }

  @override
  int get hashCode {
    return comment.hashCode ^
        fullName.hashCode ^
        auditStatus.hashCode ^
        title.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        businessName.hashCode ^
        auditDate.hashCode ^
        auditID.hashCode ^
        birthDate.hashCode ^
        salutation.hashCode ^
        fax.hashCode ^
        gender.hashCode ^
        maskedSsn.hashCode ^
        fein.hashCode ^
        faxCountryCode.hashCode ^
        serviceProviderCode.hashCode ^
        namesuffix.hashCode ^
        contactType.hashCode ^
        phone1.hashCode ^
        phone2.hashCode ^
        phone3.hashCode ^
        postOfficeBox.hashCode ^
        noticeConditions.hashCode ^
        phone1CountryCode.hashCode ^
        phone2CountryCode.hashCode ^
        phone3CountryCode.hashCode ^
        socialSecurityNumber.hashCode ^
        relation.hashCode ^
        preferredChannel.hashCode ^
        race.hashCode ^
        birthRegion.hashCode ^
        tradeName.hashCode ^
        deceasedDate.hashCode ^
        stateIDNbr.hashCode ^
        peopleAKAList.hashCode ^
        accountOwner.hashCode ^
        businessName2.hashCode ^
        birthCity.hashCode ^
        birthState.hashCode ^
        passportNumber.hashCode ^
        driverLicenseState.hashCode ^
        driverLicenseNbr.hashCode ^
        contractorPeopleStatus.hashCode ^
        contactSeqNumber.hashCode ^
        displayName.hashCode ^
        needChangePassword.hashCode;
  }
}
