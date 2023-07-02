part of 'routines_bloc.dart';

abstract class RoutinesEvent extends Equatable {
  const RoutinesEvent();
  @override
  List<Object> get props => [];
}

class LoadRoutinesEvent extends RoutinesEvent {}

/// Evento que desencadena la creación de una rutina
///
/// Atributos: routine (el objeto Rutina a añadir a la lista)
class CreateRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const CreateRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

/// Evento que desencadena la actualización de una rutina ya existente
///
/// Atributos: routine (la rutina con el contenido nuevo)
class UpdateRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const UpdateRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

/// Evento que desencadena el borrado de una rutina
///
/// Atributos: [routine] (la rutina a borrar)
class DeleteRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const DeleteRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

/// Evento que desencadena el añadir una rutina que es pública
///
/// Atributos: [routine] (la rutina a añadir)
class AddRepositoryRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const AddRepositoryRoutineEvent({required this.routine});

  @override
  List<Object> get props => [routine];
}
