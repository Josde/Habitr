import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/classes/user.dart';
import 'friends_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final bool isSelfProfile;
  const ProfileScreen({Key? key, required this.user, this.isSelfProfile = false}) : super(key: key);

  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? avatarSvg = '';
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    avatarSvg = Jdenticon.toSvg(widget.user.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
               title: Text(
                "Profile",
              ),
              backgroundColor: Colors.deepPurple,
            ),
      body: Column(
        children: [
          Row( // User name and etc row
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(avatarSvg!, fit: BoxFit.contain, height: 128, width: 128),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.user.name}'),
                  Text('${widget.user.country.displayName}'),
                  Text('${widget.user.xp}xp'), //TODO: Add rank when the functionality is done.
                ],
              )
            ],
          ),
          Divider(
            color: Theme.of(context).primaryColorLight,
          ),
          IntrinsicHeight(
            child: Row( //Stadistics and friends button
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded( // Stadistics
                    child: GestureDetector(
                      onTap: (){print('Tapped stadistics');},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(color: Theme.of(context).primaryColorDark),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Center(child: Text('Stadistics')),
                        ),
                      ),
                    ),
                  ),
                  Expanded( // Friends
                    child: GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsScreen()));},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(color: Theme.of(context).primaryColorDark),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: Column(
                              children: [
                                Text('Friends'),
                                Text('${widget.user.friendCount}')
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
          Column( // TODO: Feed

          ),
          Spacer(),
          Container(), // TODO: Visit button
        ],
      )
    );
  }
}
