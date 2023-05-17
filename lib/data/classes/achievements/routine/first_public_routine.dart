import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/typer.dart';

import '../base_achievement.dart';

class FirstPublicRoutineAchievement extends Achievement {
  String name = "Going public";
  String description =
      "You have successfully created or added a public routine!";
  AchievementType type = AchievementType.Routine;
  bool isUnlocked = false;
  int id = 0;
  Typer shouldUnlockDataType = Typer<List<Routine>>();
  FirstPublicRoutineAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Routine> routines) {
    for (Routine r in routines) {
      if (r.isPublic && !isUnlocked) {
        return true;
      }
    }
    return false;
  }
}
