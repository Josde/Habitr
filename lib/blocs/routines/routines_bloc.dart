import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/notifications.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  late NotificationManager nm;
  RoutinesBloc() : super(RoutinesLoaded(routines: [])) {
    on<LoadRoutinesEvent>(_onLoadRoutines);
    on<CreateRoutineEvent>(_onAddRoutine);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
    on<AddRepositoryRoutineEvent>(_onAddRepositoryRoutine);
    this.nm = NotificationManager();
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
      for (var response in routinesResponse) {
        (response['routine'] as Map).addAll({
          'notification_days_of_week': response['notification_days_of_week'],
          'notification_time': (response['notification_time']),
          'notification_enabled': response['notification_enabled']
        }); // Removing this cast will make this snot work
        Routine r = Routine.fromJson(response['routine'] as Map);
        print(r);
        _routines.add(r);
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
              'creator_id': supabase.auth.currentUser!.id,
              'icon': r.icon
            })
            .select()
            .single() as Map;
        r.id = routineResponse['id'];
        final profileRoutineResponse =
            await supabase.from('profileRoutine').insert({
          'routine_id': r.id,
          'profile_id': supabase.auth.currentUser!.id,
          'notification_days_of_week': r.notificationDaysOfWeek,
          'notification_time': r.notificationTime.toIso8601String(),
          'notification_enabled': r.notificationsEnabled,
        });
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
    int? _newRoutineId = r.id;
    if (state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        if (r.creatorId == supabase.auth.currentUser!.id) {
          final routineResponse = await supabase
              .from('routine')
              .update({
                'name': r.name,
                'type': r.type.index,
                'timer_length': r.timerLength,
                'is_public': r.isPublic,
                'creator_id': supabase.auth.currentUser!.id,
                'icon': r.icon
              })
              .eq('id', r.id)
              .select()
              .single();
          print(routineResponse);
        } else {
          final routineResponse = await supabase
              .from('routine')
              .insert({
                'name': r.name,
                'type': r.type.index,
                'timer_length': r.timerLength,
                'is_public': r.isPublic,
                'creator_id': supabase.auth.currentUser!.id,
                'icon': r.icon
              })
              .select()
              .single() as Map;
          print(routineResponse);
          _newRoutineId = routineResponse['id'];
        }

        final profileRoutineResponse =
            await supabase.from('profileRoutine').update({
          'routine_id': _newRoutineId,
          'profile_id': supabase.auth.currentUser!.id,
          'notification_days_of_week': r.notificationDaysOfWeek,
          'notification_time': r.notificationTime.toIso8601String(),
          'notification_enabled': r.notificationsEnabled,
        }).eq('routine_id', r.id);
        List<Routine> newRoutines = List.from(state.routines);
        int index = state.routines.indexWhere((Routine r) {
          return r.id == event.routine.id;
        });

        if (index == -1) {
          // FAILSAFE
          newRoutines.add(event.routine);
        } else {
          newRoutines[index] = event.routine;
        }
        nm.removeRoutineNotification(r);
        nm.addToQueue(r);
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
    if (state is RoutinesLoaded) {
      try {
        if (supabase.auth.currentUser == null) {
          emit.call(RoutinesError(error: 'User is not logged in.'));
          return;
        }
        final profileRoutineResponse = await supabase
            .from('profileRoutine')
            .delete()
            .eq('routine_id', r.id)
            .select()
            .single() as Map;
        if (!r.isPublic ||
            (r.isPublic && r.creatorId == supabase.auth.currentUser!.id)) {
          final routineResponse = await supabase
              .from('routine')
              .delete()
              .eq('id', r.id)
              .select()
              .single();
          print(routineResponse);
        }
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
        emit(RoutinesError(routines: state.routines, error: e.toString()));
      }
    }
  }
}
