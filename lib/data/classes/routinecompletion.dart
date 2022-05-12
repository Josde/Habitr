class RoutineCompletion {
  // TODO: Add defaults to prevent needing late modifier
  late String userId;
  late int routineId;
  late DateTime time;
  RoutineCompletion(this.userId, this.routineId, this.time);
  RoutineCompletion.now(this.userId, this.routineId) {
    this.time = DateTime.now(); // FIXME: This probably creates problems with timezones? idk tbh
  }

  RoutineCompletion.fromJson(Map<String,dynamic> json) {
    this.userId = json['userId'];
    this.routineId = json['routineId'];
    this.time = DateTime.parse(json['time']);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['userId'] = this.userId;
    json['routineId'] = this.routineId;
    json['time'] = time.toString();
    return json;
  }
}