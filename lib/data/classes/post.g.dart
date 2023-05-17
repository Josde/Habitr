// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<dynamic, dynamic> json) => Post(
      json['id'] as int,
      json['poster_id'] as String?,
      json['content'] as String?,
      DateTime.parse(json['post_date'] as String),
      json['likes'] as int? ?? 0,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'poster_id': instance.posterId,
      'content': instance.text,
      'post_date': instance.date?.toIso8601String(),
      'likes': instance.likes
    };
