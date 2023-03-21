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
  User.fromJson(Map<String, dynamic> json) {
    //TODO: Implement this
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    // TODO: Implement this
    return json;
  }
}
