import 'package:aca_mobile_app/Widgets/better_expansion_tile.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/attachment_view_provider.dart';
import 'package:aca_mobile_app/view_providers/component_manager_view_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:aca_mobile_app/views/asi_component_view.dart';
import 'package:aca_mobile_app/views/asit_component_view.dart';
import 'package:aca_mobile_app/views/attachment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentManagerView extends ConsumerWidget {
  ComponentManagerView(
    ComponentManagerViewProvider componentManagerProvider, {
    Key? key,
    this.scrollable = false,
  }) : super(key: key) {
    this.componentManagerProvider = ChangeNotifierProvider<ComponentManagerViewProvider>((ref) => componentManagerProvider);
  }

  late final ChangeNotifierProvider<ComponentManagerViewProvider> componentManagerProvider;
  final bool scrollable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);

    final provider = ref.watch(componentManagerProvider);
    return Column(
      children: [
        if (provider.isLoading)
          LinearProgressIndicator(
            color: themeNotifier.primaryColor,
            backgroundColor: Colors.transparent,
          )
        else
          Container(
            decoration: BoxDecoration(
              color: themeNotifier.primaryColor,
            ),
            height: 4,
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    itemCount: provider.getComponentsCount(),
                    shrinkWrap: true,
                    physics: scrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      BaseComponentViewProvider componentProvider = provider.getComponent(index);

                      if (provider.isComponentsExpandable) {
                        return Column(
                          children: [
                            const Divider(),
                            BetterExpansionTile(
                              initiallyExpanded: provider.isExpanded(index),
                              expandController: provider.getComponent(index).betterExpansionTileController,
                              title: Text(componentProvider.getTitle(upperCase: true),
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 26, fontWeight: FontWeight.w600)),
                              trailing: Icon(
                                provider.isExpanded(index) ? Icons.remove : Icons.add,
                                color: themeNotifier.iconColor,
                              ),
                              collapsedBackgroundColor: themeNotifier.getColor("light2"),
                              backgroundColor: themeNotifier.getColor("light5"),
                              onExpansionChanged: (bool isExpanded) {
                                provider.setExpanded(index, isExpanded);
                              },
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                ComponentContainerWidget(componentManagerProvider: provider, componentProvider: componentProvider),
                              ],
                            ),
                            // if (!provider.isExpanded(index) && provider.getComponentsCount() == index + 1)
                            //   const Divider(
                            //     height: 1,
                            //     thickness: 1,
                            //     indent: 0,
                            //     endIndent: 0,
                            //   ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            const Divider(),
                            ComponentContainerWidget(componentManagerProvider: provider, componentProvider: componentProvider),
                            if (provider.getComponentsCount() == index + 1) const Divider(),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ComponentContainerWidget extends ConsumerWidget {
  const ComponentContainerWidget({super.key, required this.componentManagerProvider, required this.componentProvider});

  final ComponentManagerViewProvider componentManagerProvider;
  final BaseComponentViewProvider componentProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (componentProvider.getInstructions().isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            child: Text(componentProvider.getInstructions(), style: Theme.of(context).textTheme.headlineSmall),
          ),
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: getComponentByType(context, componentManagerProvider, componentProvider)),
      ],
    );
  }

  Widget getComponentByType(BuildContext context, ComponentManagerViewProvider provider, BaseComponentViewProvider component) {
    switch (component.type) {
      case ComponentType.asi:
        return AsiComponentView(
          asiViewProvider: component as AsiComponentViewProvider,
        );
      case ComponentType.asit:
        return AsitComponentView(
          component as AsitComponentViewProvider,
        );
      case ComponentType.attachment:
        return AttachmentView(
          component as AttachmentViewProvider,
        );
      //   case ComponentTypes.ADDRESS:
      //     return AddressComponent(
      //       addressComponentProvider: component as AddressComponentProvider,
      //       readOnly: provider.readOnly,
      //     );

      //   case ComponentTypes.PARCEL:
      //     return ParcelComponent(
      //       parcelComponentProvider: component as ParcelComponentProvider,
      //     );
      //   case ComponentTypes.CONTACTLIST:
      //     return ContactListComponent(
      //       contactListComponentProvider: component as ContactListComponentProvider,
      //     );
      //   case ComponentTypes.CONTACT:
      //     return ContactComponent(
      //       component as ContactComponentProvider,
      //     );
      //   case ComponentTypes.LP:
      //     return LpComponent(lpComponentProvider: component as LpComponentProvider);
      //   case ComponentTypes.LPLIST:
      //     return LpListComponent(lpListComponentProvider: component as LpListComponentProvider);
      //   case ComponentTypes.CONDITIONDOCUMENT:
      //     return AttachmentComponent(attachmentComponentProvider: component as AttachmentComponentProvider);
      default:
        return Container(
          color: Colors.grey,
          child: const Text('No Component'),
        );
    }
  }
}
