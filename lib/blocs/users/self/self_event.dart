part of 'self_bloc.dart';

/// {@category BLoC}
/// {@category GestionUsuario}
@immutable
abstract class SelfEvent {}

/// Evento que desencadena el cargado del perfil del usuario que utiliza la aplicación
class LoadSelfEvent extends SelfEvent {}

/// Evento que desencadena una recarga del perfil del usuario
class ReloadSelfEvent extends SelfEvent {}

/// Evento que desencadena el cambio de flores del usuario, dentro de la gamificación
///
/// Atributos: [newFlowers] (lista de enteros que representan las nuevas flores que tendrá el usuario).
/// El valor del entero proviene de los valores de la enumeración desde el lado de Unity y C#.
class ChangeFlowersEvent extends SelfEvent {
  List<int> newFlowers;
  ChangeFlowersEvent({required this.newFlowers});
}
