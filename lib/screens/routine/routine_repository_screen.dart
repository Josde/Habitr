import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';

class RoutineRepositoryScreen extends StatefulWidget {
  const RoutineRepositoryScreen({super.key});

  @override
  State<RoutineRepositoryScreen> createState() =>
      _RoutineRepositoryScreenState();
}

class _RoutineRepositoryScreenState extends State<RoutineRepositoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Routine Store'),
        ),
        body: Center(
            child: FutureBuilder(
          future: getRoutines(),
          builder: (context, snapshot) {
            if (!(snapshot.hasData)) {
              return LoadingSpinner();
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    child: Row(
                      children: [
                        Text(snapshot.data![index].name),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            BlocProvider.of<RoutinesBloc>(context).add(
                                AddRepositoryRoutineEvent(
                                    routine: snapshot.data![index]));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        )));
  }

  Future<List<Routine>> getRoutines() async {
    List<Routine> list = List.empty(growable: true);
    var routinesResponse =
        await supabase.from('routine').select().eq('is_public', true) as List;
    for (var routine in routinesResponse) {
      list.add(Routine.fromJson(routine as Map));
    }
    return Future.value(list);
  }
}
