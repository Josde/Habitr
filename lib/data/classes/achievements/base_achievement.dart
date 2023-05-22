import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/utils/typer.dart';

abstract class Achievement extends Equatable {
  final String name = "";
  final String description = "";
  bool isUnlocked = false;
  final int id = 0;
  final AchievementType type = AchievementType.Post;
  DateTime? unlockedAt;
  final Typer shouldUnlockDataType = Typer<Object>();
  bool shouldUnlock(dynamic data);

  set unlock(bool unlock) {
    isUnlocked = unlock;
  }

  @override
  List<Object?> get props =>
      [name, description, type, isUnlocked, shouldUnlock];
}
