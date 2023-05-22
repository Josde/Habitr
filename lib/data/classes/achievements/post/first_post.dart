import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/typer.dart';

class FirstPostAchievement extends Achievement {
  final String name = "Agora";
  final String description = "You have shared your first post!";
  final AchievementType type = AchievementType.Post;
  bool isUnlocked = false;
  final int id = 0;
  final Typer shouldUnlockDataType = Typer<List<Post>>();
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
