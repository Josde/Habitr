import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  RoutinesBloc() : super(RoutinesLoaded(routines: [])) {
    on<LoadRoutines>(_onLoadRoutines);
    on<CreateRoutine>(_onAddRoutine);
    on<UpdateRoutine>(_onUpdateRoutine);
    on<DeleteRoutine>(_onDeleteRoutine);
    //on<ReadRoutine>(_onReadRoutine);


  }

  void _onLoadRoutines(LoadRoutines event, Emitter<RoutinesState> emit) {
    emit(RoutinesLoaded(routines: event.routines));
  }


  void _onAddRoutine(CreateRoutine event, Emitter<RoutinesState> emit) {
    final state = this.state;
    if (state is RoutinesLoaded) {
      List<Routine> newRoutines = List.from(state.routines)..add(event.routine);
      emit(RoutinesLoaded(routines: newRoutines));
    }
  }

  void _onUpdateRoutine(UpdateRoutine event, Emitter<RoutinesState> emit) {
    final state = this.state;
    if (state is RoutinesLoaded) {
      List<Routine> newRoutines = state.routines;
      int index = state.routines.indexWhere((Routine r) {return r.id == event.routine.id;});
      if (index == -1) { // FAILSAFE
        newRoutines.add(event.routine);
      } else {
        newRoutines[index] = event.routine;
      }
      emit(RoutinesLoaded(routines: newRoutines));
    }
  }

  void _onDeleteRoutine(DeleteRoutine event, Emitter<RoutinesState> emit) {
    // FIXME: No estamos borrando el archivo, asi que en el proximo inicio volvera a existir.
    final state = this.state;
    if (state is RoutinesLoaded) {
      List<Routine> newRoutines = state.routines.where((routine) {
        return routine.id != event.routine.id;
      }).toList();
      emit(RoutinesLoaded(routines: newRoutines));
    }

  }
}
