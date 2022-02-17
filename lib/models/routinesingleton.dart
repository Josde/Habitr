import 'package:flutter/material.dart';
import '../enum/ActivityType.dart';
import 'routine.dart';

class RoutineSingleton {
  static final RoutineSingleton _singleton = RoutineSingleton._internal();
  List<Routine> listaRutinas = [];
  factory RoutineSingleton() {
    return _singleton;
  }

  RoutineSingleton._internal();
}