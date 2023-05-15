part of 'achievement_bloc.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoaded extends AchievementState {
  List<bool> isUnlocked;

  AchievementLoaded({required this.isUnlocked});
  @override
  List<Object> get props => [isUnlocked];
}
