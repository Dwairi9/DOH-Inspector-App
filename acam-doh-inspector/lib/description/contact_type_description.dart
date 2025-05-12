import 'dart:convert';

import 'package:aca_mobile_app/description/unified_field_description.dart';
import 'package:flutter/foundation.dart';

class ContactTypeDescription {
  final List<UnifiedFieldDescription> unifiedFieldsList;
  final int maximum;
  final String type;
  final String typeDisp;
  final int minimum;
  ContactTypeDescription({
    required this.unifiedFieldsList,
    required this.maximum,
    required this.type,
    required this.typeDisp,
    required this.minimum,
  });

  ContactTypeDescription copyWith({
    required List<UnifiedFieldDescription> unifiedFieldsList,
    required int maximum,
    required String type,
    required String typeDisp,
    required int minimum,
  }) {
    return ContactTypeDescription(
      unifiedFieldsList: unifiedFieldsList,
      maximum: maximum,
      type: type,
      typeDisp: typeDisp,
      minimum: minimum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unifiedFieldsList': unifiedFieldsList.map((x) => x.toMap()).toList(),
      'maximum': maximum,
      'type': type,
      'typeDisp': typeDisp,
      'minimum': minimum,
    };
  }

  factory ContactTypeDescription.fromMap(Map<String, dynamic> map) {
    return ContactTypeDescription(
      unifiedFieldsList: List<UnifiedFieldDescription>.from(map['unifiedFields']?.map((x) => UnifiedFieldDescription.fromMap(x))),
      maximum: int.tryParse(map['maximum']) ?? -1,
      type: map['type'],
      typeDisp: map['typeDisp'],
      minimum: int.tryParse(map['minimum']) ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactTypeDescription.fromJson(String source) => ContactTypeDescription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactType(asi: $unifiedFieldsList, maximum: $maximum, type: $type, typeDisp: $typeDisp, minimum: $minimum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactTypeDescription &&
        listEquals(other.unifiedFieldsList, unifiedFieldsList) &&
        other.maximum == maximum &&
        other.typeDisp == typeDisp &&
        other.type == type &&
        other.minimum == minimum;
  }

  @override
  int get hashCode {
    return unifiedFieldsList.hashCode ^ maximum.hashCode ^ type.hashCode ^ typeDisp.hashCode ^ minimum.hashCode;
  }
}
