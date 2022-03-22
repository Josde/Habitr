import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/widgets/rounded_text_form_field.dart';

import '../../widgets/bottom_nav_bar.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: Text('Register an account')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedTextFormField(
                  hintText: 'Display name',
                ),
              ),
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
                child: Text('Register'),
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
            ],
        ),
      ),
    );
  }
}
