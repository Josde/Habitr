import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/achievements/all.dart';
import 'package:habitr_tfg/screens/misc/settings_screen.dart';
import 'package:habitr_tfg/screens/users/statistics_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/classes/user.dart';
import 'friends_screen.dart';

class ProfileScreen extends StatefulWidget {
  late final User user;
  final bool isSelfProfile;
  ProfileScreen({Key? key, required this.user, this.isSelfProfile = false})
      : super(key: key);
  ProfileScreen.self({Key? key, this.isSelfProfile = true}) : super(key: key);
  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? avatarSvg = '';
  late User _user;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _child;

    if (widget.isSelfProfile) {
      return BlocBuilder<SelfBloc, SelfState>(
        builder: (context, state) {
          if (state is SelfLoaded || state is SelfReloading) {
            _user = state.self!;
            avatarSvg = Jdenticon.toSvg(_user.id);
            _child = Profile(
                avatarSvg: avatarSvg,
                user: _user,
                isSelfProfile: widget.isSelfProfile);
          } else {
            if (!(state is SelfLoading)) {
              BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
            }
            _child = Center(
              child: LoadingSpinner(),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Profile",
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                    ),
                  )
                ],
                backgroundColor: Theme.of(context).iconTheme.color,
              ),
              body: _child);
        },
      );
    } else {
      // An user was passed directly
      _user = widget.user;
      avatarSvg = Jdenticon.toSvg(_user.id);
      _child = Profile(
          avatarSvg: avatarSvg,
          user: _user,
          isSelfProfile: widget.isSelfProfile);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
              ),
            )
          ],
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: _child);
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.avatarSvg,
    required User user,
    required this.isSelfProfile,
  }) : _user = user;

  final String? avatarSvg;
  final User _user;
  final bool isSelfProfile;

  @override
  Widget build(BuildContext context) {
    // TODO: I could use a BlocBuilder for this but I don't want to add loading spinners for such a miniscule feature.
    var _friendCount = (BlocProvider.of<FriendsBloc>(context).state
            is FriendsLoaded)
        ? BlocProvider.of<FriendsBloc>(context).state.friends!.length.toString()
        : "";
    return Column(
      children: [
        Row(
          // User name and etc row
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(avatarSvg!,
                fit: BoxFit.contain, height: 128, width: 128),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_user.name}'),
                Text('${_user.country?.displayName}'),
                Text(
                    '${_user.xp}xp'), //TODO: Add rank when the functionality is done.
              ],
            )
          ],
        ),
        Builder(builder: (context) {
          if ((isSelfProfile)) {
            return IntrinsicHeight(
              child: Row(
                //Stadistics and friends button
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    // Stadistics
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatisticsScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(child: Text('Stadistics')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // Friends
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendsScreen()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('Friends'),
                                  Text('$_friendCount')
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }),
        Divider(
          color: Theme.of(context).primaryColorLight,
        ),
        Expanded(
            // TODO: Achivements
            child: FutureBuilder(
          future: _getUserAchievements(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingSpinner();
            } else {
              return ListView.builder(
                itemCount: (snapshot.data!).length,
                itemBuilder: (context, index) {
                  bool _showDate = index == 0 ||
                      snapshot.data![index - 1].unlockedAt!
                              .difference(snapshot.data![index].unlockedAt!) >
                          Duration(days: 1);
                  Widget header = _showDate
                      ? Column(children: [
                          Text(snapshot.data![index].unlockedAt.toString()),
                          Divider()
                        ])
                      : SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        header,
                        Row(
                          children: [
                            Text("${_user.name} unlocked the achievement "),
                            GestureDetector(
                              child: Text(
                                "${snapshot.data![index].name}!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "${snapshot.data![index].description}"),
                              )),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        )),
        Spacer(),
        Container(), // TODO: Visit button
      ],
    );
  }

  Future<List<Achievement>> _getUserAchievements() async {
    List<Achievement> lst = List.empty(growable: true);
    var achievementResponse = await supabase
        .from("profileAchievement")
        .select()
        .eq("profile_id", supabase.auth.currentUser?.id ?? "")
        .order("unlocked_at") as List;
    for (var item in achievementResponse) {
      var newAchievement = achievementList
          .firstWhere((element) => element.id == item['achievement_id']);
      newAchievement.unlockedAt =
          DateTime.tryParse(item['unlocked_at']) ?? DateTime.now();
      print(newAchievement.unlockedAt);
      lst.add(newAchievement);
    }
    return Future.value(lst);
  }
}
