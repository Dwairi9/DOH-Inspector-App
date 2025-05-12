import 'dart:convert';

class DropDownValueDescription {
  final String text;
  final String value;
  DropDownValueDescription({
    required this.text,
    required this.value,
  });

  DropDownValueDescription copyWith({
    required String text,
    required String value,
  }) {
    return DropDownValueDescription(
      text: text,
      value: value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'value': value,
    };
  }

  static List<DropDownValueDescription> getDropDownValueFromList(List<dynamic> list) {
    var arr = list.map((e) => DropDownValueDescription.fromMap(e)).toList();
    return arr;
  }

  factory DropDownValueDescription.fromMap(Map<String, dynamic> map) {
    return DropDownValueDescription(
      text: map['text'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DropDownValueDescription.fromJson(String source) => DropDownValueDescription.fromMap(json.decode(source));

  @override
  String toString() => 'DropDownValue(text: $text, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropDownValueDescription && other.text == text && other.value == value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;
}
