import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
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
    return FutureBuilder(
        future: getFriendRequests(selfId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            _child = Container(child: LoadingSpinner());
          } else {
            _child = FriendRequests(friends: snapshot.data!, selfId: selfId);
          }

          return Scaffold(
            appBar: AppBar(title: Text('Friend requests')),
            body: _child,
          );
        });
  }

  Future<List<User>>? getFriendRequests(String selfId) async {
    List<User>? _friendRequests = List.empty(growable: true);
    List<String> _friendIds = List.empty(growable: true);

    try {
      var friendRequestResponse = await supabase.from('friendRequest').select();
      // FIXME: Add .eq('accepted', false), this is like this rn for testing
      for (var row in friendRequestResponse) {
        if (row['sent_by'] != selfId) _friendIds.add(row['sent_by']);
        if (row['sent_to'] != selfId) _friendIds.add(row['sent_to']);
      }
      var friendRequestProfileResponse =
          await supabase.from('profiles').select().in_('uuid', _friendIds);
      for (var row in friendRequestProfileResponse) {
        _friendRequests.add(User.fromJson(row as Map));
      }
    } catch (e) {
      print(e);
    }
    return Future.value(_friendRequests);
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
                        rejectButton(u, selfId);
                        //FIXME: Adding or deleting friends currently does not update the other views
                        BlocProvider.of<FriendsBloc>(context)
                            .add(LoadFriendsEvent());
                      },
                      icon: Icon(Icons.close)),
                  IconButton(
                      onPressed: () {
                        acceptButton(u, selfId);
                        BlocProvider.of<FriendsBloc>(context)
                            .add(LoadFriendsEvent());
                      },
                      icon: Icon(Icons.done)),
                ]));
          }),
    );
  }

//TODO: Simplify these to a single function with parameters
  acceptButton(User u, String selfId) async {
    try {
      await supabase.from('friendRequest').update({'accepted': true}).or(
          'sent_by.eq.${u.id},sent_to.eq.${u.id}');
    } catch (e) {
      print(e);
    }
  }

  rejectButton(User u, String selfId) async {
    try {
      await supabase
          .from('friendRequest')
          .delete()
          .or('sent_by.eq.${u.id},sent_to.eq.${u.id}');
    } catch (e) {
      print(e);
    }
  }
}
