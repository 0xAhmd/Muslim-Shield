// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muslim_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuslimEvent _$MuslimEventFromJson(Map<String, dynamic> json) => MuslimEvent(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$MuslimEventTypeEnumMap, json['type']),
  iconName: json['iconName'] as String,
  isRecurring: json['isRecurring'] as bool? ?? false,
  recurrenceType: $enumDecodeNullable(
    _$RecurrenceTypeEnumMap,
    json['recurrenceType'],
  ),
);

Map<String, dynamic> _$MuslimEventToJson(MuslimEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'type': _$MuslimEventTypeEnumMap[instance.type]!,
      'iconName': instance.iconName,
      'isRecurring': instance.isRecurring,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType],
    };

const _$MuslimEventTypeEnumMap = {
  MuslimEventType.prayer: 'prayer',
  MuslimEventType.friday: 'friday',
  MuslimEventType.eidFitr: 'eid_fitr',
  MuslimEventType.eidAdha: 'eid_adha',
  MuslimEventType.ramadan: 'ramadan',
  MuslimEventType.hajj: 'hajj',
  MuslimEventType.ashura: 'ashura',
  MuslimEventType.mawlid: 'mawlid',
  MuslimEventType.general: 'general',
};

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.yearly: 'yearly',
};
