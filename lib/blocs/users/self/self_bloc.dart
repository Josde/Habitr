/// {@category BLoC}
/// {@category GestionUsuario}
/// Paquete que implementa el BLoC del propio usuario. Para obtener más información, mirar los detalles de las classes Event y State de este paquete.
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/data/repositories/user_repository.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:meta/meta.dart';

import '../../../data/classes/streak.dart';

part 'self_event.dart';
part 'self_state.dart';

class SelfBloc extends Bloc<SelfEvent, SelfState> {
  UserRepository repository = UserRepository();
  SelfBloc() : super(SelfInitial()) {
    on<LoadSelfEvent>(_onLoadSelf);
    on<ReloadSelfEvent>(_onReloadSelf);
    on<ChangeFlowersEvent>(_onChangeFlowers);
  }

  void _onLoadSelf(SelfEvent event, Emitter<SelfState> emitter) async {
    print('_onLoadSelf');
    emitter.call(SelfLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emitter.call(SelfError('User is not logged in.'));
        return;
      }
      User myself = await this.repository.getSelf();
      emitter.call(SelfLoaded(self: myself, lastLoadTime: DateTime.now()));
    } catch (e) {
      print(e);
      emit.call(SelfError(e.toString()));
    }
  }

  void _onReloadSelf(ReloadSelfEvent event, Emitter<SelfState> emit) async {
    // Same as above, but keeps the previous state accessible meanwhile.
    emit.call(SelfReloading(self: this.state.self));
    try {
      if (supabase.auth.currentUser == null) {
        emit.call(SelfError('User is not logged in.'));
        return;
      }
      //FIXME: Desde la linea de abajo a la 71 tendría que hacerlo el repositorio
      User myself = await this.repository.getSelf();
      emit.call(SelfLoaded(self: myself, lastLoadTime: DateTime.now()));
    } catch (e) {
      print(e);
      emit.call(SelfError(e.toString()));
    }
  }

  void _onChangeFlowers(
      ChangeFlowersEvent event, Emitter<SelfState> emit) async {
    try {
      //FIXME: Desde la linea de abajo a la 87 tendría que hacerlo el repositorio
      if (supabase.auth.currentUser == null) {
        emit.call(SelfError('User is not logged in.'));
        return;
      }
      this.repository.changeFlowers(event.newFlowers);
      var myself = state.self;
      myself!.flowers = event.newFlowers;
      emit.call(SelfLoaded(self: myself, lastLoadTime: DateTime.now()));
    } catch (e) {
      print(e);
      emit.call(SelfError(e.toString()));
    }
  }
}
