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
  String? _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/motivation.png'),
              Container(child: Text('Welcome to Habitr!')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedTextFormField(
                  hintText: 'E-mail',
                  onSaved: (String? value) {this._email = value!;},
                  validator: (value) { return emailValidator(value);}
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedTextFormField(
                  hintText: 'Password',
                  obscureText: true,
                  suffixIcon: Icons.visibility,
                  onSaved: (String? value) {this._password = value!;},
                  validator: (value) { return passwordValidator(value);},
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
                    final result = await supabase.auth.signIn(email: _email, password: _password);
                    if (result.error == null) {
                    Navigator.pushReplacement(context, MaterialPageRoute( //temp fix, reformat to bloc later
                        builder: (BuildContext context) { return BottomNavBar(); }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${result.error!.message}')),
                      );
                    }
                },
              ),
              ElevatedButton( //FIXME: Currently not working (see: https://github.com/supabase-community/gotrue-dart/issues/27)
                onPressed: () async {
                  await supabase.auth.signInWithProvider(Provider.google, options: AuthOptions(redirectTo: 'https://tzkauycpwctgufjkoeds.supabase.co/auth/v1/callback'));
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
                  TextSpan(
                      children: <TextSpan>[
                      TextSpan(text: "Don't have an account yet? "),
                      TextSpan(text: "Sign up",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                                print('Clicked sign up');
                              },
                      ),
                    TextSpan(text: "\nOr ",
                    ),

                    TextSpan(text: "continue as a guest",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Clicked guest');
                              },
                      ),
                    ]
                  ),
                textAlign: TextAlign.center,
                ),

                ),
            ],
        ),
      ),
    );
  }
}
