import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Source: https://supabase.com/docs/guides/with-flutter#set-up-authrequiredstate
// Solo importar esto si Supabase.initialize ha sido llamado.
// es decir, no lo podemos importar hasta que se llame a main() pero si en ficheros que se importen despues de main.

final supabase = Supabase.instance.client;

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