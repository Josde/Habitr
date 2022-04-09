part of 'routines_bloc.dart';

abstract class RoutinesEvent extends Equatable {
  const RoutinesEvent();
  @override
  List<Object> get props => [];
}

class LoadRoutines extends RoutinesEvent {
  final List<Routine> routines;
  const LoadRoutines({required this.routines});
  @override
  List<Object> get props => [routines];
}

class CreateRoutine extends RoutinesEvent {
  final Routine routine;
  const CreateRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}
class ReadRoutine extends RoutinesEvent {
  final Routine routine;
  const ReadRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}
class UpdateRoutine extends RoutinesEvent {
  final Routine routine;
  const UpdateRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}
class DeleteRoutine extends RoutinesEvent {
  final Routine routine;
  const DeleteRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}
