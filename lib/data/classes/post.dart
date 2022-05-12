class Post {
  String? posterId;
  String? text;
  DateTime? date;
  Post(String _posterId, String _text) {
    posterId = _posterId;
    text = _text;
    date = DateTime.now();
  }
}