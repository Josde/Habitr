part of 'feed_bloc.dart';

@immutable
abstract class FeedState extends Equatable {}

class FeedInitial extends FeedState {
  @override
  List<Object?> get props => [];
}

class FeedLoading extends FeedState {
  @override
  List<Object?> get props => [];
}

class FeedLoaded extends FeedState {
  final List<Post> posts;

  FeedLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}

class FeedError extends FeedState {
  final String error;

  FeedError({required this.error});
  @override
  List<Object?> get props => [error];
}
