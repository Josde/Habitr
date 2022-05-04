import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:uuid/uuid.dart';
int lastId = 0;
class Routine {
  //TODO: Somehow add the possibility to only get notifications on certains day of the week.
  String name = "";
  int numberOfNotifications = 3;
  TimeOfDay notificationStartTime = TimeOfDay.fromDateTime(DateTime(2022));
  ActivityType type = ActivityType.Instant;
  int timerLength = 0;
  bool notificationsEnabled = false;
  late int? id;
  Routine.withId(this.name, this.numberOfNotifications, this.notificationStartTime, this.notificationsEnabled, this.type, this.timerLength, this.id);
  Routine(this.name, this.numberOfNotifications, this.notificationStartTime, this.notificationsEnabled, this.type, this.timerLength) {
    this.id = lastId++;
  }
  Routine.empty();
  
  Routine.fromJson(Map<String,dynamic> json) {
    //TODO: Add error handling
    this.name = json['name'];
    this.type = ActivityType.values.elementAt(json['type']);
    if (json.containsKey('numberOfNotifications')) {
      this.numberOfNotifications = json['numberOfNotifications'];
    }
    if (json.containsKey('notificationStartTime')) {
      List<String> time = json['notificationStartTime'].split(',');
      if (time.length == 2) { // TODO: Add proper error handling to this.
        this.notificationStartTime = TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
      }

    }
    if (json.containsKey('id')) {
      this.id = json['id'];
      lastId = this.id! > lastId? this.id! : lastId;
    } else {
      this.id = lastId++;
    }
    if (json.containsKey('notificationsEnabled')) {
      this.notificationsEnabled = json['notificationsEnabled'];
    }
    if (json.containsKey('timerLength')) {
      this.timerLength = json['timerLength'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['numberOfNotifications'] = this.numberOfNotifications;
    json['notificationStartTime'] = '${this.notificationStartTime.hour},${this.notificationStartTime.minute}';
    json['type'] = this.type.index;
    json['timerLength'] = this.timerLength;
    json['id'] = this.id;
    json['notificationsEnabled'] = this.notificationsEnabled;
    print(json.toString());
    return json;
  }
}