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
  List<String> dropdownValues = ['Instant', 'Timer', 'Stopwatch'];
  String chosenDropdownValue = 'Instant';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (this.createRoutine == null || this.createRoutine != true) {
      rutinaActual = RoutineSingleton().listaRutinas[index];
      nombreRutina = rutinaActual!.name;
      freqNotificaciones = rutinaActual!.delayBetweenNotis;
      _currentType = rutinaActual!.type;
      chosenDropdownValue = dropdownValues[_currentType.index];
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

        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: '$nombreRutina',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {this.nombreRutina = value ?? '';},
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
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                    }
                  return null;
                  },
                  onSaved: (value) {this.freqNotificaciones = (value == null ? 180 : int.parse(value));},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notification frequency",
                    suffixText: 'min',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  items: dropdownValues.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                  );
                  }).toList(),
                  value: chosenDropdownValue,
                  onChanged: (String? newValue) {
                      setState(() {
                      this.chosenDropdownValue = newValue!;
                      });
                  },
                  onSaved: (String? value) {this._currentType = ActivityType.values[this.dropdownValues.indexOf(value!)];},
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data is not correct.')),
                      );
                      return;
                    }
                    _formKey.currentState!.save();
                    Routine nuevaRutina = Routine(this.nombreRutina, this.freqNotificaciones, this._currentType);
                    if (this.createRoutine == null || this.createRoutine != true) {
                      setState(() {
                        RoutineSingleton().listaRutinas[index] = nuevaRutina;
                      });
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        RoutineSingleton().listaRutinas.add(nuevaRutina);
                      });
                      Navigator.pop(context);
                    }
                  },
                  backgroundColor: Colors.purple[300],
                  child: const Icon(Icons.check),),
              )
            ],
          ),
        )

      ),
    );
  }
}

