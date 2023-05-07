import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/screens/routine/new_create_routine_screen.dart';
import 'package:habitr_tfg/screens/routine/routine_detail_screen.dart';
import 'package:habitr_tfg/screens/routine/routine_repository_screen.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutinesBloc, RoutinesState>(builder: (context, state) {
      if (state is RoutinesLoaded) {
        return RoutineList(state: state);
      } else if (state is DetailRoutine) {
        // state is DetailRoutine
        return RoutineList(state: state); //temp fix
        //return RoutineDetailScreen(routine: (state as DetailRoutine).routine);
      } else {
        return RoutineList(
            state: RoutinesLoaded(
                routines: List.empty())); //temp fix, this is an error
      }
    });
  }
}

class RoutineList extends StatelessWidget {
  RoutinesState state;
  RoutineList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Routines",
          ),
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: state.routines.length,
            itemBuilder: buildRoutine,
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                // Add from repository button
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RoutineRepositoryScreen();
                  }));
                },
                heroTag: null, // This prevents a crash.
                backgroundColor: Theme.of(context).iconTheme.color,
                child: Icon(
                  Icons.wifi,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            FloatingActionButton(
              // Create new button
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewCreateRoutineScreen(routine: null);
                }));
              },
              backgroundColor: Theme.of(context).iconTheme.color,
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ));
  }

  Widget buildRoutine(BuildContext context, int index) {
    return GestureDetector(
        child: Container(
          height: 50,
          color: Theme.of(context).primaryColorDark,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${state.routines[index].icon ?? ""}'),
            ),
            Text('${state.routines[index].name}'),
            Spacer(),
            IconButton(
              onPressed: () {
                // Edit button
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewCreateRoutineScreen(
                    routine: state.routines[index],
                  );
                }));
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).iconTheme.color,
            ),
            IconButton(
              onPressed: () {
                // Delete button
                BlocProvider.of<RoutinesBloc>(context)
                    .add(DeleteRoutineEvent(routine: state.routines[index]));
              },
              color: Theme.of(context).iconTheme.color,
              icon: Icon(Icons.delete),
            )
          ]),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RoutineDetailScreen(routine: state.routines[index]);
          }));
        });
  }
}
