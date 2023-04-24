import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:json_annotation/json_annotation.dart';

class ActivityTypeConverter extends JsonConverter<ActivityType, int> {
  const ActivityTypeConverter();
  @override
  ActivityType fromJson(int json) {
    int index = json;
    return ActivityType.values[index];
  }

  @override
  int toJson(ActivityType object) {
    return ActivityType.values.indexOf(object);
  }
}
