import '../classes/routine.dart';

class RoutineSingleton {
  static final RoutineSingleton _singleton = RoutineSingleton._internal();
  List<Routine> listaRutinas = [];
  factory RoutineSingleton() {
    return _singleton;
  }

  RoutineSingleton._internal();
}