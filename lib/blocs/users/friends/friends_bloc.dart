//TODO: Implement this BLOC. Currently it is only constant values for debugging.
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:meta/meta.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<FriendsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

