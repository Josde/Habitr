part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent extends Equatable {}

/// Evento que desencadena la carga de posts
class LoadPostsEvent extends FeedEvent {
  @override
  List<Object?> get props => [];
}

/// Evento que desencadena el añadir un mensaje
///
/// Atributos: [post] (el mensaje a añadir)
class AddPostEvent extends FeedEvent {
  final Post post;

  AddPostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

/// Evento que desencadena el borrado de un mensaje
///
/// Atributos: [post] (el mensaje a borrar)
class DeletePostEvent extends FeedEvent {
  final Post post;

  DeletePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

/// Evento que desencadena darle like a un mensaje
///
/// Atributos: [post] (el mensaje al cual darle like)
class LikePostEvent extends FeedEvent {
  final Post post;

  LikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

/// Evento que desencadena darle like a un mensaje
///
/// Atributos: [post] (el mensaje al cual darle like)
class UnlikePostEvent extends FeedEvent {
  final Post post;

  UnlikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}
