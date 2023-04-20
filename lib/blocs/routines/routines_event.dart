part of 'routines_bloc.dart';

abstract class RoutinesEvent extends Equatable {
  const RoutinesEvent();
  @override
  List<Object> get props => [];
}

class LoadRoutinesEvent extends RoutinesEvent {}

class CreateRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const CreateRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

class ReadRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const ReadRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

class UpdateRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const UpdateRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

class DeleteRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const DeleteRoutineEvent({required this.routine});
  @override
  List<Object> get props => [routine];
}

class AddRepositoryRoutineEvent extends RoutinesEvent {
  final Routine routine;
  const AddRepositoryRoutineEvent({required this.routine});

  @override
  List<Object> get props => [routine];
}
