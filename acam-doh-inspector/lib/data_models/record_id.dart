import 'dart:convert';

class RecordId {
  final String id2;
  final String id1;
  final String id3;
  final String id;
  final String customId;
  RecordId({
    this.id2 = '',
    this.id1 = '',
    this.id3 = '',
    this.id = '',
    this.customId = '',
  });

  RecordId copyWith({
    String? id2,
    String? id1,
    String? id3,
    String? id,
    String? customId,
  }) {
    return RecordId(
      id2: id2 ?? this.id2,
      id1: id1 ?? this.id1,
      id3: id3 ?? this.id3,
      id: id ?? this.id,
      customId: customId ?? this.customId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id2': id2,
      'id1': id1,
      'id3': id3,
      'id': id,
      'customId': customId,
    };
  }

  factory RecordId.fromMap(Map<String, dynamic> map) {
    return RecordId(
      id2: map['id2'],
      id1: map['id1'],
      id3: map['id3'],
      id: map['id'],
      customId: map['customId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordId.fromJson(String source) => RecordId.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RecordId(id2: $id2, id1: $id1, id3: $id3, id: $id, customId: $customId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecordId && other.id2 == id2 && other.id1 == id1 && other.id3 == id3 && other.id == id && other.customId == customId;
  }

  @override
  int get hashCode {
    return id2.hashCode ^ id1.hashCode ^ id3.hashCode ^ id.hashCode ^ customId.hashCode;
  }
}
