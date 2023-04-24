import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:country_picker/country_picker.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'uuid')
  String id = '';
  @JsonKey(name: 'name')
  String name = 'User';
  @JsonKey(name: 'country_code', fromJson: Country.parse)
  Country? country = Country.worldWide;
  @JsonKey(name: 'created_at')
  DateTime createdAt = DateTime.now();
  @JsonKey(name: 'xp')
  int xp = 0;
  @JsonKey(name: 'current_streak', defaultValue: 0)
  int currentStreak =
      0; //FIXME: Esto son IDs de las rachas, no la longitud, aunque de momento para desarrollar la interfaz lo voy a tomar como longitud
  @JsonKey(name: 'max_streak', defaultValue: 0)
  int maxStreak = 0;
  @JsonKey(name: 'is_admin')
  bool isAdmin = false;
  User(this.id, this.name, this.country, this.createdAt, this.xp,
      this.currentStreak, this.maxStreak, this.isAdmin);
  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, name, xp, currentStreak, maxStreak];
}
