import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';

class UserRepository {
  Future<User> getSelf() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    return this.getUser(supabase.auth.currentUser!.id);
  }

  Future<User> getUser(String userId) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    final userResponse = await supabase
        .from('profiles')
        .select()
        .eq('uuid', userId)
        .single() as Map;
    print(userResponse);
    User _user = User.fromJson(userResponse);
    final streakResponse = await supabase
            .from('streak')
            .select()
            .eq('profile_id', supabase.auth.currentUser!.id)
            .or('id.eq.${_user.maxStreakId},id.eq.${_user.currentStreakId}')
        as List;
    print(streakResponse);
    for (var streak in streakResponse) {
      if (streak['id'] == _user.maxStreakId) {
        _user.maxStreak = Streak.fromJson(streak as Map);
      } else {
        _user.currentStreak = Streak.fromJson(streak as Map);
      }
    }
    return _user;
  }

  Future<void> changeFlowers(List<int> flowers) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase
        .from("profiles")
        .update({'flowers': flowers})
        .eq('uuid', supabase.auth.currentUser!.id)
        .select();
  }
}
