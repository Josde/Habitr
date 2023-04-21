part of 'self_bloc.dart';

@immutable
abstract class SelfState extends Equatable {
  final User? self;

  const SelfState({this.self});
}

class SelfInitial extends SelfState {
  @override
  List<Object?> get props => [];
}

class SelfLoading extends SelfState {
  @override
  List<Object?> get props => [];
}

class SelfLoaded extends SelfState {
  final User? self;
  final DateTime lastLoadTime;
  SelfLoaded({required this.self, required this.lastLoadTime});

  @override
  List<Object?> get props => [self, lastLoadTime];
}

class SelfReloading extends SelfState {
  final User? self;

  SelfReloading({required this.self});

  @override
  List<Object?> get props => [self];
}

class SelfError extends SelfState {
  final String? message;
  SelfError(this.message);

  @override
  List<Object?> get props => [message];
}
