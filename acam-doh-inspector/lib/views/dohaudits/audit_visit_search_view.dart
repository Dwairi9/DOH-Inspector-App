import 'package:aca_mobile_app/Widgets/background_notch_widget.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:aca_mobile_app/view_providers/dohaudits/audit_visit_search_provider.dart';
import 'package:aca_mobile_app/view_widgets/acam_list_manager_widget.dart';
import 'package:aca_mobile_app/view_widgets/dohaudits/audit_visit_card_widget.dart';
import 'package:aca_mobile_app/views/accela_unified_form_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditVisitSearchView extends ConsumerWidget {
  const AuditVisitSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitSearchProvider);
    // if (provider.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    if (!provider.isSearchFormInitialized()) {
      return Center(
          child: Text(
        'Search Failed to Initialize'.tr(),
        style: Theme.of(context).textTheme.headlineMedium,
      ));
    }

    return Stack(
      children: [
        const BackgroundNotch(),
        if (provider.viewType == AuditVisitSearchViewType.search) const AuditVisitSearchFormWidget(),
        if (provider.viewType == AuditVisitSearchViewType.results) const AuditVisitSearchResultView(),
      ],
    );
  }
}

class AuditVisitSearchFormWidget extends ConsumerWidget {
  const AuditVisitSearchFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitSearchProvider);
    final themeNotifer = ref.watch(themeProvider);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text("Search".tr(), style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: themeNotifer.primaryColor)),
        ),
        Expanded(child: SingleChildScrollView(child: AccelaUnifiedFormView(provider.searchFormProvider!))),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                var res = await provider.searchInspections();
                                if (!res.success) {
                                  if (context.mounted) {
                                    await Utility.showAlert(context, 'Search Failed'.tr(), res.message);
                                  }
                                }
                              },
                        child: provider.isLoading ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator()) : Text('Search'.tr())),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          side: MaterialStateBorderSide.resolveWith((states) => BorderSide(color: themeNotifer.light3Color))),
                      onPressed: () async {
                        // show confirmation dialog
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Clear Search'.tr()),
                                content: Text('Are you sure you want to clear the search form?'.tr()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'.tr())),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await provider.clearSearchForm();
                                      },
                                      child: Text('Clear'.tr())),
                                ],
                              );
                            });
                      },
                      child: Text('Clear'.tr(), style: const TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class AuditVisitSearchResultView extends ConsumerWidget {
  const AuditVisitSearchResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitSearchProvider);
    final themeNotifer = ref.watch(themeProvider);

    var auditVisits = provider.getAuditVisits();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${'Search Results'.tr()} (${auditVisits.length})", style: Theme.of(context).textTheme.headlineLarge),
              TextButton(
                  onPressed: () async {
                    provider.backToSearch();
                  },
                  child: Text('Refine Search'.tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeNotifer.primaryColor)))
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: AcamListManagerWidget(provider),
        ),
        const Divider(),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
        //   child: AcamListManagerWidget(provider),
        // ),
        // const Divider(),
        // const SizedBox(
        //   height: 16,
        // ),
        if (provider.isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              //   provider.loadInspections();
              return;
            },
            child: auditVisits.isNotEmpty
                ? ListView.builder(
                    itemCount: auditVisits.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
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
          )),
      ],
    );
  }
}
