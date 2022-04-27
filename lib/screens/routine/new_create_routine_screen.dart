import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/utils/validator.dart';

class NewCreateRoutineScreen extends StatefulWidget {
  const NewCreateRoutineScreen({Key? key}) : super(key: key);

  @override
  State<NewCreateRoutineScreen> createState() => _NewCreateRoutineScreenState();
}

class _NewCreateRoutineScreenState extends State<NewCreateRoutineScreen> {
  int _index = 0;
  Routine? _routine;
  ActivityType? _currentType = null;
  String nombreRutina = "";
  int freqNotificaciones = 3;
  int timerLength = 0;
  Routine? rutinaActual = null;
  TimeOfDay? notificationStartTime = TimeOfDay.now();
  bool notificationEnabled = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stepper(
          currentStep: _index,
          type: StepperType.horizontal,
          steps: getSteps(),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: onStepContinue,
                    child: _currentType == null? Text('CONTINUE', style: TextStyle(color: Theme.of(context).primaryColorDark)) : Text('CONTINUE'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _index == 0? Navigator.pop(context) : _index -= 1),
                    child: Text('CANCEL'),

                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
    void onStepContinue() {
    if (_index != getSteps().length - 1 && _currentType != null) {
      setState( () => _index += 1);
    } else if (_index == getSteps().length - 1) {
      Navigator.pop(context);
    }
  }
  List<Step> getSteps() {
    return [
      Step( //TODO: Disable continue on this step until you click a button.
        isActive: _index == 0,
        title: Text("Routine type"),
        state: _index > 0? StepState.complete : StepState.indexed,
        content: buildRoutineTypeChoiceScreen(context)),
      Step(isActive: _index == 1,
        title: Text('Routine data'),
        content: buildRoutineDataScreen(context))
    ];
  }

  Widget buildRoutineTypeChoiceScreen(BuildContext context) {
    return Column( // TODO: Make buttons reactive so they highlight whichever one you chose.
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => _currentType = ActivityType.Instant),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(30.0),
                      border: _currentType == ActivityType.Instant? Border.all(width: 3.0, color: Theme.of(context).iconTheme.color!) : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.alarm),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Instant routine'),
                          )],
                      )
                  ),
                )
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => _currentType = ActivityType.Timer),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(30.0),
                      border: _currentType == ActivityType.Timer? Border.all(width: 3.0, color: Theme.of(context).iconTheme.color!) : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.alarm),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Timer routine'),
                          )],
                      )
                  ),
                )
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => _currentType = ActivityType.Stopwatch),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(30.0),
                      border: _currentType == ActivityType.Stopwatch? Border.all(width: 3.0, color: Theme.of(context).iconTheme.color!) : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.alarm),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Stopwatch routine'),
                          )],
                      )
                  ),
                )
              )
            ),
          ),
        ],
    );
  }

  Widget buildRoutineDataScreen(BuildContext context) {
    return Form(
      child: Column(
          children: [
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
                Visibility(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: '${(timerLength ~/ 60).toString()}',
                        validator: (value) {return numericInputValidator(value);},
                        onSaved: (value) {timerLength = (value == null ? 10 : int.parse(value) * 60);},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _currentType == ActivityType.Timer ? 'Activity length' : 'Duration goal',
                          suffixText: 'min',
                        ),
                      ),
                    ),
                  visible: _currentType == ActivityType.Timer || _currentType == ActivityType.Stopwatch,
                ),
              Padding( padding: const EdgeInsets.all(8.0),
                  child: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold))
              ),
              Padding(padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Enabled', style: TextStyle(fontWeight: FontWeight.w600)),
                      Spacer(),
                      Checkbox(
                        activeColor: Theme.of(context).iconTheme.color,
                        onChanged: (
                        bool? value) { setState(() => notificationEnabled = value!); },
                        value: notificationEnabled,),
                    ]
                  ),
              ),
              Visibility(
                visible: notificationEnabled,
                maintainState: true,
                child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Notification start time', style: TextStyle(fontWeight: FontWeight.w600) ),
                    Spacer(),
                    ElevatedButton(child: Icon(Icons.access_alarm),
                      onPressed: () async => {
                        notificationStartTime = await showTimePicker(context: context, initialTime: TimeOfDay.now())},)

                  ],)
                ),
              ),
              Visibility(
                visible: notificationEnabled,
                maintainState: true,
                child: Padding( // Number of notifications
                  //TODO: Rework routine to actually use a number of notifications each 5 minutes
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: '${freqNotificaciones.toString()}',
                      validator: (value) {return numericInputValidator(value);},
                      onSaved: (value) {this.freqNotificaciones = (value == null ? 180 : int.parse(value));},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Number of notifications",
                        helperText: 'You will be notified every 5 minutes',
                      ),
                    ),
                  ),
              ),
          ]
      ),
    );
  }
}
