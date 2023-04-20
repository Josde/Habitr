import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:country_picker/country_picker.dart';

class User extends Equatable {
  // Defaults for empty constructor

  String id = '';
  String name = 'User';
  Country country = Country.worldWide;
  DateTime createdAt = DateTime.now();
  int xp = 0;
  int currentStreak =
      0; //FIXME: Esto son IDs de las rachas, no la longitud, aunque de momento para desarrollar la interfaz lo voy a tomar como longitud
  int maxStreak = 0;
  int friendCount = 0;
  bool isAdmin = false;

  User.fromJson(Map<dynamic, dynamic> json) {
    // <dynamic, dynamic> because supabase returns it like that; however first part of the map will always be a string.
    this.id = json['uuid'];
    this.name = json['name'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.country = Country.tryParse(json['country_code']) ??
        Country
            .worldWide; // FIXME: Doesn't work, i have to change supabase to use iso2
    this.xp = json['xp'] ?? 0;
    this.currentStreak = json['current_streak'] ?? 0;
    this.maxStreak = json['max_streak'] ?? 0;
    this.isAdmin = json['is_admin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    // TODO: Implement this if needed?
    return json;
  }

  @override
  List<Object?> get props =>
      [id, name, xp, currentStreak, maxStreak, friendCount];
}
