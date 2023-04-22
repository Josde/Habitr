// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<dynamic, dynamic> json) => Routine(
      json['name'] as String,
      const TimeOfDayConverter().fromJson(json['notification_time'] as String),
      json['notification_enabled'] as bool,
      (json['notification_days_of_week'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      $enumDecode(_$ActivityTypeEnumMap, json['type']),
      json['timer_length'] as int,
      isPublic: json['is_public'] as bool? ?? false,
    )..id = json['id'] as int?;

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'name': instance.name,
      'notification_time':
          const TimeOfDayConverter().toJson(instance.notificationStartTime),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'timer_length': instance.timerLength,
      'notification_enabled': instance.notificationsEnabled,
      'notification_days_of_week': instance.notificationDaysOfWeek,
      'is_public': instance.isPublic,
      'id': instance.id,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.Instant: 'Instant',
  ActivityType.Timer: 'Timer',
  ActivityType.Stopwatch: 'Stopwatch',
};
