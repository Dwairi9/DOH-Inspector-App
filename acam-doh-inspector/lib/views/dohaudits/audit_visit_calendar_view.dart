import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_list_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:aca_mobile_app/view_widgets/dohaudits/audit_visit_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitCalendarView extends ConsumerWidget {
  const AuditVisitCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(currentAuditVisitListProvider);

    return AuditVisitCalendarWidget(provider: provider);
  }
}

class AuditVisitCalendarWidget extends StatelessWidget {
  const AuditVisitCalendarWidget({
    super.key,
    required this.provider,
  });

  final AuditVisitListProvider provider;

  @override
  Widget build(BuildContext context) {
    var auditVisits = provider.getAuditVisits();
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: AcamListManagerWidget(provider),
        ),
        const Divider(),
        const SizedBox(
          height: 8,
        ),
        if (provider.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Text("${'Total Number of Audit Visits'.tr()} (${auditVisits.length})",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const Divider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    provider.loadInspections();
                    return;
                  },
                  child: auditVisits.isNotEmpty
                      ? ListView.builder(
                          itemCount: auditVisits.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                              // child: InspectionRecordCardWidget(record: recordList[index]),
                              child: AuditVisitCardWidget(auditVisit: auditVisits[index]),
                            );
                          })
                      : ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Center(
                                child: Text(
                              'No Data'.tr(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ))
                          ],
                        ),
                ),
              ),
            ],
          )),
      ],
    );
  }
}
