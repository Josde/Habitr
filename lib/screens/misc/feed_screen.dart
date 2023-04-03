import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/widgets/like_button.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<Post> posts = List.empty(growable: true);
  late List<User> friends;
  bool isHeartAnimating = true;
  bool isLiked = true;
  late LikeButton lb;
  @override
  void initState() {
    super.initState();
    final _random = new Random();
    friends = BlocProvider.of<FriendsBloc>(context).state.friends!;
    lb = LikeButton(
        isAnimating: isHeartAnimating,
        isLiked: isLiked,
        duration: Duration(milliseconds: 400));
    for (int i = 0; i < 10; i++) {
      User u = friends[_random.nextInt(friends.length)];
      Post newPost = Post(u.id, i.toString());
      posts.add(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        Post p = posts[index];
        User u = friends.firstWhere((element) => element.id == p.posterId);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              color: Theme.of(context).primaryColorDark,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(user: u)));
                    },
                    child: Row(children: [
                      SvgPicture.string(Jdenticon.toSvg(u.id),
                          width: 32, height: 32),
                      Text(u.name),
                    ]),
                  ),
                  Text(p.text!),
                  Row(
                      //TODO: Make buttons clickable
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 20.0, 0.0),
                              child: lb,
                            ),
                            onTap: () {
                              // TODO: Add supabase like here
                              print('Tapped heart');
                              setState(() {
                                isLiked = !isLiked;
                                isHeartAnimating = true;
                              });
                            }),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                            child: GestureDetector(
                                child: Icon(Icons.share),
                                onTap: () => (Share.share(
                                    p.text!)) //TODO: More effort on this
                                )),
                      ])
                ]),
              ),
            ),
          ),
        );
      },
    ));
  }
}
