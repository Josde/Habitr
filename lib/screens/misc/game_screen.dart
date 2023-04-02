import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/classes/user.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  var myself;
  late Widget _child;

  Future<String> getLogin() async {
    final myselfResponse = await supabase.from('profiles').select();

    return Future.value(myselfResponse.toString());
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfBloc, SelfState>(builder: (context, state) {
      if (state is SelfLoaded) {
        _child = Text(state.self!);
      } else {
        _child = LoadingSpinner();
      }
      return Container(alignment: Alignment.center, child: _child);
    });
    // return FutureBuilder(
    //   future: getLogin(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       _child = LoadingSpinner();
    //     } else {
    //       print(snapshot.data!);
    //       if (snapshot.hasError) {
    //         _child = Text(snapshot.error.toString());
    //       } else {
    //         _child = Text(snapshot.data!.toString());
    //       }
    //     }
    //     return Container(alignment: Alignment.center, child: _child);
    //   },
    // );
  }
}
