import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  late Widget _child;
  late String selfId;
  @override
  void initState() {
    super.initState();
    this.selfId = BlocProvider.of<SelfBloc>(context).state.self!.id;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(builder: (context, state) {
      if (!(state is FriendsLoaded)) {
        _child = Center(child: LoadingSpinner());
      } else {
        _child = FriendRequests(friends: state.requests!, selfId: selfId);
      }

      return Scaffold(
        appBar: AppBar(title: Text('Friend requests')),
        body: _child,
      );
    });
  }
}

class FriendRequests extends StatelessWidget {
  const FriendRequests(
      {super.key, required List<User> friends, required this.selfId})
      : _friends = friends;
  final String selfId;
  final List<User> _friends;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: _friends.length,
          itemBuilder: (BuildContext context, int index) {
            User u = _friends[index];
            return Container(
                color: Theme.of(context).primaryColorDark,
                child: Row(children: [
                  GestureDetector(
                    child: Row(children: [
                      SvgPicture.string(Jdenticon.toSvg(u.id)),
                      Text('${u.name}')
                    ]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(user: u)));
                    },
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<FriendsBloc>(context)
                            .add(DeclineFriendRequestEvent(friend: u));
                      },
                      icon: Icon(Icons.close)),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<FriendsBloc>(context)
                            .add(AcceptFriendRequestEvent(friend: u));
                      },
                      icon: Icon(Icons.done)),
                ]));
          }),
    );
  }
}
