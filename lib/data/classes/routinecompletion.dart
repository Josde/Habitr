import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routinecompletion.g.dart';

@JsonSerializable()
class RoutineCompletion extends Equatable {
  @JsonKey(name: 'profile_id')
  late final String userId;
  @JsonKey(name: 'routine_id')
  late final int routineId;
  @JsonKey(name: 'time')
  late final DateTime time;
  RoutineCompletion(this.userId, this.routineId, this.time);
  RoutineCompletion.now(this.userId, this.routineId) {
    this.time = DateTime.now();
  }
  factory RoutineCompletion.fromJson(Map<dynamic, dynamic> json) =>
      _$RoutineCompletionFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineCompletionToJson(this);

  // RoutineCompletion.fromJson(Map<String, dynamic> json) {
  //   this.userId = json['userId'];
  //   this.routineId = json['routineId'];
  //   this.time = DateTime.parse(json['time']);
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> json = new Map<String, dynamic>();
  //   json['userId'] = this.userId;
  //   json['routineId'] = this.routineId;
  //   json['time'] = time.toString();
  //   return json;
  // }

  @override
  List<Object?> get props => [userId, routineId, time];
}
