import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_result_group.dart';
import 'package:aca_mobile_app/view_data_objects/inspection_type.dart';

class InspectionTypeConfig {
  List<InspectionType> inspectionTypes = [];
  List<InspectionResultGroup> inspectionResultGroups = [];
  List<ReportDescription> inspectionReports = [];
  String defaultModule;

  InspectionTypeConfig(this.inspectionTypes, this.inspectionResultGroups, this.inspectionReports, this.defaultModule);
}
