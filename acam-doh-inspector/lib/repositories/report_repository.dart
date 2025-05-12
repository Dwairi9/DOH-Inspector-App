import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/network/accela_services.dart';

class ReportRepository {
  static Future<List<ReportDescription>> getMyReports() async {
    List<ReportDescription> myReports = [];
    var result = await AccelaServiceManager.emseRequest('getReports', {});
    if (result.success) {
      myReports = List<ReportDescription>.from(result.content.map((repo) => ReportDescription.fromMap(repo))).toList();
    }

    return myReports;
  }
}
