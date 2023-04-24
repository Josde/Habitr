import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/converters/activitytypeconverter.dart';
import 'package:habitr_tfg/data/converters/timeofdayconverter.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine.g.dart';

@JsonSerializable()
class Routine extends Equatable {
  @JsonKey()
  String name;
  @JsonKey()
  String? icon;
  @JsonKey(
      name: "notification_time",
      defaultValue: TimeOfDay.now) // change default value
  @TimeOfDayConverter()
  TimeOfDay notificationStartTime;

  @JsonKey(name: "type")
  @ActivityTypeConverter()
  ActivityType type;

  @JsonKey(name: "timer_length")
  int timerLength;
  @JsonKey(name: "notification_enabled", defaultValue: false)
  bool notificationsEnabled;
  @JsonKey(
      name: "notification_days_of_week",
      defaultValue: [true, true, true, true, true, true, true])
  List<bool> notificationDaysOfWeek;
  @JsonKey(name: "is_public", defaultValue: false)
  bool isPublic;
  @JsonKey()
  int? id;
  Routine(this.name, this.notificationStartTime, this.notificationsEnabled,
      this.notificationDaysOfWeek, this.type, this.timerLength,
      {this.icon, this.isPublic = false});

  factory Routine.fromJson(Map<dynamic, dynamic> json) =>
      _$RoutineFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineToJson(this);

  @override
  List<Object?> get props => [
        name,
        id,
        notificationsEnabled,
        notificationStartTime,
        notificationDaysOfWeek
      ];

  static getActivityType() {}
}
