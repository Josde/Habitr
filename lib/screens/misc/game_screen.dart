import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/widgets/loading.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  var myself;
  late Widget _child;

  @override
  void initState() {
    super.initState();
    var selfState = BlocProvider.of<SelfBloc>(context).state;
    if (!(selfState is SelfLoaded) && !(selfState is SelfReloading))
      BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
    if ((selfState is SelfLoaded) &&
        (selfState.lastLoadTime).difference(DateTime.now()).inMinutes >= 5) {
      // Schedule reload if the data is stale
      BlocProvider.of<SelfBloc>(context).add(ReloadSelfEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfBloc, SelfState>(builder: (context, state) {
      if ((state is SelfLoaded) || (state is SelfReloading)) {
        _child = Text("TODO: Pantalla de juego");
      } else {
        _child = LoadingSpinner();
      }
      return Container(alignment: Alignment.center, child: _child);
    });
  }
}
