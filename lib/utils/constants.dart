import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Source: https://supabase.com/docs/guides/with-flutter#set-up-authrequiredstate
// Solo importar esto si Supabase.initialize ha sido llamado.
// es decir, no lo podemos importar hasta que se llame a main() pero si en ficheros que se importen despues de main.

final supabase = Supabase.instance.client;
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.light(),
  iconTheme: IconThemeData(color: Colors.purple),
);

ThemeData? darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.dark(),
  iconTheme: IconThemeData(color: Colors.purple),
);
extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}