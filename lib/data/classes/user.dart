/// {@category Datos}
/// {@category GestionUsuario}
/// Clase que representa un usuario.
library;

import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/streak.dart';
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
  int currentStreakId = 0;
  @JsonKey(name: 'max_streak', defaultValue: 0)
  int maxStreakId = 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Streak? currentStreak;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Streak? maxStreak;
  @JsonKey(name: 'is_admin')
  bool isAdmin = false;
  @JsonKey(name: 'flowers')
  List<int> flowers = List.filled(16, 0);
  User(this.id, this.name, this.country, this.createdAt, this.xp,
      this.currentStreakId, this.maxStreakId, this.isAdmin);
  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        xp,
        currentStreak,
        maxStreak,
        currentStreakId,
        maxStreakId,
        flowers
      ];
}
