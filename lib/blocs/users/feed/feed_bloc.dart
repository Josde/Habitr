/// {@category BLoC}
/// {@category GestionSocial}
/// Paquete que implementa el BLoC del feed (parte social). Para obtener más información, mirar los detalles de las classes Event y State de este paquete.
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/data/repositories/post_repository.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  PostRepository repository = PostRepository();
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
      if (supabase.auth.currentUser?.id == null) {
        emit.call(FeedError(error: "User is not logged in"));
        return;
      }
      posts = await this.repository.loadPosts();
      emit.call(FeedLoaded(posts: posts));
    } catch (e) {
      print(e);
      emit.call(FeedError(error: e.toString()));
    }
  }

  _onAddPost(AddPostEvent event, Emitter<FeedState> emit) async {
    Post p = event.post;
    try {
      //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
      if (supabase.auth.currentUser?.id == null) {
        emit.call(FeedError(error: "User is not logged in"));
        return;
      }
      Post newPost = await this.repository.addPost(p);
      if (state is FeedLoaded) {
        List<Post> newPosts = List.from((state as FeedLoaded).posts);
        newPosts.insert(0, newPost);
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
      //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
      if (supabase.auth.currentUser?.id == null) {
        emit.call(FeedError(error: "User is not logged in"));
        return;
      }
      this.repository.deletePost(p);
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
    if (this.state is FeedLoaded) {
      Post p = event.post;
      try {
        //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
        this.repository.likePost(p);
        List<Post> newPostList = List.from((this.state as FeedLoaded).posts);
        var index = newPostList.indexOf(event.post);
        newPostList[index] =
            Post(p.id, p.posterId, p.text, p.date, (p.likes ?? 0) + 1);
        emit.call(FeedLoaded(posts: newPostList));
      } catch (e) {
        print(e);
        emit.call(FeedError(error: e.toString()));
      }
    }
  }

  _onUnlikePost(UnlikePostEvent event, Emitter<FeedState> emit) async {
    if (this.state is FeedLoaded) {
      Post p = event.post;
      try {
        if (supabase.auth.currentUser?.id == null) {
          emit.call(FeedError(error: "User is not logged in"));
          return;
        }
        //FIXME: Desde la linea de abajo a la siguiente tendría que hacerlo el repositorio
        this.repository.likePost(p, unlike: true);
        List<Post> newPostList = List.from((this.state as FeedLoaded).posts);
        var index = newPostList.indexOf(event.post);
        newPostList[index] =
            Post(p.id, p.posterId, p.text, p.date, (p.likes ?? 1) - 1);
        emit.call(FeedLoaded(posts: newPostList));
      } catch (e) {
        print(e);
        emit.call(FeedError(error: e.toString()));
      }
    }
  }
}
