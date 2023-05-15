import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';

import '../base_achievement.dart';

class FirstRoutineAchievement extends Achievement {
  String name = "The start of something big";
  String description = "You have successfully created your first routine!";
  AchievementType type = AchievementType.Routine;
  bool isUnlocked = false;
  int id = 0;
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
