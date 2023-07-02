part of 'friends_bloc.dart';

/// {@category BLoC}
/// {@category GestionSocial}
@immutable
abstract class FriendsState extends Equatable {
  const FriendsState();
}

class FriendsInitial extends FriendsState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que los amigos están cargando
class FriendsLoading extends FriendsState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que los amigos y las solicitudes de amistad ya están cargadas
///
/// Atributos: [friends] (la lista de amigos), [requests] (la lista de peticiones de amistad)
class FriendsLoaded extends FriendsState {
  final List<User>? friends;
  final List<User>? requests;
  FriendsLoaded({this.friends, this.requests});

  @override
  List<Object?> get props => [friends, requests];
}

/// Estado que representa que ha habido un error al operar sobre los amigos
///
/// Atributos: [error] (el string que representa el error)
class FriendsError extends FriendsState {
  final String? error;
  FriendsError({this.error});

  @override
  List<Object?> get props => [error];
}
