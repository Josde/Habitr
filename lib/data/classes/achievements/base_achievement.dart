import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';
import 'package:habitr_tfg/utils/typer.dart';

abstract class Achievement extends Equatable {
  String name = "";
  String description = "";
  bool isUnlocked = false;
  int id = 0;
  AchievementType type = AchievementType.Post;
  Typer shouldUnlockDataType = Typer<Object>();
  bool shouldUnlock(dynamic data);

  void set unlock(bool unlock) {
    isUnlocked = unlock;
  }

  @override
  List<Object?> get props =>
      [name, description, type, isUnlocked, shouldUnlock];
}
