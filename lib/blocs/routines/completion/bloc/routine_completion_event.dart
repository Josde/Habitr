part of 'routine_completion_bloc.dart';

abstract class RoutineCompletionEvent extends Equatable {
  const RoutineCompletionEvent();

  @override
  List<Object> get props => [];
}

/// Evento que desencadena la carga de rutinas completadas del usuario.
class LoadRoutineCompletionsEvent extends RoutineCompletionEvent {
  const LoadRoutineCompletionsEvent();

  @override
  List<Object> get props => [];
}

/// Evento que permite añadir una rutina completada al usuario.
///
/// Atributos: [rc] (la rutina completada que queremos añadir)
class AddRoutineCompletionEvent extends RoutineCompletionEvent {
  final RoutineCompletion rc;
  const AddRoutineCompletionEvent({required this.rc});
  @override
  List<Object> get props => [rc];
}
