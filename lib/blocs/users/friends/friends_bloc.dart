//TODO: Implement this BLOC. Currently it is only constant values for debugging.
// FIXME: as it stands, this bloc currently means that every single user has the same friends
// so it should probably be refactored into a map of userID to list of friends
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<FriendsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

