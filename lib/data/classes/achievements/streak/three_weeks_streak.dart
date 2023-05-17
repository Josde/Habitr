import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

import '../base_achievement.dart';

class ThreeWeekStreakAchievement extends Achievement {
  String name = "Consistency";
  String description =
      "You have successfully completed routines daily for 3 weeks!";
  AchievementType type = AchievementType.Streak;
  bool isUnlocked = false;
  int id = 0;
  Typer shouldUnlockDataType = Typer<List<Streak>>();
  ThreeWeekStreakAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Streak> streaks) {
    List<Streak> ourStreaks = streaks
        .where(
          (element) => element.userId == supabase.auth.currentUser?.id,
        )
        .toList();
    for (Streak s in ourStreaks) {
      if (s.endDate.difference(s.startDate).inDays >= 21 && !isUnlocked) {
        this.isUnlocked = true;
        return true;
      }
    }
    return false;
  }
}
