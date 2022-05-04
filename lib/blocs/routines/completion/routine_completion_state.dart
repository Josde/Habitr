part of 'routine_completion_cubit.dart';

abstract class RoutineCompletionState extends Equatable {
  RoutineCompletionState();
  final List<RoutineCompletion> routineCompletions = [];
}

class RoutineCompletionInitial extends RoutineCompletionState {
  final List<RoutineCompletion> routineCompletions = [];
  @override
  List<Object> get props => [routineCompletions];
}
