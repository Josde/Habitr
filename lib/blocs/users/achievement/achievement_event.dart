part of 'achievement_bloc.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object> get props => [];
}

class LoadAchievementsEvent extends AchievementEvent {}

class CheckAchievementsEvent extends AchievementEvent {
  final dynamic data;
  final AchievementType type;

  CheckAchievementsEvent({required this.data, required this.type});
  @override
  List<Object> get props => [data, type];
}
