part of 'achievement_bloc.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoaded extends AchievementState {
  AchievementLoaded({required this.achievements});
  List<Achievement> achievements;
  @override
  List<Object> get props => [achievements];
}

class AchievementError extends AchievementState {
  AchievementError({required this.error});
  String error;
  @override
  List<String> get props => [error];
}
