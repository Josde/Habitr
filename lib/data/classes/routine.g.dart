// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<dynamic, dynamic> json) => Routine(
      json['name'] as String,
      json['notification_time'] == null
          ? DateTime.now()
          : DateTime.parse(json['notification_time'] as String),
      json['notification_enabled'] as bool? ?? false,
      (json['notification_days_of_week'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          [true, true, true, true, true, true, true],
      const ActivityTypeConverter().fromJson(json['type'] as int),
      json['timer_length'] as int,
      creatorId: json['creator_id'] as String? ?? "",
      icon: json['icon'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
    )..id = json['id'] as int?;

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'creator_id': instance.creatorId,
      'notification_time': instance.notificationTime.toIso8601String(),
      'type': const ActivityTypeConverter().toJson(instance.type),
      'timer_length': instance.timerLength,
      'notification_enabled': instance.notificationsEnabled,
      'notification_days_of_week': instance.notificationDaysOfWeek,
      'is_public': instance.isPublic,
      'id': instance.id,
    };
