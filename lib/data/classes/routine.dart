import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/converters/timeofdayconverter.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine.g.dart';

@JsonSerializable()
class Routine extends Equatable {
  @JsonKey()
  String name = "";
  @JsonKey(name: "notification_time")
  @TimeOfDayConverter() // Make fromJson and toJson for this
  TimeOfDay notificationStartTime = TimeOfDay.fromDateTime(DateTime(2022));
  @JsonKey(name: "type")
  ActivityType type = ActivityType.Instant;

  @JsonKey(name: "timer_length")
  int timerLength = 0;
  @JsonKey(name: "notification_enabled")
  bool notificationsEnabled = false;
  @JsonKey(name: "notification_days_of_week")
  List<bool> notificationDaysOfWeek = List.filled(7, true);
  @JsonKey(name: "is_public")
  bool isPublic = false;
  @JsonKey()
  late int? id = 0;
  Routine(this.name, this.notificationStartTime, this.notificationsEnabled,
      this.notificationDaysOfWeek, this.type, this.timerLength,
      {this.isPublic = false});

  Routine.empty();
  factory Routine.fromJson(Map<dynamic, dynamic> json) =>
      _$RoutineFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineToJson(this);
  // Routine.fromJson(Map<dynamic, dynamic> json) {
  //   //TODO: Add error handling
  //   this.name = json['name'];
  //   this.type = ActivityType.values.elementAt(json['type']);
  //   if (json.containsKey('numberOfNotifications')) {
  //     this.numberOfNotifications = json['numberOfNotifications'];
  //   }
  //   if (json.containsKey('notificationStartTime')) {
  //     List<String> time = json['notificationStartTime'].split(',');
  //     if (time.length == 2) {
  //       this.notificationStartTime =
  //           TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  //     }
  //   }
  //   if (json.containsKey('id')) {
  //     this.id = json['id'];
  //   } else {
  //     this.id = 0;
  //   }
  //   if (json.containsKey('notificationsEnabled')) {
  //     this.notificationsEnabled = json['notificationsEnabled'];
  //   }
  //   if (json.containsKey('timerLength')) {
  //     this.timerLength = json['timerLength'];
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> json = new Map<String, dynamic>();
  //   json['name'] = this.name;
  //   json['numberOfNotifications'] = this.numberOfNotifications;
  //   json['notificationStartTime'] =
  //       '${this.notificationStartTime.hour},${this.notificationStartTime.minute}';
  //   json['type'] = this.type.index;
  //   json['timerLength'] = this.timerLength;
  //   json['id'] = this.id;
  //   json['notificationsEnabled'] = this.notificationsEnabled;
  //   print(json.toString());
  //   return json;
  // }

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
