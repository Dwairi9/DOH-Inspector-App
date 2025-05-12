import 'dart:convert';

class ActionObject<T> {
  bool success = false;
  bool isAppError = false;
  String message = "";
  String title = "";
  T? content;
  ActionObject({
    required this.success,
    required this.message,
    this.title = "",
    this.content,
    this.isAppError = false,
  });

  ActionObject copyWith({
    bool? success,
    bool? isAppError,
    String? message,
    String? title,
    T? content,
  }) {
    return ActionObject(
      success: success ?? this.success,
      isAppError: isAppError ?? this.isAppError,
      message: message ?? this.message,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'isAppError': isAppError,
      'message': message,
      'title': title,
      'content': content,
    };
  }

  factory ActionObject.fromMap(Map<String, dynamic> map) {
    return ActionObject(
      success: map['success'],
      isAppError: map['isAppError'] ?? false,
      message: map['message'],
      title: map['title'] ?? "",
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionObject.fromJson(String source) => ActionObject.fromMap(json.decode(source));

  @override
  String toString() => 'ValidationObject(success: $success, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActionObject && other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;
}
