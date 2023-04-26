part of 'routine_completion_bloc.dart';

abstract class RoutineCompletionEvent extends Equatable {
  const RoutineCompletionEvent();

  @override
  List<Object> get props => [];
}

class LoadRoutineCompletionsEvent extends RoutineCompletionEvent {
  const LoadRoutineCompletionsEvent();

  @override
  List<Object> get props => [];
}

class AddRoutineCompletionEvent extends RoutineCompletionEvent {
  final RoutineCompletion rc;
  const AddRoutineCompletionEvent({required this.rc});
  @override
  List<Object> get props => [rc];
}
