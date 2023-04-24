import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/users/feed/feed_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/widgets/like_button.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:share_plus/share_plus.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<Post> posts = List.empty(growable: true);
  late List<User> friends;
  late User self;
  bool isHeartAnimating = true;
  bool isLiked = false;
  late LikeButton lb;
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<FeedBloc>(context).state is FeedInitial) {
      BlocProvider.of<FeedBloc>(context).add(LoadPostsEvent());
    }
    friends = BlocProvider.of<FriendsBloc>(context).state.friends!;
    self = BlocProvider.of<SelfBloc>(context).state.self!;
    lb = LikeButton(
        isAnimating: isHeartAnimating,
        isLiked: isLiked,
        duration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: displayNewPost, child: Icon(Icons.message)),
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (!(state is FeedLoaded)) {
              return Center(
                  child: Container(
                child: LoadingSpinner(),
                alignment: Alignment.center,
              ));
            }
            posts = (state as FeedLoaded).posts;
            return ListView.builder(
              itemCount: posts
                  .length, //FIXME: Add paging (this will currently load all messages we can see)
              //TODO: Add post datetime to the widget
              itemBuilder: (BuildContext context, int index) {
                //TODO: Add getting message likes here for each post, unliking doesn't properly work yet.
                Post p = posts[index];
                User u = friends.firstWhere(
                    (element) => element.id == p.posterId,
                    orElse: () => self);
                bool isSelfPost =
                    (u.id == self.id); //TODO: Add delete button for self posts
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
                                      builder: (context) =>
                                          ProfileScreen(user: u)));
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
                                    onTap: () async {
                                      // TODO: Add supabase like here
                                      if (!isLiked) {
                                        BlocProvider.of<FeedBloc>(context)
                                            .add(LikePostEvent(p));
                                      } else {}
                                      print('Tapped heart');
                                      setState(() {
                                        isLiked = !isLiked;
                                        isHeartAnimating = true;
                                      });
                                    }),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 0.0, 0.0),
                                    child: GestureDetector(
                                        child: Icon(Icons.share),
                                        onTap: () => (Share.share(p
                                            .text!)) //TODO: More effort on this
                                        )),
                              ])
                        ]),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }

  Future<void> displayNewPost() async {
    //TODO: Add length validation and error handling.
    final TextEditingController _controller = TextEditingController();
    String? postText;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              onChanged: (value) => postText = value,
              controller: _controller,
            ),
            actions: [
              MaterialButton(
                child: Text("Cancel"),
                onPressed: () => setState(() => Navigator.pop(context)),
              ),
              MaterialButton(
                child: Text("Send"),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {
                  BlocProvider.of<FeedBloc>(context)
                      .add(AddPostEvent(Post.onlyText(postText)));
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
