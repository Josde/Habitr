import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/achievements/achievement_type.dart';

abstract class Achievement extends Equatable {
  String name = "";
  String description = "";
  bool isUnlocked = false;
  AchievementType type = AchievementType.Post;
  bool shouldUnlock(dynamic data);

  @override
  List<Object?> get props =>
      [name, description, type, isUnlocked, shouldUnlock];
}
