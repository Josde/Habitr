import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/users/friends/friends_bloc.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends')
      ),
      body: ListView.builder(
        itemCount: BlocProvider.of<FriendsBloc>(context).state.friends!.length,
        itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    color: Theme.of(context).primaryColorDark,
                    child: Text( //TODO: Add identicon to this
                      '${BlocProvider.of<FriendsBloc>(context).state.friends![index].name}',
                   )
                ),
            );}
    ));
  }
}
