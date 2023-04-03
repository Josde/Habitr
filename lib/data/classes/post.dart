class Post {
  String? posterId;
  String? text;
  DateTime? date;
  Post(String _posterId, String _text) {
    posterId = _posterId;
    text = _text;
    date = DateTime.now();
  }

  Post.fromJson(Map<dynamic, dynamic> json) {
    this.posterId = json['poster_id'];
    this.text = json['content'];
    this.date = DateTime.parse(json['post_date']);
  }
}
