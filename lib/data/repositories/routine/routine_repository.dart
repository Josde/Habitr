/// {@category Repositorio}
/// {@category GestionRutinas}
/// Repositorio que obtendrá y modificará los datos de las rutinas usando Supabase.
library;

import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';

/// Clase que define el repositorio y sus métodos. Se puede hacer click para obtener una vista de detalle.
///
/// Al igual que en otros repositorios, tódos los métodos lanzan excepciones sin capturar, y por tanto han de estar en un bloque try - catch.
class RoutineRepository {
  /// Obtiene las rutinas del usuario de la aplicación.
  ///
  /// Retorna una lista de Routine.
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

  /// Añade una rutina [r] a las rutinas del usuario.
  ///
  /// Retorna [r] pero actualizando la ID a  que tenga en la BBDD, para poder seguir manipulando el mismo objeto.
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

  /// Añade una rutina pública [r] a las rutinas del usuario.
  ///
  /// Retorna [r] por temas de debugging, aunque en versiones futuras probablemente esto deje de ser así.
  Future<Routine> addPublicRoutine(Routine r) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    Routine _return = await supabase.from('profileRoutine').insert({
      'profile_id': supabase.auth.currentUser!.id,
      'routine_id': r.id
    }).select();
    return Future.value(_return);
  }

  /// Funcion que actualiza una rutina [r]
  ///
  /// Devuelve [r] con sus modificaciones hechas, aunque igual que en la función anterior esto probablemente deje de ser así en versiones futuras.
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

  /// Borra la rutina [r].
  ///
  /// No retorna nada.
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
