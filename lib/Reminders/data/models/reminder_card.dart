import 'package:json_annotation/json_annotation.dart';

part 'reminder_card.g.dart';

@JsonSerializable()
class ReminderCard {
  final String id;
  final String title;
  final String message;
  final ReminderType type;
  final DateTime createdAt;
  final bool isRead;
  final String? actionText;

  const ReminderCard({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionText,
  });

  factory ReminderCard.fromJson(Map<String, dynamic> json) =>
      _$ReminderCardFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderCardToJson(this);

  ReminderCard copyWith({
    String? id,
    String? title,
    String? message,
    ReminderType? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionText,
  }) {
    return ReminderCard(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionText: actionText ?? this.actionText,
    );
  }
}

@JsonEnum()
enum ReminderType {
  @JsonValue('prayer_passed')
  prayerPassed,
  @JsonValue('prayer_upcoming')
  prayerUpcoming,
  @JsonValue('friday_surah')
  fridaySurah,
  @JsonValue('eid_greeting')
  eidGreeting,
  @JsonValue('ramadan_iftar')
  ramadanIftar,
  @JsonValue('general')
  general,
}
