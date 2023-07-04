part of 'routines_bloc.dart';

/// {@category BLoC}
/// {@category GestionRutinas}
abstract class RoutinesState extends Equatable {
  const RoutinesState({this.routines = const []});
  final List<Routine> routines;
  @override
  List<Object> get props => [routines];
}

/// Estado que representa que se han cargado correctamente las rutinas
///
/// Atributos: routines (la lista de rutinas del usuario)
class RoutinesLoaded extends RoutinesState {
  final List<Routine> routines;

  const RoutinesLoaded({required this.routines});
  @override
  List<Object> get props => [routines];
}

// FIXME: mirar si esta clase es necesaria en la entrega final
class DetailRoutine extends RoutinesState {
  final Routine routine;

  const DetailRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}

/// Estado que representa que ha habido un error al cargar las rutinas
///
/// Atributos: [routines] (la lista de rutinas, si se tiene) y [error] (la explicación del error)
class RoutinesError extends RoutinesState {
  final List<Routine> routines;
  final String error;

  const RoutinesError({this.routines = const [], required this.error});

  @override
  List<Object> get props => [routines, error];
}
