import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<AddPostEvent>(_onAddPost);
    on<DeletePostEvent>(_onDeletePost);
    on<LikePostEvent>(_onLikePost);
    on<UnlikePostEvent>(_onUnlikePost);
  }

  _onLoadPosts(LoadPostsEvent event, Emitter<FeedState> emit) async {
    emit.call(FeedLoading());
    List<Post> posts = List.empty(growable: true);
    try {
      var postResponse = await supabase.from('message').select();
      for (var msg in postResponse) {
        posts.add(Post.fromJson(msg as Map));
      }
      emit.call(FeedLoaded(posts: posts));
    } catch (e) {
      print(e);
      emit.call(FeedError(error: e.toString()));
    }
  }

  _onAddPost(AddPostEvent event, Emitter<FeedState> emit) async {
    Post p = event.post;
    try {
      Post newPost = Post.fromJson(await supabase
          .from('message')
          .insert({
            'content': p.text,
            'poster_id': supabase.auth.currentSession!.user.id
          })
          .select()
          .single() as Map);
      if (state is FeedLoaded) {
        List<Post> newPosts = List.from((state as FeedLoaded).posts);
        newPosts.add(newPost);
        emit.call(FeedLoaded(posts: newPosts));
      } else {
        emit.call(FeedLoaded(posts: [newPost]));
      }
    } catch (e) {
      print(e);
      emit.call(FeedError(error: e.toString()));
    }
  }

  _onDeletePost(DeletePostEvent event, Emitter<FeedState> emit) async {
    Post p = event.post;
    try {
      await supabase.from('message').delete().eq('id', p.id.toString());
      if (state is FeedLoaded) {
        List<Post> newPosts = List.from((state as FeedLoaded).posts);
        newPosts.removeWhere((element) => element == p);
        emit.call(FeedLoaded(posts: newPosts));
      }
    } catch (e) {
      print(e);
      emit.call(FeedError(error: e.toString()));
    }
  }

  _onLikePost(LikePostEvent event, Emitter<FeedState> emit) async {
    try {
      await supabase.from("messageLikes").insert({
        "post_id": event.post.id,
        "liked_by": supabase.auth.currentSession!.user.id
      });
    } catch (e) {
      print(e);
    }
  }

  _onUnlikePost(UnlikePostEvent event, Emitter<FeedState> emit) async {
    try {
      await supabase
          .from("messageLikes")
          .delete()
          .eq("liked_by", supabase.auth.currentSession!.user.id)
          .eq("post_id", event.post.id);
    } catch (e) {
      print(e);
    }
  }
}
