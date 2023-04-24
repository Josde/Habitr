import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
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
      if (supabase.auth.currentUser == null) {
        emit.call(RoutinesError(error: 'User is not logged in.'));
        return;
      }
      final routinesResponse = await supabase
          .from('profileRoutine')
          .select('*, routine!inner(*)') as List;
      for (var routine in routinesResponse) {
        print(routine);
        _routines.add(Routine.fromJson(routine['routine'] as Map));
      }
      emit.call(RoutinesLoaded(routines: _routines));
    } catch (e) {
      print(e);
      emit.call(RoutinesError(error: e.toString()));
    }
  }

  void _onAddRoutine(
      CreateRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    if (state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        final routineResponse = await supabase
            .from('routine')
            .insert({
              'name': r.name,
              'type': r.type.index,
              'timer_length': r.timerLength,
              'is_public': r.isPublic,
              'creator_id': supabase.auth.currentUser!.id
            })
            .select()
            .single() as Map;
        print(routineResponse);
        r.id = routineResponse['id'];
        List<Routine> newRoutines = List.from(state.routines)..add(r);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit.call(RoutinesError(error: e.toString()));
      }
    }
  }

  void _onUpdateRoutine(
      UpdateRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    if (state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        final routineResponse = await supabase
            .from('routine')
            .update({
              'name': r.name,
              'type': r.type.index,
              'timer_length': r.timerLength,
              'is_public': r.isPublic,
              'creator_id': supabase.auth.currentUser!.id
            })
            .eq('id', r.id)
            .select()
            .single() as Map;
        print(routineResponse);
        List<Routine> newRoutines = state.routines;
        int index = state.routines.indexWhere((Routine r) {
          return r.id == event.routine.id;
        });
        if (index == -1) {
          // FAILSAFE
          newRoutines.add(event.routine);
        } else {
          newRoutines[index] = event.routine;
        }
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        RoutinesError(error: e.toString());
      }
    }
  }

  void _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutinesState> emit) async {
    final state = this.state;
    Routine r = event.routine;
    if (state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        final routineResponse = await supabase
            .from(
                'profileRoutine') //TODO: Delete stray routines if no references are left ?
            .delete()
            .eq('routine_id', r.id)
            .select()
            .single() as Map;
        print(routineResponse);
        List<Routine> newRoutines = state.routines.where((routine) {
          return routine.id != r.id;
        }).toList();
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit(RoutinesError(error: e.toString()));
      }
    }
  }

  void _onAddRepositoryRoutine(
      AddRepositoryRoutineEvent event, Emitter<RoutinesState> emit) async {
    Routine r = event.routine;
    if (this.state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        final routineResponse = await supabase.from('profileRoutine').insert(
            {'profile_id': supabase.auth.currentUser!.id, 'routine_id': r.id});
        List<Routine> newRoutines = List.from(this.state.routines);
        newRoutines.add(r);
        emit(RoutinesLoaded(routines: newRoutines));
      } catch (e) {
        print(e);
        emit(RoutinesError(error: e.toString()));
      }
    }
  }
}
