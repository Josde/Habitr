/// {@category GestionLogros}
library;

import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

import '../base_achievement.dart';

class FirstRoutineAchievement extends Achievement {
  final String name = "The start of something big";
  final String description =
      "You have successfully created your first routine!";
  final AchievementType type = AchievementType.Routine;
  bool isUnlocked = false;
  final int id = 21;
  final Typer shouldUnlockDataType = Typer<List<Routine>>();
  FirstRoutineAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Routine> routines) {
    for (Routine r in routines) {
      if (r.creatorId == supabase.auth.currentUser?.id && !isUnlocked) {
        this.isUnlocked = true;
        return true;
      }
    }
    return false;
  }
}
