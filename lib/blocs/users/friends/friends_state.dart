part of 'friends_bloc.dart';

@immutable
// TODO: Implement this properly in the future
abstract class FriendsState {
  List<User>? friends;
}

class FriendsInitial extends FriendsState {
  final List<User> friends = [User.debug('Amigo1'), User.debug('Amigo2')];
}

class FriendsLoading extends FriendsState {
  List<User>? friends;
}

class FriendsLoaded extends FriendsState {
  List<User>? friends;
}