/// {@category BLoC}
/// {@category GestionRutinas}
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/data/repositories/routine/routine_completion_repository.dart';
import 'package:habitr_tfg/utils/constants.dart';

part 'routine_completion_event.dart';
part 'routine_completion_state.dart';

class RoutineCompletionBloc
    extends Bloc<RoutineCompletionEvent, RoutineCompletionState> {
  RoutineCompletionRepository repository = RoutineCompletionRepository();
  RoutineCompletionBloc() : super(RoutineCompletionInitial()) {
    on<LoadRoutineCompletionsEvent>(_onLoadRoutineCompletions);
    on<AddRoutineCompletionEvent>(_onAddRoutineCompletion);
  }

  void _onLoadRoutineCompletions(LoadRoutineCompletionsEvent event,
      Emitter<RoutineCompletionState> emit) async {
    List<RoutineCompletion> routineCompletions = List.empty(growable: true);
    try {
      routineCompletions = await this.repository.getSelfRoutineCompletions();
      emit.call(
          RoutineCompletionLoaded(routineCompletions: routineCompletions));
    } catch (e) {
      print(e);
      emit.call((RoutineCompletionError(error: e.toString())));
    }
  }

  void _onAddRoutineCompletion(AddRoutineCompletionEvent event,
      Emitter<RoutineCompletionState> emit) async {
    RoutineCompletion rc = event.rc;
    try {
      await this.repository.addRoutineCompletion(rc);
      if (this.state is RoutineCompletionLoaded) {
        List<RoutineCompletion> newList =
            (this.state as RoutineCompletionLoaded).routineCompletions.toList();
        newList.add(rc);
        emit.call(RoutineCompletionLoaded(routineCompletions: newList));
      } else {
        emit.call(RoutineCompletionLoaded(routineCompletions: [rc]));
      }
    } catch (e) {
      print(e);
      emit.call(RoutineCompletionError(error: e.toString()));
    }
  }
}
