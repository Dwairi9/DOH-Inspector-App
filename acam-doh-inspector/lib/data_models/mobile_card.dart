import 'dart:convert';

import 'package:aca_mobile_app/utility/utility.dart';
import 'package:flutter/foundation.dart';

class MobileCard {
  List<String> headers = [];
  List<CardEntry> entries = [];
  List<CardEntry> footerEntries = [];
  List<CardEntry> headerEntries = [];
  final bool useDefaultEntriesWhenEmpty;
  final bool useDefaultFootersWhenEmpty;
  final bool useDefaultHeadersWhenEmpty;
  List<String> footers = [];
  MobileCard({
    required this.useDefaultEntriesWhenEmpty,
    required this.useDefaultFootersWhenEmpty,
    required this.useDefaultHeadersWhenEmpty,
    required this.headers,
    required this.entries,
    required this.footers,
    required this.footerEntries,
    required this.headerEntries,
  });

  bool anyEntriesMatch(String searchValue) {
    return entries.any((element) => element.value.toLowerCase().contains(searchValue.toLowerCase())) ||
        headers.any((element) => element.toLowerCase().contains(searchValue.toLowerCase())) ||
        headerEntries.any((element) => element.value.toLowerCase().contains(searchValue.toLowerCase())) ||
        footerEntries.any((element) => element.value.toLowerCase().contains(searchValue.toLowerCase())) ||
        footers.any((element) => element.toLowerCase().contains(searchValue.toLowerCase()));
  }

  MobileCard.empty()
      : this(
          useDefaultEntriesWhenEmpty: true,
          useDefaultFootersWhenEmpty: true,
          useDefaultHeadersWhenEmpty: true,
          headers: [],
          entries: [],
          footers: [],
          footerEntries: [],
          headerEntries: [],
        );

  MobileCard copyWith({
    List<String>? headers,
    List<CardEntry>? entries,
    List<CardEntry>? footerEntries,
    List<CardEntry>? headerEntries,
    bool? useDefaultEntriesWhenEmpty,
    bool? useDefaultFootersWhenEmpty,
    bool? useDefaultHeadersWhenEmpty,
    List<String>? footers,
  }) {
    return MobileCard(
      headers: headers ?? this.headers,
      entries: entries ?? this.entries,
      footerEntries: footerEntries ?? this.footerEntries,
      headerEntries: headerEntries ?? this.headerEntries,
      useDefaultEntriesWhenEmpty: useDefaultEntriesWhenEmpty ?? this.useDefaultEntriesWhenEmpty,
      useDefaultFootersWhenEmpty: useDefaultFootersWhenEmpty ?? this.useDefaultFootersWhenEmpty,
      useDefaultHeadersWhenEmpty: useDefaultHeadersWhenEmpty ?? this.useDefaultHeadersWhenEmpty,
      footers: footers ?? this.footers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'headers': headers,
      'entries': entries.map((x) => x.toMap()).toList(),
      'footerEntries': footerEntries.map((x) => x.toMap()).toList(),
      'headerEntries': headerEntries.map((x) => x.toMap()).toList(),
      'useDefaultEntriesWhenEmpty': useDefaultEntriesWhenEmpty,
      'useDefaultFootersWhenEmpty': useDefaultFootersWhenEmpty,
      'useDefaultHeadersWhenEmpty': useDefaultHeadersWhenEmpty,
      'footers': footers,
    };
  }

  factory MobileCard.fromMap(Map<String, dynamic> map) {
    return MobileCard(
      headers: List<String>.from(map['headers']),
      entries: List<CardEntry>.from(map['entries']?.map((x) => CardEntry.fromMap(x))),
      footerEntries: List<CardEntry>.from(map['footerEntries']?.map((x) => CardEntry.fromMap(x))),
      headerEntries: List<CardEntry>.from(map['headerEntries']?.map((x) => CardEntry.fromMap(x))),
      useDefaultEntriesWhenEmpty: map['useDefaultEntriesWhenEmpty'] ?? false,
      useDefaultFootersWhenEmpty: map['useDefaultFootersWhenEmpty'] ?? false,
      useDefaultHeadersWhenEmpty: map['useDefaultHeadersWhenEmpty'] ?? false,
      footers: List<String>.from(map['footers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MobileCard.fromJson(String source) => MobileCard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MobileCard(headers: $headers, entries: $entries, useDefaultEntriesWhenEmpty: $useDefaultEntriesWhenEmpty, useDefaultFootersWhenEmpty: $useDefaultFootersWhenEmpty, useDefaultHeadersWhenEmpty: $useDefaultHeadersWhenEmpty, footers: $footers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MobileCard &&
        listEquals(other.headers, headers) &&
        listEquals(other.entries, entries) &&
        other.useDefaultEntriesWhenEmpty == useDefaultEntriesWhenEmpty &&
        other.useDefaultFootersWhenEmpty == useDefaultFootersWhenEmpty &&
        other.useDefaultHeadersWhenEmpty == useDefaultHeadersWhenEmpty &&
        listEquals(other.footers, footers);
  }

  @override
  int get hashCode {
    return headers.hashCode ^
        entries.hashCode ^
        useDefaultEntriesWhenEmpty.hashCode ^
        useDefaultFootersWhenEmpty.hashCode ^
        useDefaultHeadersWhenEmpty.hashCode ^
        footers.hashCode;
  }

  List<CardEntry> get entriesList {
    // filter entries, if the type is lineBreak and it is first in row, then remove it
    // if it is second in row then keep it
    List<CardEntry> filledEntries = entries.where((element) => element.type == "lineBreak" || element.value != "").toList();

    List<CardEntry> filteredEntries = [];
    for (int i = 0; i < filledEntries.length; i++) {
      if (filledEntries[i].type == "lineBreak") {
        if (i % 2 == 0) {
          continue;
        }
      }
      filteredEntries.add(filledEntries[i]);
    }

    return filteredEntries;
  }
}

class CardEntry {
  final String extraLabelColor;
  final bool showExtraLabel;
  final String labelPosition;
  final String dateFormat;
  final String label;
  final String extraLabel;
  final String type;
  final String value;
  final String valueIcon;
  final bool showLabel;
  final int numberOfLines;
  CardEntry({
    this.extraLabelColor = "red",
    this.showExtraLabel = false,
    this.labelPosition = "none",
    this.dateFormat = "yyyy-MM-dd HH:mm:ss",
    this.label = "",
    this.extraLabel = "",
    this.type = "text",
    this.value = "",
    this.valueIcon = "",
    this.showLabel = false,
    this.numberOfLines = 1,
  });

  CardEntry copyWith({
    String? extraLabelColor,
    bool? showExtraLabel,
    String? labelPosition,
    String? dateFormat,
    String? label,
    String? extraLabel,
    String? type,
    String? value,
    String? valueIcon,
    bool? showLabel,
    int? numberOfLines,
  }) {
    return CardEntry(
      extraLabelColor: extraLabelColor ?? this.extraLabelColor,
      showExtraLabel: showExtraLabel ?? this.showExtraLabel,
      labelPosition: labelPosition ?? this.labelPosition,
      dateFormat: dateFormat ?? this.dateFormat,
      label: label ?? this.label,
      extraLabel: extraLabel ?? this.extraLabel,
      type: type ?? this.type,
      value: value ?? this.value,
      valueIcon: valueIcon ?? this.valueIcon,
      showLabel: showLabel ?? this.showLabel,
      numberOfLines: numberOfLines ?? this.numberOfLines,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'extraLabelColor': extraLabelColor,
      'showExtraLabel': showExtraLabel,
      'labelPosition': labelPosition,
      'dateFormat': dateFormat,
      'label': label,
      'extraLabel': extraLabel,
      'type': type,
      'value': value,
      'valueIcon': valueIcon,
      'showLabel': showLabel,
      'numberOfLines': numberOfLines,
    };
  }

  factory CardEntry.fromMap(Map<String, dynamic> map) {
    return CardEntry(
      extraLabelColor: map['extraLabelColor'] ?? '',
      showExtraLabel: map['showExtraLabel'] ?? false,
      labelPosition: map['labelPosition'] ?? '',
      dateFormat: map['dateFormat'] ?? '',
      label: map['label'] ?? '',
      extraLabel: map['extraLabel'] ?? '',
      type: map['type'] ?? '',
      value: map['value'] ?? '',
      valueIcon: map['valueIcon'] ?? '',
      showLabel: map['showLabel'] ?? false,
      numberOfLines: map['maxNumberOfLines']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardEntry.fromJson(String source) => CardEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Entrie(extraLabelColor: $extraLabelColor, showExtraLabel: $showExtraLabel, labelPosition: $labelPosition, dateFormat: $dateFormat, label: $label, extraLabel: $extraLabel, type: $type, value: $value, valueIcon: $valueIcon, showLabel: $showLabel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CardEntry &&
        other.extraLabelColor == extraLabelColor &&
        other.showExtraLabel == showExtraLabel &&
        other.labelPosition == labelPosition &&
        other.dateFormat == dateFormat &&
        other.label == label &&
        other.extraLabel == extraLabel &&
        other.type == type &&
        other.value == value &&
        other.valueIcon == valueIcon &&
        other.showLabel == showLabel;
  }

  @override
  int get hashCode {
    return extraLabelColor.hashCode ^
        showExtraLabel.hashCode ^
        labelPosition.hashCode ^
        dateFormat.hashCode ^
        label.hashCode ^
        extraLabel.hashCode ^
        type.hashCode ^
        value.hashCode ^
        valueIcon.hashCode ^
        showLabel.hashCode;
  }

  DateTime? get date {
    if (type == 'date') {
      if (dateFormat.isEmpty) {
        throw Exception('Date format is required for date type');
      }
      return Utility.stringToDate(value, dateFormat);
    }

    return null;
  }
}
