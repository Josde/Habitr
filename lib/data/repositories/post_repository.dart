/// {@category Repositorio}
/// {@category GestionSocial}
library;

import 'package:habitr_tfg/data/classes/post.dart';
import 'package:habitr_tfg/utils/constants.dart';

/// Clase que define el repositorio y sus métodos. Se puede hacer click para obtener una vista de detalle.
///
/// Al igual que en otros repositorios, tódos los métodos lanzan excepciones sin capturar, y por tanto han de estar en un bloque try - catch.
class PostRepository {
  /// Carga los posts del feed del usuario de la aplicación.
  ///
  /// Admite los parámetros [limit] y [startAt] para añadir soporte a la paginación, aunque actualmente no se utilizan en la aplicación.
  ///
  /// Retorna una List<Post> que representa la lista de mensajes del feed del usuario.
  Future<List<Post>> loadPosts({int limit = 20, int startAt = 0}) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    List<Post> posts = List.empty(growable: true);
    var postResponse = await supabase
        .from('message')
        .select('*, messageLikes(post_id)')
        .order('post_date')
        .range(startAt, limit); //TODO: Test this
    print(postResponse);
    for (var msg in postResponse) {
      msg['likes'] = msg['messageLikes'].length ?? 0;
      posts.add(Post.fromJson(msg as Map));
    }
    return Future.value(posts);
  }

  /// Envía un mensaje [p] a la BBDD.
  ///
  /// Retorna el objeto Post que se ha generado por la BBDD.
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

  /// Borra el post [p].
  ///
  /// No retorna nada.
  Future<void> deletePost(Post p) async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in.');
    }
    await supabase.from('message').delete().eq('id', p.id);
  }

  /// Le da like al mensaje [p]. Si [unlike] es verdadero, hace lo contrario.
  ///
  /// No retorna nada.
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
