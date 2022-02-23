import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:uuid/uuid.dart';
class Routine {
  String name = "";
  int delayBetweenNotis = 180;
  ActivityType type = ActivityType.Instant;
  int timerLength = 0;
  late String id;

  Routine(this.name, this.delayBetweenNotis, this.type, this.timerLength) {
    this.id = uuid.v4();
  }
  Routine.empty();
  
  Routine.fromJson(Map<String,dynamic> json) {
    //TODO: Add error handling
    this.name = json['name'];
    this.delayBetweenNotis = json['delayBetweenNotis'];
    this.id = json['id'];
    this.type = ActivityType.values.elementAt(json['type']);
    if (json.containsKey('timerLength')) {
      this.timerLength = json['timerLength'];
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
    json['id'] = this.id;
    return json;
  }
}