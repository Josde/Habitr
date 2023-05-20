import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

import '../base_achievement.dart';

class OneWeekStreakAchievement extends Achievement {
  String name = "Going strong";
  String description = "You have completed routines 7 days in a row!";
  AchievementType type = AchievementType.Streak;
  bool isUnlocked = false;
  int id = 30;
  Typer shouldUnlockDataType = Typer<List<Streak>>();
  OneWeekStreakAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Streak> streaks) {
    List<Streak> ourStreaks = streaks
        .where(
          (element) => element.userId == supabase.auth.currentUser?.id,
        )
        .toList();
    for (Streak s in ourStreaks) {
      if (s.endDate.difference(s.startDate).inDays >= 7 && !isUnlocked) {
        this.isUnlocked = true;
        return true;
      }
    }
    return false;
  }
}
