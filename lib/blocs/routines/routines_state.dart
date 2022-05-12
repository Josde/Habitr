part of 'routines_bloc.dart';

abstract class RoutinesState extends Equatable {
  const RoutinesState({this.routines = const []});
  final List<Routine> routines;
}

class RoutinesLoaded extends RoutinesState {
  final List<Routine> routines;

  const RoutinesLoaded({required this.routines});
  @override
  List<Object> get props => [routines];
}

class DetailRoutine extends RoutinesState {
  final Routine routine;

  const DetailRoutine({required this.routine});
  @override
  List<Object> get props => [routine];
}

