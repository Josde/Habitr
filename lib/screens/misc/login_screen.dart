import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/screens/misc/sign_up_screen.dart';
import 'package:habitr_tfg/widgets/rounded_text_form_field.dart';

import '../../widgets/bottom_nav_bar.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedTextFormField(
                  hintText: 'Password',
                  suffixIcon: Icons.visibility,
                ),
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: (){
                  if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data is not correct.')),
                      );
                      return;
                    }
                    _formKey.currentState!.save();
                  Navigator.push(context, MaterialPageRoute( //temp fix, reformat to bloc later
                      builder: (BuildContext context) { return BottomNavBar(); }));
                },
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: RichText(
                  textAlign: TextAlign.center,

                  text: TextSpan(
                  children: <TextSpan>[
                      TextSpan(text: "Don't have an account yet? "),
                      TextSpan(text: "Sign up",
                              recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                                print('Clicked sign up');
                              },
                              style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    TextSpan(text: "\nOr "),
                    TextSpan(text: "continue as a guest",
                    recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Clicked guest');
                              },
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]
                ),

                ),
              )
            ],
        ),
      ),
    );
  }
}
