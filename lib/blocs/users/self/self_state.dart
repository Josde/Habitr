part of 'self_bloc.dart';

/// {@category BLoC}
/// {@category GestionUsuario}
@immutable
abstract class SelfState extends Equatable {
  final User? self;

  const SelfState({this.self});
}

class SelfInitial extends SelfState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que el usuario está cargando.
class SelfLoading extends SelfState {
  @override
  List<Object?> get props => [];
}

/// Estado que representa que el usuario se ha cargado correctamente.
///
/// Atributos: [self] (el Usuario que nos representa a nosotros mismos) y lastLoadTime (el tiempo de última carga, para saber cuando actualizarlo)
class SelfLoaded extends SelfState {
  final User? self;
  final DateTime lastLoadTime;
  SelfLoaded({required this.self, required this.lastLoadTime});

  @override
  List<Object?> get props => [self, lastLoadTime];
}

/// Estado que representa al usuario durante un proceso de recarga de datos
///
/// Atributos: [self] (el usuario que nos representa a nosotros mismos)
class SelfReloading extends SelfState {
  final User? self;

  SelfReloading({required this.self});

  @override
  List<Object?> get props => [self];
}

/// Estado que representa que ha habido un error a la hora de cargar o operar con el usuario.
///
/// Atributos: [message] (el mensaje de error)
class SelfError extends SelfState {
  final String? message;
  SelfError(this.message);

  @override
  List<Object?> get props => [message];
}
