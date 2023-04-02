import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/screens/misc/sign_up_screen.dart';
import 'package:habitr_tfg/utils/validator.dart';
import 'package:habitr_tfg/widgets/rounded_text_form_field.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final StreamSubscription<AuthState> _authSubscription;
  String? _email, _password;
  User? _user;
  var _obscureText = true;
  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      setState(() {
        _user = session?.user;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: Image.asset('assets/icons/motivation.png'),
                fit: FlexFit.tight),
            Container(child: Text('Welcome to Habitr!')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedTextFormField(
                  hintText: 'E-mail',
                  onSaved: (String? value) {
                    this._email = value!;
                  },
                  validator: (value) {
                    return emailValidator(value);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedTextFormField(
                hintText: 'Password',
                obscureText: this._obscureText,
                suffixIcon: Icons.visibility,
                onSuffixIcon: () {
                  setState(() => this._obscureText = !this._obscureText);
                },
                onSaved: (String? value) {
                  this._password = value!;
                },
                validator: (value) {
                  return passwordValidator(value);
                },
              ),
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data is not correct.')),
                  );
                  return;
                }
                _formKey.currentState!.save();
                try {
                  final result = await supabase.auth
                      .signInWithPassword(email: _email, password: _password!);
                  if (result.session != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(//temp fix, reformat to bloc later
                            builder: (BuildContext context) {
                      return BottomNavBar();
                    }));
                  }
                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.message)),
                  );
                }
              },
            ),
            ElevatedButton(
              // FIXME: This still does not work
              onPressed: () async {
                await supabase.auth.signInWithOAuth(Provider.google);
              },
              child: Text('G'),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text.rich(
                TextSpan(children: <TextSpan>[
                  TextSpan(text: "Don't have an account yet? "),
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                        print('Clicked sign up');
                      },
                  ),
                  TextSpan(
                    text: "\nOr ",
                  ),
                  TextSpan(
                    text: "continue as a guest",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Clicked guest');
                      },
                  ),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
