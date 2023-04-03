import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/screens/misc/settings_screen.dart';
import 'package:habitr_tfg/screens/users/statistics_screen.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/classes/user.dart';
import 'friends_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final bool isSelfProfile;
  const ProfileScreen(
      {Key? key, required this.user, this.isSelfProfile = false})
      : super(key: key);

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
    if (widget.isSelfProfile) {
      return BlocBuilder<SelfBloc, SelfState>(
        builder: (context, state) {
          if (state is SelfLoaded) {
            _user = state.self!;
            avatarSvg = Jdenticon.toSvg(_user.id);
            return Profile(avatarSvg: avatarSvg, user: _user);
          } else {
            if (!(state is SelfLoading)) {
              BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
            }
            return Scaffold(
                appBar: AppBar(title: Text('Profile')),
                body: Container(
                    child: LoadingSpinner(), alignment: Alignment.center));
          }
        },
      );
    } else {
      _user = widget.user;
      avatarSvg = Jdenticon.toSvg(_user.id);
      return Profile(avatarSvg: avatarSvg, user: _user);
    }
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.avatarSvg,
    required User user,
  }) : _user = user;

  final String? avatarSvg;
  final User _user;

  @override
  Widget build(BuildContext context) {
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
        body: Column(
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
                    Text('${_user.country.displayName}'),
                    Text(
                        '${_user.xp}xp'), //TODO: Add rank when the functionality is done.
                  ],
                )
              ],
            ),
            Divider(
              color: Theme.of(context).primaryColorLight,
            ),
            IntrinsicHeight(
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
                                Text('${_user.friendCount}')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColorLight,
            ),
            Column(// TODO: Feed

                ),
            Spacer(),
            Container(), // TODO: Visit button
          ],
        ));
  }
}
