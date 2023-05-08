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

  @override
  List<Object?> get props => [id, posterId, text, date];
}
