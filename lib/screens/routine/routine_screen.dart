import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/routine/edit_routine_screen.dart';
import 'package:habitr_tfg/screens/routine/routine_detail_screen.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  RoutineSingleton rs = RoutineSingleton();

  @override
  Widget build(BuildContext context)  {
    return BlocBuilder<RoutinesBloc, RoutinesState>(
    builder: (context, state) {
      if (state is RoutinesLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Routines",
          ),
          backgroundColor: Colors.deepPurple,

        ),
        body: Center(
          child:
            ListView.builder(
              itemCount: state.routines.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                      height: 50,
                      color: Theme.of(context).primaryColorDark,
                      child: Row(children: [Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('${state.routines[index].name}', style: TextStyle(color: Colors.white))),
                                            Spacer(),
                                            IconButton(onPressed: () { // Edit button
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return BlocProvider.value(
                                                    value: BlocProvider.of<RoutinesBloc>(context),
                                                    child: EditRoutineScreen(routine: state.routines[index]),
                                              );
                                              }));
                                            },
                                              icon: Icon(Icons.edit),
                                              color: Theme.of(context).iconTheme.color,
                                            ),
                                            IconButton(onPressed: () { // Delete button
                                              BlocProvider.of<RoutinesBloc>(context)
                                                  .add(DeleteRoutine(routine: state.routines[index]));
                                            },
                                              color: Theme.of(context).iconTheme.color,
                                              icon: Icon(Icons.delete),
                                            )]
                      ),
                  ),
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BlocProvider.value(
                            value: BlocProvider.of<RoutinesBloc>(context),
                            child: RoutineDetailScreen(routine: state.routines[index]),
                      );
                      }));
                  }
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BlocProvider.value(
                            value: BlocProvider.of<RoutinesBloc>(context),
                            child: EditRoutineScreen(routine: null),
                      );
                      }));
            },
            backgroundColor: Theme.of(context).iconTheme.color,
            child: const Icon(Icons.add),
          )
        );
      } else { // state is DetailRoutine
        return RoutineDetailScreen(routine: (state as DetailRoutine).routine);
      }
    }
    );
  }
}
