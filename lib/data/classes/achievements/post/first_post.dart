import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

class FirstPostAchievement extends Achievement {
  String name = "Agora";
  String description = "You have shared your first post!";
  AchievementType type = AchievementType.Post;
  bool isUnlocked = false;
  int id = 0;
  Typer shouldUnlockDataType = Typer<List<Post>>();
  FirstPostAchievement({this.isUnlocked = false});

  @override
  bool shouldUnlock(covariant List<Post> posts) {
    List<Post> ourPosts = posts
        .where(
          (Post element) => element.posterId == supabase.auth.currentUser?.id,
        )
        .toList();
    if (ourPosts.length >= 1 && !isUnlocked) {
      return true;
    }
    return false;
  }
}
