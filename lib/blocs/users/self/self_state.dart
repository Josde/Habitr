part of 'self_bloc.dart';

@immutable
abstract class SelfState {
  final User? self;

  const SelfState({this.self});
}

class SelfInitial extends SelfState {}

class SelfLoading extends SelfState {}

class SelfLoaded extends SelfState {
  final User? self;
  SelfLoaded({required this.self});
}

class SelfError extends SelfState {
  final String? message;
  SelfError(this.message);
}
