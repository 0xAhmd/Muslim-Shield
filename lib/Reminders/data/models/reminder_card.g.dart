// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderCard _$ReminderCardFromJson(Map<String, dynamic> json) => ReminderCard(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isRead: json['isRead'] as bool? ?? false,
  actionText: json['actionText'] as String?,
);

Map<String, dynamic> _$ReminderCardToJson(ReminderCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'actionText': instance.actionText,
    };

const _$ReminderTypeEnumMap = {
  ReminderType.prayerPassed: 'prayer_passed',
  ReminderType.prayerUpcoming: 'prayer_upcoming',
  ReminderType.fridaySurah: 'friday_surah',
  ReminderType.eidGreeting: 'eid_greeting',
  ReminderType.ramadanIftar: 'ramadan_iftar',
  ReminderType.general: 'general',
};
