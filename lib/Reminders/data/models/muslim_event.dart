import 'package:json_annotation/json_annotation.dart';

part 'muslim_event.g.dart';

@JsonSerializable()
class MuslimEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final MuslimEventType type;
  final String iconName;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;

  const MuslimEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.iconName,
    this.isRecurring = false,
    this.recurrenceType,
  });

  factory MuslimEvent.fromJson(Map<String, dynamic> json) =>
      _$MuslimEventFromJson(json);

  Map<String, dynamic> toJson() => _$MuslimEventToJson(this);

  MuslimEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    MuslimEventType? type,
    String? iconName,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
  }) {
    return MuslimEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
    );
  }
}

@JsonEnum()
enum MuslimEventType {
  @JsonValue('prayer')
  prayer,
  @JsonValue('friday')
  friday,
  @JsonValue('eid_fitr')
  eidFitr,
  @JsonValue('eid_adha')
  eidAdha,
  @JsonValue('ramadan')
  ramadan,
  @JsonValue('hajj')
  hajj,
  @JsonValue('ashura')
  ashura,
  @JsonValue('mawlid')
  mawlid,
  @JsonValue('general')
  general,
}

@JsonEnum()
enum RecurrenceType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
}