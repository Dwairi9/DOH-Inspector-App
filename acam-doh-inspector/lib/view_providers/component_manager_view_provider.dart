import 'package:aca_mobile_app/data_models/record_id.dart';
import 'package:aca_mobile_app/description/asi_subgroup_complete_description.dart';
import 'package:aca_mobile_app/view_providers/asi_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/asit_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/base_component_view_provider.dart';
import 'package:aca_mobile_app/view_providers/expression_manager_provider2.dart';
import 'package:flutter/widgets.dart';

enum InitialExpandState { first, all, none }

class ComponentManagerViewProvider extends ChangeNotifier {
  List<BaseComponentViewProvider> components = [];
  ExpressionManagerProvider2? expressionManagerProvider;
  bool isReadOnly = false;
  bool isComponentsExpandable = true;
  bool isLoading = false;
  InitialExpandState initialExpandState = InitialExpandState.first;

  ComponentManagerViewProvider(this.components,
      {this.isReadOnly = false,
      bool useAnonymousToken = false,
      RecordId? recordId,
      this.initialExpandState = InitialExpandState.first,
      this.isComponentsExpandable = true}) {
    expressionManagerProvider = ExpressionManagerProvider2(useAnonymousToken: useAnonymousToken, recordId: recordId);
    initProvider();
  }

  initProvider() {
    if (initialExpandState == InitialExpandState.all) {
      expandAllComponents();
    } else if (initialExpandState == InitialExpandState.first) {
      expandFirstComponent();
    }

    for (var component in components) {
      expressionManagerProvider?.addProvider(component);
    }

    initExpressions();
  }

  initComponent(BaseComponentViewProvider component) {
    var componentIdx = getComponentsCount() - 1;
    if (initialExpandState == InitialExpandState.all) {
      setExpanded(componentIdx, true);
    } else if (initialExpandState == InitialExpandState.first) {
      if (componentIdx == 0) {
        setExpanded(componentIdx, true);
      }
    }
    expressionManagerProvider?.addProvider(component);
  }

  initExpressions() {
    expressionManagerProvider?.runOnload();
  }

  addAsiComponentList(List<AsiSubgroupCompleteDescription> asiGroups, Map<String, Map<String, Object?>> asiValues) {
    for (var asiGroup in asiGroups) {
      addAsiComponent(asiGroup, asiValues[asiGroup.subgroup]);
    }
  }

  addAsiComponent(AsiSubgroupCompleteDescription asiGroup, Map<String, Object?>? values) {
    var asiComponent = AsiComponentViewProvider(
      asiGroup,
      title: asiGroup.subgroupDisp.isNotEmpty ? asiGroup.subgroupDisp : asiGroup.subgroup,
      values: values,
      expressionsDescription: asiGroup.expressionDescription,
    );

    components.add(asiComponent);
    initComponent(asiComponent);
  }

  addAsitComponentList(List<AsiSubgroupCompleteDescription> asitGroups, Map<String, List<Map<String, Object?>>> asitValues) {
    for (var asitGroup in asitGroups) {
      addAsitComponent(asitGroup, asitValues[asitGroup.subgroup]);
    }
  }

  addAsitComponent(AsiSubgroupCompleteDescription asitGroup, List<Map<String, Object?>>? values) {
    var asitComponent = AsitComponentViewProvider(
      asitGroup,
      title: asitGroup.subgroupDisp.isNotEmpty ? asitGroup.subgroupDisp : asitGroup.subgroup,
      values: values,
      expressionsDescription: asitGroup.expressionDescription,
    );

    components.add(asitComponent);
    initComponent(asitComponent);
  }

  isValid() {
    var isValid = true;
    for (var component in components) {
      if (!component.isValid()) {
        isValid = false;
      }
    }
    return isValid;
  }

  getComponentsCount() {
    // If the record component is for viewing, don't return empty components
    if (!isReadOnly) {
      return components.length;
    } else {
      return getNotEmptyComponents().length;
    }
  }

  BaseComponentViewProvider getComponent(int idx) {
    if (!isReadOnly) {
      return components[idx];
    } else {
      return getNotEmptyComponents()[idx];
    }
  }

  List<BaseComponentViewProvider> getComponents() {
    if (!isReadOnly) {
      return components;
    } else {
      return getNotEmptyComponents();
    }
  }

  List<BaseComponentViewProvider> getNotEmptyComponents() {
    return components.where((component) {
      if (component.type == ComponentType.asi) {
        var asiComponent = component as AsiComponentViewProvider;
        return (asiComponent.accelaUnifiedFormProvider.isNotEmpty());
      } else if (component.type == ComponentType.asit) {
        var asitComponent = component as AsitComponentViewProvider;
        return (asitComponent.tableProvider.getRowCount() > 0);
      }
      return false;
    }).toList();
  }

  bool isExpanded(int idx) {
    return getComponent(idx).expanded;
  }

  void setExpanded(int idx, bool expanded) {
    if (getComponent(idx).expanded != expanded) {
      getComponent(idx).expanded = expanded;
      notifyListeners();
    }
  }

  void expandFirstComponent() {
    if (getComponentsCount() > 0) {
      setExpanded(0, true);
    }
  }

  void expandAllComponents() {
    for (var i = 0; i < getComponentsCount(); i++) {
      setExpanded(i, true);
    }
  }

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
