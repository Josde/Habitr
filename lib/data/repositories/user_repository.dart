/// {@category Repositorio}
/// {@category GestionUsuario}
/// Repositorio que permite recuperar y oeprar sobre usuarios usando Supabase.
library;

import 'package:habitr_tfg/data/classes/streak.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';

/// Clase que define el repositorio y sus métodos. Se puede hacer click para obtener una vista de detalle.
///
/// Al igual que en otros repositorios, tódos los métodos lanzan excepciones sin capturar, y por tanto han de estar en un bloque try - catch.
class UserRepository {
  /// Función que obtiene el perfil del usuario que nos representa a nosotros mismos.
  ///
  /// Retorna un Usuario.
  Future<User> getSelf() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    return this.getUser(supabase.auth.currentUser!.id);
  }

  /// Función que obtiene el perfil del usuario con ID [userId]
  ///
  /// Retorna un usuario.
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

  /// Función que cambia las flores del usuario actual a las marcadas por [flowers].
  ///
  /// No retorna nada.
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
