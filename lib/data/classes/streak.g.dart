// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Streak _$StreakFromJson(Map<dynamic, dynamic> json) => Streak(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    )
      ..userId = json['profile_id'] as String
      ..id = json['id'] as int;

Map<String, dynamic> _$StreakToJson(Streak instance) => <String, dynamic>{
      'profile_id': instance.userId,
      'id': instance.id,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
