import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/classes/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var uuid = Uuid();
  User u = User.empty();
  String? avatarSvg = '';
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    avatarSvg = Jdenticon.toSvg(u.name);
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
                style: TextStyle(
                  color: Colors.white,
                ),
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
                  Text('${u.name}'),
                  Text('${u.country.displayName}'),
                  Text('${u.xp}xp'), //TODO: Add rank when the functionality is done.
                ],
              )
            ],
          ),
          Divider(
            color: Colors.white,
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
                          color: Colors.white12,
                          border: Border.all(color: Colors.white24),
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
                      onTap: (){print('Tapped friends');},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: Column(
                              children: [
                                Text('Friends'),
                                Text('${u.friendCount}')
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
            color: Colors.white,
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
