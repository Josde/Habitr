/// {@category GestionLogros}
library;

import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/typer.dart';

import '../base_achievement.dart';

class FirstPublicRoutineAchievement extends Achievement {
  final String name = "Going public";
  final String description =
      "You have successfully created or added a public routine!";
  final AchievementType type = AchievementType.Routine;
  bool isUnlocked = false;
  final int id = 20;
  final Typer shouldUnlockDataType = Typer<List<Routine>>();
  FirstPublicRoutineAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Routine> routines) {
    for (Routine r in routines) {
      print(r);
      if (r.isPublic && !isUnlocked) {
        print('true');
        return true;
      }
    }
    return false;
  }
}
