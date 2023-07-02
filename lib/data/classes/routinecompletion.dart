/// {@category Datos}
/// {@category GestionRutinas}
/// Representa una rutina que ha sido completada por cierto usuario a cierta hora.
library;

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

  @override
  List<Object?> get props => [userId, routineId, time];
}
