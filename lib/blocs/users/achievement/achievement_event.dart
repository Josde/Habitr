part of 'achievement_bloc.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object> get props => [];
}

/// Evento que desencadena el cargar los logros que tiene el usuario.
class LoadAchievementsEvent extends AchievementEvent {}

/// Evento que desencadena el comprobar si el usuario ha obtenido un nuevo logro.
///
/// Atributos: [type] (el tipo de logros que queremos comprobar) y [data] (los datos relevantes para comprobar si el usuario ha desbloqueado los logros)
///
/// Se ha de pasar el objeto Type porque este evento permite comprobar cualquier tipo de evento, habiendo por tanto polimorfismo.
/// Para entender mejor la implementación, se recomienda mirar en el paquete Achievement.

class CheckAchievementsEvent extends AchievementEvent {
  final dynamic data;
  final AchievementType type;

  CheckAchievementsEvent({required this.data, required this.type});
  @override
  List<Object> get props => [data, type];
}
