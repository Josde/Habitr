import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/utils/constants.dart';

class PostRepository {
  Future<List<Post>> loadPosts({int limit = 20, int startAt = 0}) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    List<Post> posts = List.empty(growable: true);
    var postResponse = await supabase
        .from('message')
        .select('*, messageLikes!inner(*)')
        .order('post_date')
        .range(startAt, limit); //TODO: Test this
    for (var msg in postResponse) {
      msg['likes'] = msg['messageLikes'].length ?? 0;
      posts.add(Post.fromJson(msg as Map));
    }
    return Future.value(posts);
  }

  Future<Post> addPost(Post p) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    return Future.value(Post.fromJson(await supabase
        .from('message')
        .insert({
          'content': p.text,
          'poster_id': supabase.auth.currentSession!.user.id
        })
        .select()
        .single() as Map));
  }

  Future<void> deletePost(Post p) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase.from('message').delete().eq('id', p.id);
  }

  Future<void> likePost(Post p, {unlike: false}) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    if (!unlike) {
      // LIKE
      await supabase.from("messageLikes").insert(
          {"post_id": p.id, "liked_by": supabase.auth.currentSession!.user.id});
    } else {
      // UNLIKE
      await supabase
          .from("messageLikes")
          .delete()
          .eq("liked_by", supabase.auth.currentSession!.user.id)
          .eq("post_id", p.id);
    }
  }
}
