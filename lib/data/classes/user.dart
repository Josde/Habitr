import 'package:uuid/uuid.dart';
import 'package:country_picker/country_picker.dart';

class User {
  // Defaults for empty constructor
  var uuid = Uuid();
  String id = '';
  String name = 'User'; //TODO: Remove this, this is for debug.
  Country country = Country.worldWide;
  DateTime createdAt = DateTime.now();
  int xp = 0;
  int currentStreak =
      0; //FIXME: Esto son IDs de las rachas, no la longitud, aunque de momento para desarrollar la interfaz lo voy a tomar como longitud
  int maxStreak = 0;
  int friendCount = 0;
  bool isAdmin = false;

  User.empty() {
    this.id = uuid.v4();
  }

  User.debug(this.name) {
    this.id = uuid.v4();
  }

  User(this.name, this.country, this.createdAt, this.xp, this.currentStreak,
      this.maxStreak, this.friendCount, this.isAdmin) {
    this.id = uuid.v4();
  }
  User.fromJson(Map<dynamic, dynamic> json) {
    // <dynamic, dynamic> because supabase returns it like that; however first part of the map will always be a string.
    this.id = json['uuid'];
    this.name = json['name'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.country = Country
        .worldWide; // FIXME: Doesn't work, i have to change supabase to use iso2
    this.xp = json['xp'] ?? 0;
    this.currentStreak = json['current_streak'] ?? 0;
    this.maxStreak = json['max_streak'] ?? 0;
    this.isAdmin = json['is_admin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    // TODO: Implement this
    return json;
  }
}
