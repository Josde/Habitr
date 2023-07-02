/// {@category Repositorio}
/// {@category GestionRutinas}
library;

import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';

class RoutineRepository {
  Future<List<Routine>> getSelfRoutines() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User not logged in');
    }
    List<Routine> _return = List.empty(growable: true);
    final routinesResponse = await supabase
        .from('profileRoutine')
        .select('*, routine!inner(*)') as List;
    for (var response in routinesResponse) {
      (response['routine'] as Map).addAll({
        'notification_days_of_week': response['notification_days_of_week'],
        'notification_time': (response['notification_time']),
        'notification_enabled': response['notification_enabled']
      } as Map<dynamic, dynamic>); // Removing this cast will make this not work
      Routine r = Routine.fromJson(response['routine'] as Map);
      _return.add(r);
    }
    return Future.value(_return);
  }

  Future<Routine> addRoutine(Routine r) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    Routine _return = r;
    final routineResponse = await supabase
        .from('routine')
        .insert({
          'name': r.name,
          'type': r.type.index,
          'timer_length': r.timerLength,
          'is_public': r.isPublic,
          'creator_id': supabase.auth.currentUser!.id,
          'icon': r.icon
        })
        .select()
        .single() as Map;
    _return.id = routineResponse['id'];
    final profileRoutineResponse =
        await supabase.from('profileRoutine').insert({
      'routine_id': r.id,
      'profile_id': supabase.auth.currentUser!.id,
      'notification_days_of_week': r.notificationDaysOfWeek,
      'notification_time': r.notificationTime.toIso8601String(),
      'notification_enabled': r.notificationsEnabled,
    });
    return Future.value(_return);
  }

  Future<Routine> addPublicRoutine(Routine r) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    Routine _return = await supabase.from('profileRoutine').insert(
        {'profile_id': supabase.auth.currentUser!.id, 'routine_id': r.id});
    return Future.value(_return);
  }

  Future<Routine> updateRoutine(Routine r) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    Routine _return = r;
    if (r.creatorId == supabase.auth.currentUser!.id) {
      final routineResponse = await supabase
          .from('routine')
          .update({
            'name': r.name,
            'type': r.type.index,
            'timer_length': r.timerLength,
            'is_public': r.isPublic,
            'creator_id': supabase.auth.currentUser!.id,
            'icon': r.icon
          })
          .eq('id', r.id)
          .select()
          .single();
      print(routineResponse);
    } else {
      final routineResponse = await supabase
          .from('routine')
          .insert({
            'name': r.name,
            'type': r.type.index,
            'timer_length': r.timerLength,
            'is_public': r.isPublic,
            'creator_id': supabase.auth.currentUser!.id,
            'icon': r.icon
          })
          .select()
          .single() as Map;
      print(routineResponse);
      _return.id = routineResponse['id'];
    }

    final profileRoutineResponse =
        await supabase.from('profileRoutine').update({
      'routine_id': _return.id,
      'profile_id': supabase.auth.currentUser!.id,
      'notification_days_of_week': r.notificationDaysOfWeek,
      'notification_time': r.notificationTime.toIso8601String(),
      'notification_enabled': r.notificationsEnabled,
    }).eq('routine_id', r.id); // Search by old id
    return _return;
  }

  Future<void> deleteRoutine(Routine r) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    final profileRoutineResponse = await supabase
        .from('profileRoutine')
        .delete()
        .eq('routine_id', r.id)
        .select()
        .single() as Map;
    if (!r.isPublic ||
        (r.isPublic && r.creatorId == supabase.auth.currentUser!.id)) {
      final routineResponse = await supabase
          .from('routine')
          .delete()
          .eq('id', r.id)
          .select()
          .single();
      print(routineResponse);
    }
  }
}
