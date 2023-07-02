part of 'self_bloc.dart';

/// {@category BLoC}
/// {@category GestionUsuario}
@immutable
abstract class SelfEvent {}

class LoadSelfEvent extends SelfEvent {}

class ReloadSelfEvent extends SelfEvent {}

class ChangeFlowersEvent extends SelfEvent {
  List<int> newFlowers;
  ChangeFlowersEvent({required this.newFlowers});
}
