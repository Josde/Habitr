class Post {
  late int id;
  String? posterId;
  String? text;
  DateTime? date;
  Post(int _id, String _posterId, String _text) {
    id = _id;
    posterId = _posterId;
    text = _text;
    date = DateTime.now();
  }

  Post.fromJson(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.posterId = json['poster_id'];
    this.text = json['content'];
    this.date = DateTime.parse(json['post_date']);
  }
}
