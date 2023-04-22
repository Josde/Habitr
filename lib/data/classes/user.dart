import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:country_picker/country_picker.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  // Defaults for empty constructor
  @JsonKey(name: 'uuid')
  String id = '';
  @JsonKey(name: 'name')
  String name = 'User';
  @JsonKey(name: 'country_code', fromJson: Country.tryParse)
  Country? country = Country.worldWide;
  @JsonKey(name: 'created_at')
  DateTime createdAt = DateTime.now();
  @JsonKey(name: 'xp')
  int xp = 0;
  @JsonKey(name: 'current_streak')
  int currentStreak =
      0; //FIXME: Esto son IDs de las rachas, no la longitud, aunque de momento para desarrollar la interfaz lo voy a tomar como longitud
  @JsonKey(name: 'max_streak')
  int maxStreak = 0;
  int friendCount = 0;
  @JsonKey(name: 'is_admin')
  bool isAdmin = false;
  User(this.id, this.name, this.country, this.createdAt, this.xp,
      this.currentStreak, this.maxStreak, this.friendCount, this.isAdmin);
  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
  // User.fromJson(Map<dynamic, dynamic> json) {
  //   // <dynamic, dynamic> because supabase returns it like that; however first part of the map will always be a string.
  //   this.id = json['uuid'];
  //   this.name = json['name'];
  //   this.createdAt = DateTime.parse(json['created_at']);
  //   this.country = Country.tryParse(json['country_code']) ??
  //       Country
  //           .worldWide; // FIXME: Doesn't work, i have to change supabase to use iso2
  //   this.xp = json['xp'] ?? 0;
  //   this.currentStreak = json['current_streak'] ?? 0;
  //   this.maxStreak = json['max_streak'] ?? 0;
  //   this.isAdmin = json['is_admin'] ?? false;
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> json = new Map<String, dynamic>();
  //   // TODO: Implement this if needed?
  //   return json;
  // }

  @override
  List<Object?> get props =>
      [id, name, xp, currentStreak, maxStreak, friendCount];
}
