import 'package:equatable/equatable.dart';

class Streak extends Equatable {
  String userId;
  DateTime startDate;
  DateTime endDate;
  Streak(
      {required this.userId, required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [userId, startDate, endDate];
}
