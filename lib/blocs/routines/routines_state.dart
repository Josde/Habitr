part of 'routines_bloc.dart';

abstract class RoutinesState extends Equatable {
  const RoutinesState();

}

class RoutinesLoaded extends RoutinesState {
  final List<Routine> routines;

  const RoutinesLoaded({required this.routines});
  @override
  List<Object> get props => [routines];
}

