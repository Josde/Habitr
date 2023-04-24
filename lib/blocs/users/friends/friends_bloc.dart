import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<AcceptFriendRequestEvent>(_onAcceptFriend);
    on<DeclineFriendRequestEvent>(_onDeleteFriend);
  }

  void _onLoadFriends(
      LoadFriendsEvent event, Emitter<FriendsState> emit) async {
    print('_onLoadFriends');
    List<User> _friends = List<User>.empty(growable: true);
    List<User> _requests = List<User>.empty(growable: true);
    List<String> _friendRequestIds = List<String>.empty(growable: true);
    String? ourId;
    emit.call(FriendsLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emit.call(FriendsError(error: 'User is not logged in.'));
        return;
      }
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
      var friendRequestProfileResponse = await supabase
          .from('profiles')
          .select()
          .in_('uuid', _friendRequestIds);

      for (var row in friendRequestProfileResponse) {
        _requests.add(User.fromJson(row as Map));
      }

      emit.call(FriendsLoaded(friends: _friends, requests: _requests));
    } catch (e) {
      print(e);
    }
  }

  void _onDeleteFriend(
      DeclineFriendRequestEvent event, Emitter<FriendsState> emit) {
    var state = this.state;
    var declinedFriend = event.friend;
    List<User> newFriendRequests;
    if (state is FriendsLoaded) {
      newFriendRequests = state.requests!
          .where((element) => (element != declinedFriend))
          .toList();
      emit(FriendsLoaded(friends: state.friends, requests: newFriendRequests));
    }
  }

  void _onAcceptFriend(
      AcceptFriendRequestEvent event, Emitter<FriendsState> emit) {
    var state = this.state;
    var acceptedFriend = event.friend;
    List<User> newFriendRequests;
    List<User> newFriends = state.friends!;
    if (state is FriendsLoaded) {
      newFriendRequests = state.requests!
          .where((element) => (element != acceptedFriend))
          .toList();
      newFriends.add(acceptedFriend);
      emit(FriendsLoaded(friends: newFriends, requests: newFriendRequests));
    }
  }
}
