import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

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
        title: Text('Friends'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: BlocProvider.of<FriendsBloc>(context).state.friends!.length,
        itemBuilder: (BuildContext context, int index) {
                User u = BlocProvider.of<FriendsBloc>(context).state.friends![index];
                return GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: u)));},
                  child: Container(
                    color: Theme.of(context).primaryColorDark,
                    child: Row( //TODO: Add identicon to this
                      children: [SvgPicture.string(Jdenticon.toSvg(u.id)),
                        Text('${u.name}')]
                      ),
                   )
                );
            }),
    );
  }
}
