class ViolationCategory {
  final String value;
  final String text;

  ViolationCategory({
    required this.value,
    required this.text,
  });

  factory ViolationCategory.fromMap(Map<String, dynamic> map) {
    return ViolationCategory(
      value: map['value'] ?? '',
      text: map['text'] ?? ''
    );
  }
}