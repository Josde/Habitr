/// {@category GestionLogros}
/// {@category Datos}
library;

import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/utils/typer.dart';

abstract class Achievement extends Equatable {
  final String name = "";
  final String description = "";
  bool isUnlocked = false;

  /// La ID del logro en la BBDD. Ha de ir hardcodeada en el archivo que define el logro.
  final int id = 0;
  final AchievementType type = AchievementType.Post;
  DateTime? unlockedAt;

  /// Explica el tipo de datos que hay que pasarle a la función shouldUnlock
  final Typer shouldUnlockDataType = Typer<Object>();

  /// Define bajo que condiciones se ha de desbloquear el logro
  bool shouldUnlock(dynamic data);

  set unlock(bool unlock) {
    isUnlocked = unlock;
  }

  @override
  List<Object?> get props =>
      [name, description, type, isUnlocked, shouldUnlock];
}
