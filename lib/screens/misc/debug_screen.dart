import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';

import '../../widgets/loading.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: IconButton(
        icon: Icon(Icons.replay_outlined),
        onPressed: () {
          BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
          BlocProvider.of<FriendsBloc>(context).add(LoadFriendsEvent());
          BlocProvider.of<RoutinesBloc>(context).add(LoadRoutinesEvent());
        },
      )),
    );
  }
}
