import 'package:habitr_tfg/data/classes/user.dart';
import '../../../utils/constants.dart';

// IMPORTANT: Todas las funciones de todas los repositorios requieren ser try / catch-adas.
class FriendsRepository {
  Future<List<List<User>>> getFriendsAndRequests() async {
    // Dart 3.0 introduce soporte para varios returns a la vez, en vez de usar
    // una lista de listas. Sin embargo, los modulos que utilizo no me dejan cambiar aún.
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
