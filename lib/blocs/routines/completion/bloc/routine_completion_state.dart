part of 'routine_completion_bloc.dart';

abstract class RoutineCompletionState extends Equatable {
  const RoutineCompletionState();

  @override
  List<Object> get props => [];
}

class RoutineCompletionInitial extends RoutineCompletionState {}

class RoutineCompletionLoaded extends RoutineCompletionState {
  List<RoutineCompletion> routineCompletions;

  RoutineCompletionLoaded({required this.routineCompletions});

  @override
  List<Object> get props => [routineCompletions];
}

class RoutineCompletionError extends RoutineCompletionState {
  String error;

  RoutineCompletionError({required this.error});

  @override
  List<Object> get props => [error];
}
