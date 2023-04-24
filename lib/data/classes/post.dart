import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

@JsonSerializable()
class Post extends Equatable {
  @JsonKey()
  late int id;
  @JsonKey(name: 'poster_id')
  String? posterId;
  @JsonKey(name: 'content')
  String? text;
  @JsonKey(name: 'post_date', fromJson: DateTime.parse)
  DateTime? date;

  factory Post.fromJson(Map<dynamic, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  Post(this.id, this.posterId, this.text, this.date);
  Post.onlyText(this.text) {
    this.date = DateTime.now();
  }
  // Post(int _id, String _posterId, String _text) {
  //   id = _id;
  //   posterId = _posterId;
  //   text = _text;
  //   date = DateTime.now();
  // }

  // Post.fromJson(Map<dynamic, dynamic> json) {
  //   this.id = json['id'];
  //   this.posterId = json['poster_id'];
  //   this.text = json['content'];
  //   this.date = DateTime.parse(json['post_date']);
  // }

  @override
  List<Object?> get props => [id, posterId, text, date];
}
