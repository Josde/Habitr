part of 'friends_bloc.dart';

/// {@category BLoC}
/// {@category GestionSocial}
@immutable
abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
  @override
  List<Object> get props => [];
}

/// Evento que desencadena el cargado de los amigos del usuario
class LoadFriendsEvent extends FriendsEvent {}

/// Evento que desencadena aceptar la amistad de un usuario
///
/// Atributos: [friend] (el amigo al cual aceptar)
class AcceptFriendRequestEvent extends FriendsEvent {
  final User friend;

  const AcceptFriendRequestEvent({required this.friend});
  @override
  List<Object> get props => [friend];
}

/// Evento que desencadena rechazar la amistad de un usuario
///
/// Atributos: [friend] (el "amigo" al cual declinar)
class DeclineFriendRequestEvent extends FriendsEvent {
  final User friend;
  const DeclineFriendRequestEvent({required this.friend});
  @override
  List<Object> get props => [friend];
}

/// Evento que desencadena el enviar una solicitud de aimstad al usuario
///
/// Atributos: [friendId] (la ID del usuario al cual queremos mandarle la solicitud)
///
/// Se utiliza la ID dado que la seguridad de la aplicación no deja obtener el perfil de un usuario el cual no es nuestro amigo.
/// Por tanto, antes de que sea nuestro amigo, como mucho tendremos acceso a su ID.
class SendFriendRequestEvent extends FriendsEvent {
  final String friendId;

  const SendFriendRequestEvent({required this.friendId});

  @override
  List<Object> get props => [friendId];
}
