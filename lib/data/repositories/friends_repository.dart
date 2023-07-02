/// {@category Repositorio}
/// {@category GestionSocial}
/// Define el repositorio que permite operar y recuperar los amigos y solicitudes de amistad desde Supabase.
library;

import 'package:habitr_tfg/data/classes/user.dart';
import '../../../utils/constants.dart';

/// Clase que define el repositorio y sus métodos. Se puede hacer click para obtener una vista de detalle.
///
/// Al igual que en otros repositorios, tódos los métodos lanzan excepciones sin capturar, y por tanto han de estar en un bloque try - catch.
class FriendsRepository {
  /// Metodo que obtiene los amigos y las peticiones de amistad del usuario actual.
  ///
  /// Retorna una List<List<User>>>, en otras palabras, una lista de listas de usuarios,
  /// siendo una lista con 2 elementos de listas de usuarios,
  /// cuyo primer elemento es la lista de amigos del usuario
  /// y su segundo elemento es la lista de peticiones de amistad del usuario.
  ///
  /// Esto se debe a que la versión de Dart en la cual fue desarrollada el proyecto aún no tenía soporte para hacer un return de varias variables en la misma función.
  Future<List<List<User>>> getFriendsAndRequests() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    String? ourId;
    List<List<User>> _return = List<List<User>>.empty(growable: true);
    List<User> _friends = List<User>.empty(growable: true);
    List<User> _requests = List<User>.empty(growable: true);
    List<String> _friendRequestIds = List<String>.empty(growable: true);
    ourId = supabase.auth.currentUser!.id;

    final friendsResponse =
        await supabase.from('profiles').select().neq('uuid', ourId);

    var friendRequestResponse =
        await supabase.from('friendRequest').select().eq('accepted', false);

    for (var row in friendRequestResponse) {
      if (row['sent_by'] != ourId) _friendRequestIds.add(row['sent_by']);
      if (row['sent_to'] != ourId) _friendRequestIds.add(row['sent_to']);
    }

    for (var friend in friendsResponse) {
      if (!(_friendRequestIds.contains(friend['uuid'])))
        _friends.add(User.fromJson(friend as Map));
    }
    var friendRequestProfileResponse =
        await supabase.from('profiles').select().in_('uuid', _friendRequestIds);

    for (var row in friendRequestProfileResponse) {
      _requests.add(User.fromJson(row as Map));
    }
    _return.add(_friends);
    _return.add(_requests);
    return Future.value(_return);
  }

  /// Función que le envía una petición de amistad de el usuario actual al usuario con id [userId]
  ///
  /// Retorna un Usuario con todos los datos del usuario al cual fue enviada la solicitud.
  Future<User> sendFriendRequest(String userId) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase
        .from('friendRequest')
        .insert({'sent_by': supabase.auth.currentUser!.id, 'sent_to': userId});
    // We have to do this here rather than passing an User object
    // due to RLS. We need to have an open friend request with someone so we can see them.
    var friendResponse = await supabase
        .from('profiles')
        .select()
        .eq('uuid', userId)
        .single() as Map;
    User newFriend = User.fromJson(friendResponse);
    return Future.value(newFriend);
  }

  /// Responde a una petición amistad hecha por el usuario [u] para nosotros. Si [accept] es verdadero, se acepta la petición. En caso contrario, se rechaza.
  ///
  /// No retorna nada.
  Future<void> replyToFriendRequest(User u, {bool accept = false}) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    if (accept) {
      await supabase.from('friendRequest').update({'accepted': true}).or(
          'sent_by.eq.${u.id},sent_to.eq.${u.id}');
    } else {
      await supabase
          .from('friendRequest')
          .delete()
          .or('sent_by.eq.${u.id},sent_to.eq.${u.id}');
    }
  }
}
