part of 'routine_completion_bloc.dart';

abstract class RoutineCompletionState extends Equatable {
  const RoutineCompletionState();

  @override
  List<Object> get props => [];
}

class RoutineCompletionInitial extends RoutineCompletionState {}

/// Estado que define que se han cargado existosamente las rutinas completadas del usuario.
///
/// Atributos: [routineCompletions] (lista de rutinas completadas)
class RoutineCompletionLoaded extends RoutineCompletionState {
  List<RoutineCompletion> routineCompletions;

  RoutineCompletionLoaded({required this.routineCompletions});

  @override
  List<Object> get props => [routineCompletions];
}

/// Estado que define que ha habido un error a la hora de cargar las rutinas completadas.
///
/// Atributos: [error] (string que explica el error)
class RoutineCompletionError extends RoutineCompletionState {
  String error;

  RoutineCompletionError({required this.error});

  @override
  List<Object> get props => [error];
}
