import 'package:flutter/material.dart';
import '../enum/ActivityType.dart';
class Routine {
  String name = "";
  int delayBetweenNotis = 180;
  ActivityType type = ActivityType.Instant;
  int timerLength = 0;

  Routine(this.name, this.delayBetweenNotis, this.type);
  Routine.timer(this.name, this.delayBetweenNotis, this.type, this.timerLength);
  Routine.empty();
  
  Routine.fromJson(Map<String,dynamic> json) {
    this.name = json['name'];
    this.delayBetweenNotis = int.tryParse(json['delayBetweenNotis']) ?? 180;
    this.type = ActivityType.values.elementAt(int.parse(json['type']));
    if (json.containsKey('timerLength')) {
      this.timerLength = int.tryParse(json['timerLength']) ?? 0;
    } else {
      this.timerLength = 10; // TODO: CHANGE THIS
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['delayBetweenNotis'] = this.delayBetweenNotis;
    json['type'] = this.type.index;
    json['timerLength'] = this.timerLength;
    return json;
  }
}