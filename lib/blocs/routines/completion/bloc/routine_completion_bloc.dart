import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

part 'routine_completion_event.dart';
part 'routine_completion_state.dart';

class RoutineCompletionBloc
    extends Bloc<RoutineCompletionEvent, RoutineCompletionState> {
  RoutineCompletionBloc() : super(RoutineCompletionInitial()) {
    on<AddRoutineCompletionEvent>(_onAddRoutineCompletion);
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
      print(routineResponse);
    } catch (e) {
      print(e);
    }
  }
}
