part of 'self_bloc.dart';

@immutable
abstract class SelfState {}

class SelfInitial extends SelfState {}

class SelfLoading extends SelfState {}

class SelfLoaded extends SelfState {
  final User? self;
  SelfLoaded(this.self);
}

class SelfError extends SelfState {
  final String? message;
  SelfError(this.message);
}
