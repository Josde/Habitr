import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

class FirstLevelUpAchievement extends Achievement {
  final String name = "Getting stronger";
  final String description = "You have leveled up!";
  final AchievementType type = AchievementType.User;
  bool isUnlocked = false;
  final int id = 40;
  final Typer shouldUnlockDataType = Typer<List<User>>();
  FirstLevelUpAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<User> users) {
    User self = users
        .firstWhere((element) => element.id == supabase.auth.currentUser?.id);
    if (self.xp >= 500 && !isUnlocked) {
      return true;
    }
    return false;
  }
}
