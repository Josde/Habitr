import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';

import '../../data/classes/user.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  User? myself;

  @override
  void initState() {
    super.initState();
    myself = BlocProvider.of<SelfBloc>(context).state.self;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(myself.toString()));
  }
}
