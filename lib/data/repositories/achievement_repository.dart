/// {@category Repositorio}
/// {@category GestionLogros}
library;

import 'package:habitr_tfg/data/classes/achievements/base_achievement.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';

class AchievementRepository {
  Future<List<Achievement>> getAchievements(String userId) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    List<Achievement> _return = List.empty(growable: true);
    List<Achievement> _fullAchievementList = achievementList.toList();
    var achievementResponse = await supabase
        .from("profileAchievement")
        .select()
        .eq('profile_id', userId) as List;
    for (var item in achievementResponse) {
      Achievement _newAchievement = _fullAchievementList
          .firstWhere((element) => element.id == item['achievement_id']);
      _newAchievement.isUnlocked = true;
      _newAchievement.unlockedAt =
          DateTime.tryParse(item['unlocked_at']) ?? DateTime.now();
      _return.add(_newAchievement);
    }
    return _return;
  }

  Future<void> unlockAchievement(Achievement a) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase.from("profileAchievement").insert(
        {'achievement_id': a.id, 'profile_id': supabase.auth.currentUser?.id});
  }
}
