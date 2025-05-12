import 'dart:io';

import 'package:aca_mobile_app/description/report_description.dart';
import 'package:aca_mobile_app/providers/report_provider.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/global_inspection_provider.dart';
import 'package:aca_mobile_app/view_providers/inspection_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class InspectionReportsView extends ConsumerWidget {
  const InspectionReportsView(this.inspectionProvider, {Key? key}) : super(key: key);

  final InspectionProvider inspectionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalProvider = ref.watch(inspectionGlobalProvider);
    final provider = ref.watch(globalProvider.reportsProvider);

    return Column(
      children: [
        const SizedBox(height: 16),
        if (provider.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
              child: provider.myReports.isNotEmpty
                  ? ListView.builder(
                      itemCount: provider.myReports.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                          child: ReportItemWidget(
                            reportsProvider: provider,
                            report: provider.myReports[index],
                            inspectionProvider: inspectionProvider,
                          ),
                        );
                      })
                  : ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(
                            child: Text(
                          'No Data'.tr(),
                          style: Theme.of(context).textTheme.displaySmall,
                        ))
                      ],
                    )),
      ],
    );
  }
}

class ReportItemWidget extends ConsumerWidget {
  const ReportItemWidget({Key? key, required this.report, required this.reportsProvider, required this.inspectionProvider}) : super(key: key);

  final ReportsProvider reportsProvider;
  final ReportDescription report;
  final InspectionProvider inspectionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(ChangeNotifierProvider((ref) => reportsProvider));
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.addchart_sharp, size: 60),
          const SizedBox(width: 10),
          Expanded(
            child: AutoSizeText(
              minFontSize: 12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              report.reportNameDisp.isNotEmpty ? report.reportNameDisp : report.reportName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          //   const Spacer(),
          //   CircularProgressIndicator()
        ],
      ),
      onTap: () async {
        loadReport(context, provider, report);
      },
    );
  }

  buildParametersMap(ReportDescription report) {
    final parameters = <String, dynamic>{};
    for (var element in report.params) {
      if (element.defaultValue == "servProvCode") {
        parameters[element.parameterName] = Constants.agency;
      } else if (element.defaultValue == "capID") {
        parameters[element.parameterName] = inspectionProvider.inspection?.recordId;
      } else if (element.defaultValue == "altID") {
        parameters[element.parameterName] = inspectionProvider.customId;
      } else if (element.parameterName == 'recordid') {
        parameters[element.parameterName] = inspectionProvider.inspection?.recordId;
      }
    }
    return parameters;
  }

  loadReport(BuildContext context, ReportsProvider provider, ReportDescription report) async {
    var params = buildParametersMap(report);
    report = report.copyWith(module: report.module.isNotEmpty ? report.module : provider.defaultModule);
    provider.loadReportByDescription(report, {
      "parameters": params
      //   {
      //     // "RECORD_ID": "PESV-2023-000108",
      //     "agencyid": Constants.agency,
      //     "capid": visit.recordId,
      //     "b1_alt_id": visit.customId,
      //     // "RECID": visit.customId,
      //   }
    });
    Utility.showFullScreenDialog(
        context,
        PdfViewerWidget(
          reportsProvider: provider,
        ),
        "Report Viewer".tr(),
        []);
  }
}

class PdfViewerWidget extends ConsumerWidget {
  const PdfViewerWidget({Key? key, required this.reportsProvider}) : super(key: key);

  final ReportsProvider reportsProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(ChangeNotifierProvider((ref) => reportsProvider));
    if (provider.isLoadingReport) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 40),
          Text(
            "Loading Report".tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          )
        ],
      ));
    } else if (!provider.reportLoadSuccess) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Failed to load report".tr(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              provider.errorMessage.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      );
    }

    return PdfPreview(
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      dynamicLayout: true,
      build: (format) {
        final file = File(provider.currentReportPath);
        return file.readAsBytes();
      },
    );
  }
}
