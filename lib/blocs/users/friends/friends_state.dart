part of 'friends_bloc.dart';

@immutable
// TODO: Implement this properly in the future
abstract class FriendsState {
  List<User>? friends;
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  List<User>? friends;
  FriendsLoaded({this.friends});
}

class FriendsError extends FriendsState {
  String? error;
  FriendsError({this.error});
}
