import 'dart:async';

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
    on<SendFriendRequestEvent>(_onSendFriendRequest);
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
      DeclineFriendRequestEvent event, Emitter<FriendsState> emit) async {
    var state = this.state;
    var declinedFriend = event.friend;
    List<User> newFriendRequests;
    if (state is FriendsLoaded) {
      try {
        await supabase.from('friendRequest').delete().or(
            'sent_by.eq.${declinedFriend.id},sent_to.eq.${declinedFriend.id}');
        newFriendRequests = List.from(
            state.requests!.where((element) => (element != declinedFriend)));
        emit(
            FriendsLoaded(friends: state.friends, requests: newFriendRequests));
      } catch (e) {
        print(e);
        emit.call(FriendsError(error: e.toString()));
      }
    }
  }

  void _onAcceptFriend(
      AcceptFriendRequestEvent event, Emitter<FriendsState> emit) async {
    var state = this.state;
    var acceptedFriend = event.friend;
    List<User> newFriendRequests;

    if (state is FriendsLoaded) {
      List<User> newFriends = List.from(state.friends!);
      try {
        await supabase.from('friendRequest').update({'accepted': true}).or(
            'sent_by.eq.${acceptedFriend.id},sent_to.eq.${acceptedFriend.id}');
        newFriendRequests = List.from(
            state.requests!.where((element) => (element != acceptedFriend)));
        newFriends.add(acceptedFriend);
        emit(FriendsLoaded(friends: newFriends, requests: newFriendRequests));
      } catch (e) {
        print(e);

        emit.call(FriendsError(error: e.toString()));
      }
    }
  }

  void _onSendFriendRequest(
      SendFriendRequestEvent event, Emitter<FriendsState> emit) async {
    var state = this.state;
    if (state is FriendsLoaded || state is FriendsError) {
      List<User> newFriendRequests = List.from(state.friends!);
      try {
        await supabase.from('friendRequest').insert({
          'sent_by': supabase.auth.currentUser!.id,
          'sent_to': event.friendId
        });
        // We have to do this here rather than passing an User object
        // due to RLS. We need to have an open friend request with someone so we can see them.
        var friendResponse = await supabase
            .from('profiles')
            .select()
            .eq('uuid', event.friendId)
            .single() as Map;
        User newFriend = User.fromJson(friendResponse);
        print('Sent friend request to ${newFriend.id}');
        newFriendRequests.add(newFriend);
        emit.call(
            FriendsLoaded(friends: state.friends, requests: newFriendRequests));
      } catch (e) {
        {
          print(e);
          emit.call(FriendsError(error: e.toString()));
        }
      }
    }
  }
}
