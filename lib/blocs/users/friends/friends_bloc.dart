//TODO: Implement this BLOC. Currently it is only constant values for debugging.
// so it should probably be refactored into a map of userID to list of friends

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<FriendsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void _onLoadFriends(
      LoadFriendsEvent event, Emitter<FriendsState> emit) async {
    List<User> _friends = List<User>.empty(growable: true);
    List<String> _friendsIds = List<String>.empty(growable: true);
    String? ourId;
    emit.call(FriendsLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emit.call(FriendsError(error: 'User is not logged in.'));
        return;
      }
      ourId = supabase.auth.currentUser!.id;
      //TODO: Change the query to select both friends and friend requests and properly separate them.
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
