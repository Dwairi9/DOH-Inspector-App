import 'dart:convert';

class InspectionResultGroupItem {
  final String type;
  final String value;
  final String text;
  InspectionResultGroupItem({
    required this.type,
    required this.value,
    required this.text,
  });

  InspectionResultGroupItem copyWith({
    String? type,
    String? value,
    String? text,
  }) {
    return InspectionResultGroupItem(
      type: type ?? this.type,
      value: value ?? this.value,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'text': text,
    };
  }

  factory InspectionResultGroupItem.fromMap(Map<String, dynamic> map) {
    return InspectionResultGroupItem(
      type: map['type'] ?? '',
      value: map['value'] ?? '',
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InspectionResultGroupItem.fromJson(String source) => InspectionResultGroupItem.fromMap(json.decode(source));

  @override
  String toString() => 'InspectionResultItem(type: $type, value: $value, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspectionResultGroupItem && other.type == type && other.value == value && other.text == text;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode ^ text.hashCode;
}
