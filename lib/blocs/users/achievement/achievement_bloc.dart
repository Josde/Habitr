/// {@category BLoC}
/// {@category GestionLogros}
/// Paquete que implementa el BLoC de logros. Para obtener más información, mirar los detalles de las classes Event y State de este paquete.
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/data/classes/achievements/all.dart';
import 'package:habitr_tfg/data/repositories/achievement_repository.dart';
import 'package:habitr_tfg/utils/constants.dart';
part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  AchievementRepository repository = AchievementRepository();
  AchievementBloc() : super(AchievementInitial()) {
    on<LoadAchievementsEvent>(_onLoadAchievements);
    on<CheckAchievementsEvent>(_onCheckAchievements);
  }

  FutureOr<void> _onLoadAchievements(
      LoadAchievementsEvent event, Emitter<AchievementState> emit) async {
    try {
      if (supabase.auth.currentUser?.id == null) {
        emit.call(AchievementError(error: "User is not logged in."));
        return;
      }
      var _achievements =
          await this.repository.getAchievements(supabase.auth.currentUser!.id);
      emit.call(AchievementLoaded(achievements: _achievements));
    } catch (e) {
      print(e);
      emit.call(AchievementError(error: e.toString()));
    }
  }

  FutureOr<void> _onCheckAchievements(
      event, Emitter<AchievementState> emit) async {
    try {
      if (supabase.auth.currentUser?.id == null ||
          !(state is AchievementLoaded)) {
        emit.call(AchievementError(
            error: "User is not logged in || state is not AchievementLoaded"));
        return;
      }

      List<Achievement> achievements =
          (this.state as AchievementLoaded).achievements;
      for (var achievement in achievementList.where(
        (element) => element.type == event.type,
      )) {
        print("Checking for achievement $achievement...");
        var dataType = achievement.shouldUnlockDataType;
        if (!achievement.isUnlocked &&
            dataType.isType(event.data) &&
            achievement.shouldUnlock(dataType.asType(event.data))) {
          print('Unlocking achievement: ${achievement}');
          achievement.isUnlocked = true;
          achievements.add(achievement);
          //FIXME: Desde la linea de abajo a la 61 tendría que hacerlo el repositorio
          await this.repository.unlockAchievement(achievement);
        }
      }
    } catch (e) {
      print(e);
      emit.call(AchievementError(error: e.toString()));
    }
  }
}
