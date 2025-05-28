class ProfessionalInformation{
  final String professionalLicenseNumber;
  final String professionalNameInEnglish;
  final String professionalNameInArabic;
  final String professionalCategory;
  final String professionalMajor;
  final String professionalProfession;
  final String professionalLicenseIssueDate;
  final String professionalLicenseExpiryDate;
  final String errorMessage;

  ProfessionalInformation({
    required this.professionalLicenseNumber,
    required this.professionalNameInEnglish,
    required this.professionalNameInArabic,
    required this.professionalCategory,
    required this.professionalMajor,
    required this.professionalProfession,
    required this.professionalLicenseIssueDate,
    required this.professionalLicenseExpiryDate,
    required this.errorMessage
  });

  factory ProfessionalInformation.fromMap(Map<String, dynamic> map) {
    return ProfessionalInformation(
        professionalLicenseNumber: map['professionalLicenseNumber'] ?? '',
        professionalNameInEnglish: map['professionalEnglishName'] ?? '',
        professionalNameInArabic: map['professionalArabicName'] ?? '',
        professionalCategory: map['category'] ?? '',
        professionalMajor: map['major'] ?? '',
        professionalProfession: map['professional'] ?? '',
        professionalLicenseIssueDate: map['professionalLicenseIssueDate'] ?? '',
        professionalLicenseExpiryDate: map['professionalLicenseExpiryDate'] ?? '',
        errorMessage: map['errorMessage'] ?? ''
    );
  }
}

