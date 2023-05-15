import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

class HundredCompletionsAchievement extends Achievement {
  String name = "Completion expert";
  String description = "You have completed over 100 routines!";
  AchievementType type = AchievementType.RoutineCompletion;
  bool isUnlocked = false;
  int id = 0;
  HundredCompletionsAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<RoutineCompletion> completions) {
    if (completions.length >= 100 && !isUnlocked) {
      return true;
    }
    return false;
  }
}
