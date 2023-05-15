import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/all.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/data/classes/user.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  List<Achievement> feedAchievements = [FirstPostAchievement()];

  List<Achievement> routineAchievements = [
    FirstRoutineAchievement(),
    FirstPublicRoutineAchievement()
  ];

  List<Achievement> routineCompletionAchievements = [
    FirstRoutineCompletionAchievement(),
    HundredCompletionsAchievement()
  ];

  List<Achievement> streakAchievements = [
    OneWeekStreakAchievement(),
    ThreeWeekStreakAchievement()
  ];

  List<Achievement> userAchievements = [FirstLevelUpAchievement()];

  AchievementBloc() : super(AchievementInitial()) {
    on<LoadAchievementsEvent>(_onLoadAchievements);
    on<CheckFeedAchievementsEvent>(_onCheckFeedAchievements);
    on<CheckRoutineAchievementsEvent>(_onCheckRoutineAchievements);
    on<CheckRoutineCompletionAchievementsEvent>(
        _onCheckRoutineCompletionAchievements);
    on<CheckStreakAchievementsEvent>(_onCheckStreakAchievements);
    on<CheckUserAchievementsEvent>(_onCheckUserAchievements);
  }

  FutureOr<void> _onLoadAchievements(
      LoadAchievementsEvent event, Emitter<AchievementState> emit) {
    // Load isUnlocked for all routines here.
  }

  FutureOr<void> _onCheckFeedAchievements(
      CheckFeedAchievementsEvent event, Emitter<AchievementState> emit) {
    for (var achievement in this.feedAchievements) {
      if (!achievement.isUnlocked && achievement.shouldUnlock(event.posts)) {
        // Unlock stuff here.
      }
    }
  }

  FutureOr<void> _onCheckRoutineAchievements(
      CheckRoutineAchievementsEvent event, Emitter<AchievementState> emit) {
    for (var achievement in this.routineAchievements) {
      if (!achievement.isUnlocked && achievement.shouldUnlock(event.routines)) {
        // Unlock stuff here.
      }
    }
  }

  FutureOr<void> _onCheckRoutineCompletionAchievements(
      CheckRoutineCompletionAchievementsEvent event,
      Emitter<AchievementState> emit) {
    for (var achievement in this.routineCompletionAchievements) {
      if (!achievement.isUnlocked &&
          achievement.shouldUnlock(event.routineCompletions)) {
        // Unlock stuff here.
      }
    }
  }

  FutureOr<void> _onCheckStreakAchievements(
      CheckStreakAchievementsEvent event, Emitter<AchievementState> emit) {
    for (var achievement in this.feedAchievements) {
      if (!achievement.isUnlocked && achievement.shouldUnlock(event.streaks)) {
        // Unlock stuff here.
      }
    }
  }

  FutureOr<void> _onCheckUserAchievements(
      CheckUserAchievementsEvent event, Emitter<AchievementState> emit) {
    for (var achievement in this.feedAchievements) {
      if (!achievement.isUnlocked && achievement.shouldUnlock(event.user)) {
        // Unlock stuff here.
      }
    }
  }
}
