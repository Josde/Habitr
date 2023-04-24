// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<dynamic, dynamic> json) => Routine(
      json['name'] as String,
      json['notification_time'] == null
          ? TimeOfDay.now()
          : const TimeOfDayConverter()
              .fromJson(json['notification_time'] as String),
      json['notification_enabled'] as bool? ?? false,
      (json['notification_days_of_week'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          [true, true, true, true, true, true, true],
      const ActivityTypeConverter().fromJson(json['type'] as int),
      json['timer_length'] as int,
      isPublic: json['is_public'] as bool? ?? false,
    )
      ..icon = json['icon'] as String?
      ..id = json['id'] as int?;

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'notification_time':
          const TimeOfDayConverter().toJson(instance.notificationStartTime),
      'type': const ActivityTypeConverter().toJson(instance.type),
      'timer_length': instance.timerLength,
      'notification_enabled': instance.notificationsEnabled,
      'notification_days_of_week': instance.notificationDaysOfWeek,
      'is_public': instance.isPublic,
      'id': instance.id,
    };
