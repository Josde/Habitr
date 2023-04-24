// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<dynamic, dynamic> json) => User(
      json['uuid'] as String,
      json['name'] as String,
      Country.parse(json['country_code'] as String),
      DateTime.parse(json['created_at'] as String),
      json['xp'] as int,
      json['current_streak'] as int? ?? 0,
      json['max_streak'] as int? ?? 0,
      json['is_admin'] as bool,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uuid': instance.id,
      'name': instance.name,
      'country_code': instance.country,
      'created_at': instance.createdAt.toIso8601String(),
      'xp': instance.xp,
      'current_streak': instance.currentStreak,
      'max_streak': instance.maxStreak,
      'is_admin': instance.isAdmin,
    };
