import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/validator.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';

class EditRoutineScreen extends StatefulWidget {
  final Routine? routine;


  const EditRoutineScreen({Key? key, this.routine}) : super(key: key);


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
  bool showLength = false;
  List<String> dropdownValues = ['Instant', 'Timer', 'Stopwatch'];
  String chosenDropdownValue = 'Instant';
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    bool createRoutine = (widget.routine == null);
    if (createRoutine == null || createRoutine != true) {
      rutinaActual = widget.routine;
      nombreRutina = rutinaActual!.name;
      //freqNotificaciones = rutinaActual!.;
      _currentType = rutinaActual!.type;
      timerLength = rutinaActual!.timerLength;
      chosenDropdownValue = dropdownValues[_currentType.index];
      title = 'Edit routine';
      if (_currentType == ActivityType.Stopwatch || _currentType == ActivityType.Timer) {
        showLength = true;
      } else {
        showLength = false;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$title",
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
              Padding( // Name
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: '$nombreRutina',
                  validator: (value) {return textNotEmptyValidator(value);},
                  onSaved: (value) {this.nombreRutina = value ?? '';},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Activity name",
                  ),
                ),
              ),
              Padding( // Notification frequency
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: '${freqNotificaciones.toString()}',
                  validator: (value) {return numericInputValidator(value);},
                  onSaved: (value) {this.freqNotificaciones = (value == null ? 180 : int.parse(value));},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notification frequency",
                    suffixText: 'min',
                  ),
                ),
              ),
              Padding( // Activity dropdown
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
                        chosenDropdownValue = newValue!;
                        if (chosenDropdownValue == 'Stopwatch' || chosenDropdownValue == 'Timer') {
                          showLength = true;
                        } else {
                          showLength = false;
                        }
                    });

                  },
                  autovalidateMode: AutovalidateMode.always,
                  onSaved: (String? value) {this._currentType = ActivityType.values[this.dropdownValues.indexOf(value!)];},
                ),
              ),
              Visibility(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: '${(timerLength ~/ 60).toString()}',
                      validator: (value) {return numericInputValidator(value);},
                      onSaved: (value) {timerLength = (value == null ? 10 : int.parse(value) * 60);},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: chosenDropdownValue == 'Timer' ? 'Activity length' : 'Duration goal',
                        suffixText: 'min',
                      ),
                    ),
                  ),
                visible: showLength,
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
                    //Routine nuevaRutina = Routine(this.nombreRutina, this.freqNotificaciones, this._currentType, this.timerLength);
                    bool hasEventBeenAdded = false;
                    if (widget.routine != null) {
                      //nuevaRutina.id = widget.routine!.id;
                      //BlocProvider.of<RoutinesBloc>(context, listen: false)
                      //    .add(UpdateRoutine(routine: nuevaRutina));
                        Navigator.pop(context);

                    } else {
                       //BlocProvider.of<RoutinesBloc>(context, listen: false)
                       //   .add(CreateRoutine(routine: nuevaRutina));
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

