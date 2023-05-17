import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/all.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';
part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  List<Achievement> achievements = [
    // Feed
    FirstPostAchievement(),
    // Routine
    FirstRoutineAchievement(),
    FirstPublicRoutineAchievement(),
    // Routine Completion
    FirstRoutineCompletionAchievement(),
    HundredCompletionsAchievement(),
    // Streak
    OneWeekStreakAchievement(),
    ThreeWeekStreakAchievement(),
    // User
    FirstLevelUpAchievement()
  ];

  AchievementBloc() : super(AchievementInitial()) {
    on<LoadAchievementsEvent>(_onLoadAchievements);
    on<CheckAchievementsEvent>(_onCheckAchievements);
  }

  FutureOr<void> _onLoadAchievements(
      LoadAchievementsEvent event, Emitter<AchievementState> emit) async {
    // Load isUnlocked for all routines here.
    var achievementResponse =
        await supabase.from("profileAchievement").select() as List;
    for (var item in achievementResponse) {
      try {
        Achievement achievement =
            achievements.firstWhere((element) => element.id == item['id']);
        Achievement _newAchievement = achievement;
        _newAchievement.isUnlocked = true;
        achievements[achievements.indexOf(achievement)] = _newAchievement;
      } catch (e) {
        print("Achievement with ID ${item['id']} not found");
      }
    }
    emit.call(AchievementLoaded());
  }

  FutureOr<void> _onCheckAchievements(
      event, Emitter<AchievementState> emit) async {
    if (state is AchievementLoaded) {
      for (var achievement in this.achievements.where(
            (element) => element.type == event.type,
          )) {
        print("Checking for achievement $achievement...");
        var dataType = achievement.shouldUnlockDataType;
        if (!achievement.isUnlocked &&
            dataType.isType(event.data) &&
            achievement.shouldUnlock(dataType.asType(event.data))) {
          print('Unlocking achievement: ${achievement}');
          var index = this.achievements.indexOf(achievement);
          achievement.isUnlocked = true;
          this.achievements[index] = achievement;
          await supabase.from("profileAchievement").insert({
            'id': achievement.id,
            'profile_id': supabase.auth.currentUser?.id
          });
        }
      }
    }
  }
}