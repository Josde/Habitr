import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

class FirstRoutineCompletionAchievement extends Achievement {
  String name = "First try";
  String description = "You have completed your first routine!";
  AchievementType type = AchievementType.RoutineCompletion;
  bool isUnlocked = false;
  int id = 10;
  Typer shouldUnlockDataType = Typer<List<RoutineCompletion>>();
  FirstRoutineCompletionAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<RoutineCompletion> completions) {
    if (completions.length >= 1 && !isUnlocked) {
      return true;
    }
    return false;
  }
}
