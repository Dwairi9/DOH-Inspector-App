import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/views/accela_unified_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsiComponentView extends ConsumerWidget {
  final AsiComponentViewProvider asiViewProvider;
  const AsiComponentView({super.key, required this.asiViewProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccelaUnifiedFormView(asiViewProvider.accelaUnifiedFormProvider, scrollable: false);
  }
}
