part of 'friends_bloc.dart';

@immutable
// TODO: Implement this properly in the future
abstract class FriendsState {
  Map<User, List<User>>? friends;
}

class FriendsInitial extends FriendsState {
  final Map<User, List<User>> friends = {debugUser : [User.debug('Amigo1'), User.debug('Amigo2')]}; // i need to get SelfBloc into here somehow? whatever friends is not working for now
}

class FriendsLoading extends FriendsState {
  Map<User, List<User>>? friends;
}

class FriendsLoaded extends FriendsState {
  Map<User, List<User>>? friends;
}