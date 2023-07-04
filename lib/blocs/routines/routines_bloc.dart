/// {@category BLoC}
/// {@category GestionRutinas}
/// Paquete que implementa el BLoC de rutinas. Para obtener más información, mirar los detalles de las classes Event y State de este paquete.
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/repositories/routine/routine_repository.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/notifications.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  NotificationManager nm = NotificationManager();
  RoutineRepository repository = RoutineRepository();
  RoutinesBloc() : super(RoutinesLoaded(routines: [])) {
    on<LoadRoutinesEvent>(_onLoadRoutines);
    on<CreateRoutineEvent>(_onAddRoutine);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
    on<AddRepositoryRoutineEvent>(_onAddRepositoryRoutine);
    //on<ReadRoutine>(_onReadRoutine);
  }
  void _onLoadRoutines(
      LoadRoutinesEvent event, Emitter<RoutinesState> emit) async {
    print('_onLoadRoutines');

    List<Routine> _routines = List.empty(growable: true);
    try {
      //FIXME: Desde la linea 28 a la 42 tendría que hacerlo el repositorio

      _routines = await this.repository.getSelfRoutines();
      for (Routine r in _routines) {
        nm.addToQueue(r, process: false);
      }
      nm.processQueue();
      emit.call(RoutinesLoaded(routines: _routines));
    } catch (e) {
      print(e);
      emit.call(RoutinesError(routines: _routines, error: e.toString()));
    }
  }

  void _onAddRoutine(
      CreateRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    if (state is RoutinesLoaded) {
      //FIXME: Desde la linea 62 a la 86 tendría que hacerlo el repositorio
      try {
        Routine newR = await this.repository.addRoutine(r);
        nm.addToQueue(r);
        List<Routine> newRoutines = List.from(state.routines)..add(r);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit.call(RoutinesError(routines: state.routines, error: e.toString()));
      }
    }
  }

  void _onUpdateRoutine(
      UpdateRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    if (state is RoutinesLoaded) {
      //FIXME: Desde la linea 104 a la 12 tendría que hacerlo el repositorio
      try {
        Routine _newRoutine = await this.repository.updateRoutine(r);
        List<Routine> newRoutines = List.from(state.routines);
        int index = state.routines.indexWhere((Routine routine) {
          return routine.id == r.id;
        });

        if (index == -1) {
          // FAILSAFE
          newRoutines.add(event.routine);
        } else {
          newRoutines[index] = event.routine;
        }
        nm.removeRoutineNotification(r);
        nm.addToQueue(_newRoutine);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        RoutinesError(routines: state.routines, error: e.toString());
      }
    }
  }

  void _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    //FIXME: Desde la linea de abajo a la 196 tendría que hacerlo el repositorio
    if (state is RoutinesLoaded) {
      try {
        await this.repository.deleteRoutine(r);
        List<Routine> newRoutines = state.routines.toList().where((routine) {
          return routine.id != r.id;
        }).toList();
        nm.removeRoutineNotification(r);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit(RoutinesError(routines: state.routines, error: e.toString()));
      }
    }
  }

  void _onAddRepositoryRoutine(
      AddRepositoryRoutineEvent event, Emitter<RoutinesState> emit) async {
    // TODO: Add a date picker before calling this and also insert notification days of week and such.
    Routine r = event.routine;
    if (this.state is RoutinesLoaded) {
      try {
        await this.repository.addPublicRoutine(r);
        List<Routine> newRoutines = List.from(this.state.routines);
        newRoutines.add(r);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit(RoutinesError(routines: state.routines, error: e.toString()));
      }
    }
  }
}
