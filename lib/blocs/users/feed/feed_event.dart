part of 'feed_bloc.dart';

/// {@category BLoC}
/// {@category GestionSocial}
@immutable
abstract class FeedEvent extends Equatable {}

class LoadPostsEvent extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class AddPostEvent extends FeedEvent {
  final Post post;

  AddPostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class DeletePostEvent extends FeedEvent {
  final Post post;

  DeletePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class LikePostEvent extends FeedEvent {
  final Post post;

  LikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class UnlikePostEvent extends FeedEvent {
  final Post post;

  UnlikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}
