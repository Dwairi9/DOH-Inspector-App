class FacilityInformation{
  final String facilityLicenseNumber;
  final String facilityNameInEnglish;
  final String facilityNameInArabic;
  final String facilityCategory;
  final String facilityType;
  final String facilitySubType;
  final String facilityLicenseIssueDate;
  final String facilityLicenseExpiryDate;
  final String facilityRegion;
  final String facilityCity;

  FacilityInformation({
    required this.facilityLicenseNumber,
    required this.facilityNameInEnglish,
    required this.facilityNameInArabic,
    required this.facilityCategory,
    required this.facilityType,
    required this.facilitySubType,
    required this.facilityLicenseIssueDate,
    required this.facilityLicenseExpiryDate,
    required this.facilityRegion,
    required this.facilityCity,
  });

  factory FacilityInformation.fromMap(Map<String, dynamic> map) {
    return FacilityInformation(
      facilityLicenseNumber: map['facilityLicenseNumber'] ?? '',
      facilityNameInEnglish: map['facilityNameInEnglish'] ?? '',
      facilityNameInArabic: map['facilityNameInArabic'] ?? '',
      facilityCategory: map['facilityCategory'] ?? '',
      facilityType: map['facilityType'] ?? '',
      facilitySubType: map['facilitySubType'] ?? '',
      facilityLicenseIssueDate: map['facilityLicenseIssueDate'] ?? '',
      facilityLicenseExpiryDate: map['facilityLicenseExpiryDate'] ?? '',
      facilityRegion: map['facilityRegion'] ?? '',
      facilityCity: map['facilityCity'] ?? ''
    );
  }

}

