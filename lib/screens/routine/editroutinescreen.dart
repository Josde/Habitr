import 'package:flutter/material.dart';
import 'package:habitr_tfg/models/routine.dart';
import 'package:habitr_tfg/models/routinesingleton.dart';
import 'package:habitr_tfg/utils/validator.dart';
import '../../enum/ActivityType.dart';

class EditRoutineScreen extends StatefulWidget {
  final int index;
  final bool? createRoutine;

  const EditRoutineScreen({Key? key, required this.index, this.createRoutine}) : super(key: key);


  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  ActivityType _currentType = ActivityType.Instant;
  String nombreRutina = "";
  String title = 'Create routine';
  int freqNotificaciones = 180;
  int timerLength = 0;
  Routine? rutinaActual = null;
  List<String> dropdownValues = ['Instant', 'Timer', 'Stopwatch'];
  String chosenDropdownValue = 'Instant';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (widget.createRoutine == null || widget.createRoutine != true) {
      rutinaActual = RoutineSingleton().listaRutinas[widget.index];
      nombreRutina = rutinaActual!.name;
      freqNotificaciones = rutinaActual!.delayBetweenNotis;
      _currentType = rutinaActual!.type;
      timerLength = rutinaActual!.timerLength;
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
                  validator: (value) {textNotEmptyValidator(value);},
                  onSaved: (value) {this.nombreRutina = value ?? '';},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Activity name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: '${freqNotificaciones.toString()}',
                  validator: (value) {numericInputValidator(value);},
                  onSaved: (value) {this.freqNotificaciones = (value == null ? 180 : int.parse(value));},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notification frequency",
                    suffixText: 'min',
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
                      chosenDropdownValue = newValue!;
                      print('ChosenDropdownValue = $chosenDropdownValue');
                      setState(() {});
                  },
                  onSaved: (String? value) {this._currentType = ActivityType.values[this.dropdownValues.indexOf(value!)];},
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: '${timerLength.toString()}',
                    validator: (value) {numericInputValidator(value);},
                    onSaved: (value) {this.timerLength = (value == null ? 10 : int.parse(value) * 60);},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: chosenDropdownValue == 'Timer' ? 'Activity length' : 'Duration goal',
                      suffixText: 'min',
                    ),
                  ),
                ),
                visible: (chosenDropdownValue == 'Timer' || chosenDropdownValue == 'Stopwatch') ? true : false,
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
                    if (this.widget.createRoutine == null || this.widget.createRoutine != true) {
                      setState(() {
                        RoutineSingleton().listaRutinas[widget.index] = nuevaRutina;
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

