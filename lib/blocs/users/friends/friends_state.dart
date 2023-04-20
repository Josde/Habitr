part of 'friends_bloc.dart';

@immutable
abstract class FriendsState extends Equatable {
  final List<User>? friends;
  final List<User>? requests;

  const FriendsState({this.friends, this.requests});
}

class FriendsInitial extends FriendsState {
  @override
  List<Object?> get props => [];
}

class FriendsLoading extends FriendsState {
  @override
  List<Object?> get props => [];
}

class FriendsLoaded extends FriendsState {
  final List<User>? friends;
  final List<User>? requests;
  FriendsLoaded({this.friends, this.requests});

  @override
  List<Object?> get props => [friends, requests];
}

class FriendsError extends FriendsState {
  final String? error;
  FriendsError({this.error});

  @override
  List<Object?> get props => [error];
}
