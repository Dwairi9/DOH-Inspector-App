import 'package:aca_mobile_app/Widgets/better_expansion_tile.dart';
import 'package:aca_mobile_app/data_models/expression_field_result.dart';
import 'package:aca_mobile_app/description/expression_description.dart';
import 'package:aca_mobile_app/description/offline_expression_description.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:flutter/widgets.dart';

enum ComponentType { asi, asit, contact, lp, contactList, lpList, address, parcel, attachment }

class BaseComponentViewProvider extends ChangeNotifier {
  ComponentType type;
  String title = '';
  String instructions = '';
  bool expanded = false;
  Key key = UniqueKey();
  String uniqueId = '';
  ExpressionDescription? expressionsDescription;
  OfflineExpressionDescription? offlineExpressionDescription;
  BetterExpansionTileController betterExpansionTileController = BetterExpansionTileController();

  BaseComponentViewProvider(this.type,
      {this.title = '', this.uniqueId = '', this.instructions = '', this.expressionsDescription, this.offlineExpressionDescription}) {
    if (uniqueId.isEmpty) {
      uniqueId = generateUniqueId();
    }
  }

  String generateUniqueId() {
    return '${type}_${Utility.generateRandomString(10)}';
  }

  String getUniqueId() {
    return uniqueId;
  }

  Map<String, Object> getViewValues() {
    throw Exception("getComponentValues must be implemented in subclass");
  }

  bool isValid() {
    return true;
  }

  List<String> getInvalidItems() {
    return [];
  }

  bool saveEdits() {
    return true;
  }

  bool discardEdits() {
    return true;
  }

  Future<ExpressionFieldResult?> expressionOnSubmit() async {
    return Future.value(null);
  }

  bool isExpanded() {
    return expanded;
  }

  setExpanded(bool expanded) {
    this.expanded = expanded;
    if (expanded) {
      betterExpansionTileController.expand();
    } else {
      betterExpansionTileController.collapse();
    }
    notifyListeners();
  }

  String getTitle({bool upperCase = false}) {
    return upperCase ? title.toUpperCase() : title;
  }

  String getInstructions() {
    return instructions;
  }
}
