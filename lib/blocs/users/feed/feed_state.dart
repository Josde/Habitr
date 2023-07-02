part of 'feed_bloc.dart';

/// {@category BLoC}
/// {@category GestionSocial}
@immutable
abstract class FeedState extends Equatable {}

class FeedInitial extends FeedState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que el feed está cargando aún
class FeedLoading extends FeedState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que el feed ya está cargado
///
/// Atributos: [posts] (la lista de mensajes del feed)
class FeedLoaded extends FeedState {
  final List<Post> posts;

  FeedLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}

/// Atributo que representa que ha habido un error a la hora de cargar el feed
///
/// Atributos: [error] (string que representa el error que ha habido)
class FeedError extends FeedState {
  final String error;

  FeedError({required this.error});
  @override
  List<Object?> get props => [error];
}
