import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  RoutinesBloc() : super(RoutinesLoaded(routines: RoutineSingleton().listaRutinas)) {
    on<LoadRoutines>(_onLoadRoutines);
    on<CreateRoutine>(_onAddRoutine);
    on<UpdateRoutine>(_onUpdateRoutine);
    on<DeleteRoutine>(_onDeleteRoutine);

  }

  void _onLoadRoutines(LoadRoutines event, Emitter<RoutinesState> emit) {
    emit(RoutinesLoaded(routines: event.routines));
  }


  void _onAddRoutine(CreateRoutine event, Emitter<RoutinesState> emit) {
    final state = this.state;
    if (state is RoutinesLoaded) {
      emit(RoutinesLoaded(routines: List.from(state.routines)..add(event.routine)));
    }
  }

  void _onUpdateRoutine(UpdateRoutine event, Emitter<RoutinesState> emit) {
    final state = this.state;
    if (state is RoutinesLoaded) {
      List<Routine> newRoutines = state.routines;
      int index = state.routines.indexWhere((Routine r) {return r.id == event.routine.id;});
      if (index == -1) {
        newRoutines.add(event.routine);
      } else {
        newRoutines[index] = event.routine;
      }
      emit(RoutinesLoaded(routines: newRoutines));
    }
  }

  void _onDeleteRoutine(DeleteRoutine event, Emitter<RoutinesState> emit) {
    final state = this.state;
    if (state is RoutinesLoaded) {
      List<Routine> newRoutines = state.routines.where((routine) {
        return routine.name != event.routine.name;
      }).toList();
      emit(RoutinesLoaded(routines: newRoutines));
    }
  }
}
