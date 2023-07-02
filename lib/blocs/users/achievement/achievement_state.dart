part of 'achievement_bloc.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

/// Estado que representa que los logros han sido cargados correctamente
///
/// Atributos: [achievements] (la lista de logros desbloqueados del usuario)
class AchievementLoaded extends AchievementState {
  AchievementLoaded({required this.achievements});
  List<Achievement> achievements;
  @override
  List<Object> get props => [achievements];
}

/// Estado que representa que ha habido un error al operar con logros
///
/// Atributos: [error] (string que representa el fallo)
class AchievementError extends AchievementState {
  AchievementError({required this.error});
  String error;
  @override
  List<String> get props => [error];
}
