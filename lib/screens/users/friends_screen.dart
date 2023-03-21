import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

import '../../blocs/users/friends/friends_bloc.dart';
import '../../utils/constants.dart';

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
        backgroundColor: Theme.of(context).iconTheme.color,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColorDark,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Friend requests'),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0)),
                      child: Text(
                          '0'), //TODO: Rework this once friend requests are working
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: BlocProvider.of<FriendsBloc>(context)
                      .state
                      .friends![debugUser]!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    User u = BlocProvider.of<FriendsBloc>(context)
                        .state
                        .friends![debugUser]![index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(user: u)));
                        },
                        child: Container(
                          color: Theme.of(context).primaryColorDark,
                          child: Row(children: [
                            SvgPicture.string(Jdenticon.toSvg(u.id)),
                            Text('${u.name}')
                          ]),
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
