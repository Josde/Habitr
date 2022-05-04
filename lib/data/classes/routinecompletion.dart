class RoutineCompletion {
  final String userId;
  final int routineId;
  late final DateTime time;
  RoutineCompletion(this.userId, this.routineId, this.time);
  RoutineCompletion.now(this.userId, this.routineId) {
    this.time = DateTime.now(); // TODO: This probably creates problems with timezones? idk tbh
  }
}