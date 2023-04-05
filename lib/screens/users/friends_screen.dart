import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/friend_requests_screen.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/widgets/loading.dart';
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
  void initState() {
    super.initState();
    if (!(BlocProvider.of<FriendsBloc>(context).state is FriendsLoaded))
      BlocProvider.of<FriendsBloc>(context).add(LoadFriendsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        var _child;
        if (state is FriendsLoaded) {
          _child = Friends(friends: state.friends!);
        } else {
          _child =
              Container(alignment: Alignment.center, child: LoadingSpinner());
        }
        return Scaffold(appBar: AppBar(title: Text('Friends')), body: _child);
      },
    );
  }
}

// FIXME: We can currently only access our own friends. Change it so friends button is disabled on other profiles (but we can see the count or smth like that)
class Friends extends StatelessWidget {
  const Friends({
    super.key,
    required List<User> friends,
  }) : _friends = friends;

  final List<User> _friends;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColorDark,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendRequestScreen())),
                child: Row(
                  children: [
                    Text(
                        'Friend requests'), //TODO: Add friends request screen on click
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
          ),
          Flexible(
            child: ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (BuildContext context, int index) {
                  User u = _friends[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(user: u)));
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
    );
  }
}
