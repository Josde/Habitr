///@nodoc
library;

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class TimeOfDayConverter extends JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();
  @override
  TimeOfDay fromJson(String json) {
    List<String> time = json.split(',');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    return '${object.hour},${object.minute}';
  }
}
