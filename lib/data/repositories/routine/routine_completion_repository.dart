import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

class RoutineCompletionRepository {
  Future<List<RoutineCompletion>> getSelfRoutineCompletions() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    return this.getRoutineCompletions(supabase.auth.currentUser!.id);
  }

  Future<List<RoutineCompletion>> getRoutineCompletions(String userId) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    List<RoutineCompletion> _return = List.empty();
    final routineCompletionResponse = await supabase
        .from('routineCompletion')
        .select()
        .eq('profile_id', userId) as List;
    for (var rc in routineCompletionResponse) {
      _return.add(RoutineCompletion.fromJson(rc as Map));
    }
    return Future.value(_return);
  }

  Future<void> addRoutineCompletion(RoutineCompletion rc) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase.from('routineCompletion').insert({
      'routine_id': rc.routineId,
      'profile_id': supabase.auth.currentUser!.id,
      'time': rc.time.toIso8601String()
    });
  }
}
