import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/repositories/report_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class ReportsProvider extends ChangeNotifier {
  List<ReportDescription> myReports = [];
  String defaultModule = "";

  bool isLoading = false;
  bool isLoadingReport = false;
  bool reportLoadSuccess = false;
  String errorMessage = '';
  String currentReportPath = '';
  double loadingValue = 0;

  ReportsProvider();

  initProvider() async {
    loadMyReports();
  }

  loadMyReports() async {
    setLoading(true);
    myReports = await ReportRepository.getMyReports();
    setLoading(false);
  }

  setLoading(loading) {
    isLoading = loading;
    notifyListeners();
  }

  setLoadingReport(loading) {
    isLoadingReport = loading;
    notifyListeners();
  }

  setLoadingValue(double loadingValue) {
    this.loadingValue = loadingValue;
    notifyListeners();
  }

  String getCleanedUpErrorMessage() {
    if (errorMessage.contains("504 Gateway Time-out")) {
      return "The report is taking too long to load. Please try again later.".tr();
    } else {
      return errorMessage;
    }
  }

  setReportLoadResult(bool reportLoadSuccess, String message, String reportFullPath) {
    this.reportLoadSuccess = reportLoadSuccess;
    errorMessage = message;
    currentReportPath = reportFullPath;
    notifyListeners();
  }

  loadReportByDescription(ReportDescription report, dynamic params) async {
    loadReport(report.reportName, report.reportId, report.module, params);
  }

  loadReport(String reportName, String reportId, String module, dynamic params) async {
    setLoadingValue(0);
    setLoadingReport(true);
    ActionObject validateObject = await AccelaServiceManager.getReport(reportName, reportId, module.isNotEmpty ? module : "Building", params, (count, total) {
      setLoadingValue(count / total);
    });

    setReportLoadResult(validateObject.success, validateObject.message, validateObject.content);

    setLoadingReport(false);
    notifyListeners();
  }
}
