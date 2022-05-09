import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';

part 'routine_completion_state.dart';

class RoutineCompletionCubit extends Cubit<RoutineCompletionState> {
  RoutineCompletionCubit() : super(RoutineCompletionInitial());
  void add(RoutineCompletion newCompletion) {
    state.routineCompletions.add(newCompletion);
    print("Adding routine completion at ${newCompletion.time}. Completions: ${state.routineCompletions.length}");
    emit(state);
  }
}
