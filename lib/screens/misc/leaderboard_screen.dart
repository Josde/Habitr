import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

import '../../data/classes/user.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Leaderboard')),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildLeaderboardView(snapshot.data!);
            } else {
              return LoadingSpinner();
            }
          },
          future: getLeaderboardData(),
        ));
  }

  Widget buildLeaderboardView(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(
          color: Theme.of(context).primaryColorDark,
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: users[index]))),
            child: Row(children: [
              SvgPicture.string(Jdenticon.toSvg(users[index].id)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(users[index].name),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${users[index].xp}xp'),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<List<User>> getLeaderboardData() async {
    if (supabase.auth.currentUser == null) {
      return Future.value(List.empty());
    }
    List<User> users = List.empty(growable: true);
    var userResponse =
        await supabase.from('profiles').select().order('xp') as List;
    for (var item in userResponse) {
      users.add(User.fromJson(item as Map));
    }
    return Future.value(users);
  }
}
