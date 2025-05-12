import 'dart:convert';

import 'package:flutter/foundation.dart';

class InspectionResultGroup {
  final String group;
  final List<InspectionResult> results;
  InspectionResultGroup({
    required this.group,
    required this.results,
  });

  InspectionResultGroup copyWith({
    String? group,
    List<InspectionResult>? results,
  }) {
    return InspectionResultGroup(
      group: group ?? this.group,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group': group,
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory InspectionResultGroup.fromMap(Map<String, dynamic> map) {
    return InspectionResultGroup(
      group: map['group'] ?? '',
      results: List<InspectionResult>.from(map['results']?.map((x) => InspectionResult.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory InspectionResultGroup.fromJson(String source) => InspectionResultGroup.fromMap(json.decode(source));

  @override
  String toString() => 'InspectionResultGroup(group: $group, results: $results)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspectionResultGroup && other.group == group && listEquals(other.results, results);
  }

  @override
  int get hashCode => group.hashCode ^ results.hashCode;
}

class InspectionResult {
  final int order;
  final String result;
  final String resultDisp;
  final String category;
  final String group;
  final String type;
  InspectionResult({
    required this.order,
    required this.result,
    required this.resultDisp,
    required this.category,
    required this.group,
    required this.type,
  });

  InspectionResult copyWith({
    int? order,
    String? result,
    String? resultDisp,
    String? category,
    String? group,
    String? type,
  }) {
    return InspectionResult(
      order: order ?? this.order,
      result: result ?? this.result,
      resultDisp: resultDisp ?? this.resultDisp,
      category: category ?? this.category,
      group: group ?? this.group,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'result': result,
      'resultDisp': resultDisp,
      'category': category,
      'group': group,
      'type': type,
    };
  }

  factory InspectionResult.fromMap(Map<String, dynamic> map) {
    return InspectionResult(
      order: map['order']?.toInt() ?? 0,
      result: map['result'] ?? '',
      resultDisp: map['resultDisp'] ?? '',
      category: map['category'] ?? '',
      group: map['group'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InspectionResult.fromJson(String source) => InspectionResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Result(order: $order, result: $result, resultDisp: $resultDisp, category: $category, group: $group, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspectionResult &&
        other.order == order &&
        other.result == result &&
        other.resultDisp == resultDisp &&
        other.category == category &&
        other.group == group &&
        other.type == type;
  }

  @override
  int get hashCode {
    return order.hashCode ^ result.hashCode ^ resultDisp.hashCode ^ category.hashCode ^ group.hashCode ^ type.hashCode;
  }
}
