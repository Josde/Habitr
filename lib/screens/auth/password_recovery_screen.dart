/// {@category GestionAutenticacion}
/// {@category Vista}
library;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:habitr_tfg/utils/theming.dart';
import 'package:habitr_tfg/utils/validator.dart';
import 'package:habitr_tfg/widgets/rounded_text_form_field.dart';

import '../../utils/constants.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  String? _email;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Password recovery'),
        ),
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Text('Password recovery',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              fontSize: 32.0))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedTextFormField(
                      hintText: 'E-mail',
                      onSaved: (String? value) => this._email = value!,
                      validator: (value) {
                        return emailValidator(value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Continue'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)))),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data is not correct.')),
                        );
                        return;
                      }
                      _formKey.currentState!.save();
                      try {
                        final result =
                            await supabase.auth.resetPasswordForEmail(_email!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Sent recovery email, please check your email.')));
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
