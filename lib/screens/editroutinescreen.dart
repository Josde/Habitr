import 'package:flutter/material.dart';
import 'package:habitr_tfg/models/routine.dart';
import 'package:habitr_tfg/models/routinesingleton.dart';
import '../enum/ActivityType.dart';

class EditRoutineScreen extends StatefulWidget {
  final int index;
  final bool? createRoutine;
  EditRoutineScreen({required this.index, this.createRoutine});

  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState(index: index, createRoutine: createRoutine);
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final int index;
  final bool? createRoutine;
  ActivityType _currentType = ActivityType.Instant;
  String nombreRutina = "";
  String title = 'Create routine';
  int freqNotificaciones = 180;
  Routine? rutinaActual = null;
  _EditRoutineScreenState({required this.index, this.createRoutine});
  @override
  Widget build(BuildContext context) {
    if (this.createRoutine == null || this.createRoutine != true) {
      rutinaActual = RoutineSingleton().listaRutinas[index];
      nombreRutina = rutinaActual!.name;
      freqNotificaciones = rutinaActual!.delayBetweenNotis;
      _currentType = rutinaActual!.type;
      title = 'Edit routine';
    }
    //TODO: Use a Form + validation + submit saving data
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$title",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white24,
        ),

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '$nombreRutina',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Activity name",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '${freqNotificaciones.toString()}',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Notification frequency",
                  suffixText: 'm',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                if (this.createRoutine == null || this.createRoutine != true) {
                  //TODO: Implement this
                } else {
                  //TODO: ^
                }
              },
              backgroundColor: Colors.purple[300],
              child: const Icon(Icons.check),)
          ],
        )

      ),
    );
  }
}

