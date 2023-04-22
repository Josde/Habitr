// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routinecompletion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineCompletion _$RoutineCompletionFromJson(Map<dynamic, dynamic> json) =>
    RoutineCompletion(
      json['profile_id'] as String,
      json['routine_id'] as int,
      DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$RoutineCompletionToJson(RoutineCompletion instance) =>
    <String, dynamic>{
      'profile_id': instance.userId,
      'routine_id': instance.routineId,
      'time': instance.time.toIso8601String(),
    };
