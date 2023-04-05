import 'package:bloc/bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriendsEvent>(_onLoadFriends);
  }

  void _onLoadFriends(
      LoadFriendsEvent event, Emitter<FriendsState> emit) async {
    List<User> _friends = List<User>.empty(growable: true);
    String? ourId;
    emit.call(FriendsLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emit.call(FriendsError(error: 'User is not logged in.'));
        return;
      }
      ourId = supabase.auth.currentUser!.id;
      //TODO: Change the query to select both friends and friend requests and properly separate them, so that we can use them for the friend request screen without making more queries.
      final friendsResponse = await supabase.from('profiles').select().neq(
          'uuid',
          ourId); // Thanks to RLS, any profile we can see that is not ours must be a friend.
      for (var friend in friendsResponse) {
        _friends.add(User.fromJson(friend as Map));
      }

      emit.call(FriendsLoaded(friends: _friends));
    } catch (e) {
      print(e);
    }
  }
}
