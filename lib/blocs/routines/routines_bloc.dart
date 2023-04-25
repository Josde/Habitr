import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/converters/timeofdayconverter.dart';
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
        (routine['routine'] as Map).addAll({
          'notification_days_of_week': routine['notification_days_of_week'],
          'notification_time': (routine['notification_time']),
          'notification_enabled': routine['notification_enabled']
        } as Map<dynamic,
            dynamic>); // Removing this cast will make this snot work
        _routines.add(Routine.fromJson(routine['routine'] as Map));
        print(Routine.fromJson(routine['routine'] as Map));
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
        final profileRoutineResponse =
            await supabase.from('profileRoutine').insert({
          'routine_id': routineResponse['id'],
          'profile_id': supabase.auth.currentUser!.id,
          'notification_days_of_week': r.notificationDaysOfWeek,
          'notification_time': r.notificationTime.toIso8601String(),
          'notification_enabled': r.notificationsEnabled
        });
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
        try {
          final routineResponse = await supabase.from('routine').update({
            'name': r.name,
            'type': r.type.index,
            'timer_length': r.timerLength,
            'is_public': r.isPublic,
            'creator_id': supabase.auth.currentUser!.id
          }).eq('id', r.id);
        } catch (e) {
          //TODO: Separate this into 2 different functions, or improve it one for our own routines and one for online ones.
          print('Routine is not ours.');
        }

        final profileRoutineResponse =
            await supabase.from('profileRoutine').update({
          'routine_id': r.id,
          'profile_id': supabase.auth.currentUser!.id,
          'notification_days_of_week': r.notificationDaysOfWeek,
          'notification_time': r.notificationTime.toIso8601String(),
          'notification_enabled': r.notificationsEnabled
        }).eq('routine_id', r.id);
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
    // TODO: Add a date picker before calling this and also insert notification days of week and such.
    Routine r = event.routine;
    if (this.state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        await supabase.from('profileRoutine').insert(
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
