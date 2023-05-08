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
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: Center(
            child: FutureBuilder(
          future: getRoutines(),
          builder: (context, snapshot) {
            if (!(snapshot.hasData)) {
              return Center(child: LoadingSpinner());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Theme.of(context).primaryColorDark,
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data![index].icon ?? ""),
                        ),
                        Text(snapshot.data![index].name),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              BlocProvider.of<RoutinesBloc>(context).add(
                                  AddRepositoryRoutineEvent(
                                      routine: snapshot.data![index]));
                            }),
                        Builder(
                          builder: (context) {
                            if (snapshot.data![index].creatorId ==
                                supabase.auth.currentUser!.id) {
                              return IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    BlocProvider.of<RoutinesBloc>(context).add(
                                        DeleteRoutineEvent(
                                            routine: snapshot.data![index])),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
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
