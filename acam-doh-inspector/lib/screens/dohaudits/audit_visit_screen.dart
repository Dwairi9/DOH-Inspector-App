import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_view_provider.dart';
import 'package:aca_mobile_app/views/dohaudits/audit_visit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitScreen extends ConsumerWidget {
  const AuditVisitScreen({
    Key? key,
    required this.auditVisitViewProvider,
  }) : super(key: key);

  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(auditVisitViewProvider);

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.getAuditVisitTitle(), style: const TextStyle(color: Colors.white, fontSize: 24)),
              Text(provider.getAuditVisitSubtitle(), style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuditVisitView(auditVisitViewProvider: auditVisitViewProvider),
            ],
          ),
        )));
  }
}
