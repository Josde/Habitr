part of 'friends_bloc.dart';

@immutable
abstract class FriendsState {
  final List<User>? friends;
  final List<User>? requests;

  const FriendsState({this.friends, this.requests});
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<User>? friends;
  final List<User>? requests;
  FriendsLoaded({this.friends, this.requests});
}

class FriendsError extends FriendsState {
  final String? error;
  FriendsError({this.error});
}
