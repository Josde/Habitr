/// {@category Repositorio}
/// {@category GestionRutinas}
/// Repositorio que obtendrá los datos sobre las rutinas completadas de Supabase.
library;

import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

/// Clase que define el repositorio y sus métodos. Se puede hacer click para obtener una vista de detalle.
class RoutineCompletionRepository {
  /// Obtiene las rutinas que ha completado el usuario que usa la aplicación.
  ///
  /// Retorna una lista de RoutineCompletion.
  Future<List<RoutineCompletion>> getSelfRoutineCompletions() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    return this.getRoutineCompletions(supabase.auth.currentUser!.id);
  }

  /// Obtiene las rutinas completadas por iun usuario específicando su [userId].
  ///
  /// En la versión actual de la aplicación, sólo se utiliza para el usuario de la aplicación y nunca para sus amigos.
  ///
  /// Retorna una lista de RoutineCompletion.
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

  /// Añade una rutina completada [rc] a la base de datos.
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
