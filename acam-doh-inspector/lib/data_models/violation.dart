import 'package:aca_mobile_app/data_models/facility_information.dart';
import 'package:aca_mobile_app/data_models/professional_information.dart';
import 'package:aca_mobile_app/data_models/violation_clause.dart';
import 'package:aca_mobile_app/data_models/violation_information.dart';

class Violation{
  final String? violationCapId;
  final String? violationCustomId;
  final String? violationStatus;
  final ViolationInformation? violationInformation;
  final FacilityInformation? facilityInformation;
  final ProfessionalInformation? professionalInformation;
  final List<ViolationClause> violationClauses;

  Violation({
    required this.violationCapId,
    required this.violationCustomId,
    required this.violationStatus,
    required this.violationInformation,
    required this.facilityInformation,
    required this.professionalInformation,
    required this.violationClauses
  });

  factory Violation.fromMap(Map<String, dynamic> map) {
    return Violation(
      violationCapId: map['violationCapId'],
      violationCustomId: map['violationCustomId'],
      violationStatus: map['violationStatus'],
      violationInformation: map['violationInformation'] != null ? ViolationInformation.fromMap(map['violationInformation']) : null,
      facilityInformation: map['facilityInformation'] != null ? FacilityInformation.fromMap(map['facilityInformation']) : null,
      professionalInformation: map['professionalInformation'] != null ? ProfessionalInformation.fromMap(map['professionalInformation']) : null,
      violationClauses: List<ViolationClause>.from(map['violations']?.map((x) => ViolationClause.fromMap(x)) ?? []),
    );
  }
}

