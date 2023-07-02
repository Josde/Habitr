part of 'friends_bloc.dart';

/// {@category BLoC}
/// {@category GestionSocial}
@immutable
abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
  @override
  List<Object> get props => [];
}

class LoadFriendsEvent extends FriendsEvent {}

class AcceptFriendRequestEvent extends FriendsEvent {
  final User friend;

  const AcceptFriendRequestEvent({required this.friend});
  @override
  List<Object> get props => [friend];
}

class DeclineFriendRequestEvent extends FriendsEvent {
  final User friend;
  const DeclineFriendRequestEvent({required this.friend});
  @override
  List<Object> get props => [friend];
}

class SendFriendRequestEvent extends FriendsEvent {
  final String friendId;

  const SendFriendRequestEvent({required this.friendId});

  @override
  List<Object> get props => [friendId];
}
