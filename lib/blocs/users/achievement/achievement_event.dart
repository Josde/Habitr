part of 'achievement_bloc.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object> get props => [];
}

class LoadAchievementsEvent extends AchievementEvent {}

class CheckRoutineAchievementsEvent extends AchievementEvent {
  final List<Routine> routines;

  CheckRoutineAchievementsEvent({required this.routines});
  @override
  List<Object> get props => [routines];
}

class CheckRoutineCompletionAchievementsEvent extends AchievementEvent {
  final List<RoutineCompletion> routineCompletions;

  CheckRoutineCompletionAchievementsEvent({required this.routineCompletions});
  @override
  List<Object> get props => [routineCompletions];
}

class CheckFeedAchievementsEvent extends AchievementEvent {
  final List<Post> posts;

  CheckFeedAchievementsEvent({required this.posts});
  @override
  List<Object> get props => [posts];
}

class CheckUserAchievementsEvent extends AchievementEvent {
  final User user;

  CheckUserAchievementsEvent({required this.user});
  @override
  List<Object> get props => [user];
}

class CheckStreakAchievementsEvent extends AchievementEvent {
  final List<Streak> streaks;

  CheckStreakAchievementsEvent({required this.streaks});
  @override
  List<Object> get props => [streaks];
}
