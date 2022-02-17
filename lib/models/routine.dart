import 'package:flutter/material.dart';
import '../enum/ActivityType.dart';
class Routine {
  String name = "";
  int delayBetweenNotis = 180;
  ActivityType type = ActivityType.Instant;

  Routine(this.name, this.delayBetweenNotis, this.type);

  Routine.fromJson(Map<String,dynamic> json) {
    this.name = json['name'];
    this.delayBetweenNotis = int.parse(json['delayBetweenNotis']);
    this.type = ActivityType.values.elementAt(int.parse(json['type']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['delayBetweenNotis'] = this.delayBetweenNotis;
    json['type'] = this.type.index;
    return json;
  }
}