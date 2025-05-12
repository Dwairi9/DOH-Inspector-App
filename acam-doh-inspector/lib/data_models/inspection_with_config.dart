import 'package:aca_mobile_app/data_models/inspection.dart';
import 'package:aca_mobile_app/description/inspection_description.dart';

class InspectionWithConfig {
  final Inspection inspection;
  final InspectionDescription inspectionDescription;

  InspectionWithConfig({
    required this.inspection,
    required this.inspectionDescription,
  });

  factory InspectionWithConfig.fromMap(Map<String, dynamic> map) {
    return InspectionWithConfig(
      inspection: Inspection.fromMap(map['inspection']),
      inspectionDescription: InspectionDescription.fromMap(map['inspectionDescription']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inspection': inspection.toMap(),
      'inspectionDescription': inspectionDescription.toMap(),
    };
  }
}
