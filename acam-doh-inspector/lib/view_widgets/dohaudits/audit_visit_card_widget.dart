import 'package:aca_mobile_app/Widgets/mobile_card_widget.dart';
import 'package:aca_mobile_app/screens/dohaudits/audit_visit_screen.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/view_data_objects/dohaudits/audit_visit.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class AuditVisitCardWidget extends ConsumerWidget {
  const AuditVisitCardWidget({
    Key? key,
    required this.auditVisit,
  }) : super(key: key);

  final AuditVisit auditVisit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: InkWell(
            child: MobileCardWidget(mobileCard: auditVisit.getMobileCard()),
            onTap: () async {
              final auditVisitViewProvider = ChangeNotifierProvider((ref) {
                var userType = ref.watch(userSessionProvider).inspectorUserType;
                var provider = AuditVisitViewProvider(auditVisit.customId, userType, originAuditVisit: auditVisit);
                provider.initProvider();
                provider.setRef(ref);

                return provider;
              });

              Navigator.push(
                  context, PageTransition(type: PageTransitionType.leftToRight, child: AuditVisitScreen(auditVisitViewProvider: auditVisitViewProvider)));
            },
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
