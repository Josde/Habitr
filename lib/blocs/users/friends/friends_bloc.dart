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
      final friendResponse = await supabase
          .from('friendRequest')
          .select()
          .or('sent_by.eq.${ourId},sent_to.eq.${ourId}')
          .eq('accepted', true) as List;
      print(friendResponse);
      for (Map record in friendResponse) {
        if (!(_friendsIds.contains(record['sent_by'])) &&
            record['sent_by'] != ourId) {
          _friendsIds.add(record['sent_by']);
        }
        if (!(_friendsIds.contains(record['sent_to'])) &&
            record['sent_to'] != ourId) {
          _friendsIds.add(record['sent_to']);
        }
      }
      print(_friendsIds);
      for (String id in _friendsIds) {
        final friend = await supabase
            .from('profiles')
            .select()
            .eq('uuid', id)
            .single() as Map;
        print(friend);
        _friends.add(User.fromJson(friend));
      }

      emit.call(FriendsLoaded(friends: _friends));
    } catch (e) {
      print(e);
    }
  }
}
