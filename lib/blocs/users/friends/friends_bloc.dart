/// {@category BLoC}
/// {@category GestionSocial}
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/data/repositories/friends_repository.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsRepository repository = FriendsRepository();
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

    emit.call(FriendsLoading());
    try {
      //FIXME: Desde la linea de abajo a la 44 tendría que hacerlo el repositorio, y quizas el 50 el repositorio de users
      var _response = await this.repository.getFriendsAndRequests();
      _friends = _response[0];
      _requests = _response[1];
      emit.call(FriendsLoaded(friends: _friends, requests: _requests));
    } catch (e) {
      print(e);
      emit.call(FriendsError(error: e.toString()));
    }
  }

  void _onDeleteFriend(
      DeclineFriendRequestEvent event, Emitter<FriendsState> emit) async {
    var state = this.state;
    var declinedFriend = event.friend;
    List<User> newFriendRequests;

    if (state is FriendsLoaded) {
      try {
        //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
        await this
            .repository
            .replyToFriendRequest(declinedFriend, accept: false);
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
        //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
        await this
            .repository
            .replyToFriendRequest(acceptedFriend, accept: true);
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
        //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio, y quizas la 124 por el repositorio de user.
        User newFriend =
            await this.repository.sendFriendRequest(event.friendId);
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
