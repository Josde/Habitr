/// {@category Datos}
/// {@category GestionSocial}
/// Representa un mensaje en la parte social de la aplicación.
///
/// Durante el proceso de desarrollo y documentación el término "Post" y el término "Mensaje" fueron usados intercambiablemente, pero ambos se refieren a esta clase.
library;

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
  @JsonKey(defaultValue: 0)
  late int? likes;

  factory Post.fromJson(Map<dynamic, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  Post(this.id, this.posterId, this.text, this.date, this.likes);
  Post.onlyText(this.text) {
    this.date = DateTime.now();
    this.likes = 0;
  }

  @override
  List<Object?> get props => [id, posterId, text, date, likes];
}
