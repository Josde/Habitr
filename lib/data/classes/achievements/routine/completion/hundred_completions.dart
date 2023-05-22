import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/typer.dart';

class HundredCompletionsAchievement extends Achievement {
  final String name = "Completion expert";
  final String description = "You have completed over 100 routines!";
  final AchievementType type = AchievementType.RoutineCompletion;
  bool isUnlocked = false;
  final int id = 11;
  final Typer shouldUnlockDataType = Typer<List<RoutineCompletion>>();
  HundredCompletionsAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<RoutineCompletion> completions) {
    if (completions.length >= 100 && !isUnlocked) {
      return true;
    }
    return false;
  }
}
