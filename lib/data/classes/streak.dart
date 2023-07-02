/// {@category Datos}
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'streak.g.dart';

@JsonSerializable()
class Streak extends Equatable {
  @JsonKey(name: 'profile_id')
  String userId = '';
  @JsonKey(name: 'id')
  int id = 0;
  @JsonKey(name: 'start_date', fromJson: DateTime.parse)
  DateTime startDate;
  @JsonKey(
      name: 'end_date', fromJson: DateTime.parse, defaultValue: DateTime.now)
  DateTime endDate;
  Streak({required this.startDate, required this.endDate});
  factory Streak.fromJson(Map<dynamic, dynamic> json) => _$StreakFromJson(json);

  Map<String, dynamic> toJson() => _$StreakToJson(this);
  @override
  List<Object?> get props => [userId, startDate, endDate];
}
