import 'dart:io';

import 'package:aca_mobile_app/description/report_description.dart';

import 'package:aca_mobile_app/providers/report_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class MyReportsScreen extends ConsumerWidget {
  final ReportsProvider reportsProvider;
  const MyReportsScreen(this.reportsProvider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(ChangeNotifierProvider((ref) => reportsProvider));
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Text(
            "Reports".tr(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 50),
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  provider.loadMyReports();
                  return;
                },
                child: Container(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: provider.myReports.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: ReportItem(
                                report: provider.myReports[index],
                                reportsProvider: provider,
                              ));
                        }))),
          ),
        ]));
  }
}

class ReportItem extends ConsumerWidget {
  const ReportItem({Key? key, required this.report, required this.reportsProvider}) : super(key: key);

  final ReportsProvider reportsProvider;
  final ReportDescription report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(ChangeNotifierProvider((ref) => reportsProvider));
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.addchart_sharp, size: 60),
          const SizedBox(width: 10),
          Text(
            report.reportNameDisp.isNotEmpty ? report.reportNameDisp : report.reportName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          //   CircularProgressIndicator()
        ],
      ),
      onTap: () async {
        loadReport(context, provider, report);
      },
    );
  }

  loadReport(BuildContext context, ReportsProvider provider, ReportDescription report) async {
    provider.loadReportByDescription(report, {});
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
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ));
    } else if (!provider.reportLoadSuccess) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Failed to load report".tr(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            provider.errorMessage,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ));
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
