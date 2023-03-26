import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/utils/theming.dart';
import 'package:habitr_tfg/utils/validator.dart';

import '../../blocs/routines/routines_bloc.dart';

class NewCreateRoutineScreen extends StatefulWidget {
  const NewCreateRoutineScreen({Key? key, this.routine}) : super(key: key);
  final Routine? routine;
  @override
  State<NewCreateRoutineScreen> createState() => _NewCreateRoutineScreenState();
}

class _NewCreateRoutineScreenState extends State<NewCreateRoutineScreen> {
  int _index = 0;
  ActivityType? _currentType;
  String _routineName = "";
  int _numberOfNotifications = 3;
  int _timerLength = 0;
  TimeOfDay? _notificationStartTime = TimeOfDay.now();
  bool _notificationsEnabled = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.routine != null) {
      // modo de edición de rutina
      Routine r = widget.routine!;
      _index = 1;
      _routineName = r.name;
      _currentType = r.type;
      _notificationsEnabled = r.notificationsEnabled;
      _numberOfNotifications = r.numberOfNotifications;
      _timerLength = r.timerLength;
      _notificationStartTime = r.notificationStartTime;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stepper(
            currentStep: _index,
            type: StepperType.horizontal,
            steps: getSteps(),
            onStepContinue: _currentType == null ? null : onStepContinue,
            onStepCancel: () => (setState(
                () => _index == 0 ? Navigator.pop(context) : _index -= 1))),
      ),
    );
  }

  void onStepContinue() {
    if (_index != getSteps().length - 1 && _currentType != null) {
      setState(() => _index += 1);
    } else if (_index == getSteps().length - 1) {
      // Add null checks here to prevent crashing due to ! operator
      if (this._formKey.currentState!.validate()) {
        this._formKey.currentState!.save();
        Routine nuevaRutina = Routine(
            _routineName,
            _numberOfNotifications,
            _notificationStartTime!,
            _notificationsEnabled,
            _currentType!,
            _timerLength);
        if (widget.routine != null) {
          // Modo de edición
          nuevaRutina.id = widget.routine!.id;
          BlocProvider.of<RoutinesBloc>(context, listen: false)
              .add(UpdateRoutine(routine: nuevaRutina));
        } else {
          BlocProvider.of<RoutinesBloc>(context, listen: false)
              .add(CreateRoutine(routine: nuevaRutina));
        }
        Navigator.pop(context);
      }
    }
  }

  List<Step> getSteps() {
    return [
      Step(
          //TODO: Disable continue on this step until you click a button.
          isActive: _index == 0,
          title: Text("Routine type"),
          state: _index > 0 ? StepState.complete : StepState.indexed,
          content: buildRoutineTypeChoiceScreen(context)),
      Step(
          isActive: _index == 1,
          title: Text('Routine data'),
          content: buildRoutineDataScreen(context))
    ];
  }

  Widget buildRoutineTypeChoiceScreen(BuildContext context) {
    return Column(
      // TODO: Make buttons reactive so they highlight whichever one you chose.
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
                      border: _currentType == ActivityType.Instant
                          ? Border.all(
                              width: 3.0,
                              color: Theme.of(context).iconTheme.color!)
                          : null,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.alarm),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Instant',
                                      style: leadingText(context)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Example: Drink water',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ))),
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
                      border: _currentType == ActivityType.Timer
                          ? Border.all(
                              width: 3.0,
                              color: Theme.of(context).iconTheme.color!)
                          : null,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.alarm),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Timer',
                                      style: leadingText(context)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Example: Study 30 minutes.',
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () =>
                  setState(() => _currentType = ActivityType.Stopwatch),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(30.0),
                      border: _currentType == ActivityType.Stopwatch
                          ? Border.all(
                              width: 3.0,
                              color: Theme.of(context).iconTheme.color!)
                          : null,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.alarm),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Stopwatch',
                                      style: leadingText(context)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Example: Exercise until exhaustion',
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ))),
        ),
      ],
    );
  }

  Widget buildRoutineDataScreen(BuildContext context) {
    return Form(
      key: this._formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        Padding(
          // Name
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: '$_routineName',
            validator: (value) {
              return textNotEmptyValidator(value);
            },
            onSaved: (value) {
              this._routineName = value ?? '';
            },
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
              initialValue: '${(_timerLength ~/ 60).toString()}',
              validator: (value) {
                return numericInputValidator(value);
              },
              onSaved: (value) {
                this._timerLength =
                    (value == null ? 10 : int.parse(value) * 60);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: _currentType == ActivityType.Timer
                    ? 'Activity length'
                    : 'Duration goal',
                suffixText: 'min',
              ),
            ),
          ),
          visible: _currentType == ActivityType.Timer ||
              _currentType == ActivityType.Stopwatch,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Notifications',
                style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text('Enabled', style: TextStyle(fontWeight: FontWeight.w600)),
            Spacer(),
            Checkbox(
              activeColor: Theme.of(context).iconTheme.color,
              onChanged: (bool? value) {
                setState(() => this._notificationsEnabled = value!);
              },
              value: this._notificationsEnabled,
            ),
          ]),
        ),
        Visibility(
          visible: _notificationsEnabled,
          maintainState: true,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Notification start time',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Spacer(),
                  ElevatedButton(
                    child: Icon(Icons.access_alarm),
                    onPressed: () async => {
                      this._notificationStartTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now())
                    },
                  )
                ],
              )),
        ),
        Visibility(
          visible: _notificationsEnabled,
          maintainState: true,
          child: Padding(
            // Number of notifications
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: '${_numberOfNotifications.toString()}',
              validator: (value) {
                return numericInputValidator(value);
              },
              onSaved: (value) {
                this._numberOfNotifications =
                    (value == null ? 180 : int.parse(value));
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Number of notifications",
                helperText: 'You will be notified every 5 minutes',
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
