import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

part 'routine_completion_event.dart';
part 'routine_completion_state.dart';

class RoutineCompletionBloc
    extends Bloc<RoutineCompletionEvent, RoutineCompletionState> {
  RoutineCompletionBloc() : super(RoutineCompletionInitial()) {
    on<LoadRoutineCompletionsEvent>(_onLoadRoutineCompletions);
    on<AddRoutineCompletionEvent>(_onAddRoutineCompletion);
  }

  void _onLoadRoutineCompletions(LoadRoutineCompletionsEvent event,
      Emitter<RoutineCompletionState> emit) async {
    List<RoutineCompletion> routineCompletions = List.empty(growable: true);
    try {
      if (supabase.auth.currentUser == null) {
        print('User is not logged in.');
        return;
      }
      final routineCompletionResponse = await supabase
          .from('routineCompletion')
          .select()
          .eq('profile_id', supabase.auth.currentUser!.id) as List;
      print(routineCompletionResponse);
      for (var rc in routineCompletionResponse) {
        routineCompletions.add(RoutineCompletion.fromJson(rc as Map));
      }
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
      if (supabase.auth.currentUser == null) {
        print('User is not logged in.');
        return;
      }
      final routineResponse = await supabase
          .from('routineCompletion')
          .insert({
            'routine_id': rc.routineId,
            'profile_id': supabase.auth.currentUser!.id,
            'time': rc.time.toIso8601String()
          })
          .select()
          .single() as Map;

      if (this.state is RoutineCompletionLoaded) {
        List<RoutineCompletion> newList =
            (this.state as RoutineCompletionLoaded).routineCompletions.toList();
        newList.add(rc);
        emit.call(RoutineCompletionLoaded(routineCompletions: newList));
      } else {
        emit.call(RoutineCompletionLoaded(routineCompletions: [rc]));
      }
      print(routineResponse);
    } catch (e) {
      print(e);
    }
  }
}
