part of 'achievement_bloc.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoaded extends AchievementState {
  AchievementLoaded();
  @override
  List<Object> get props => [];
}
