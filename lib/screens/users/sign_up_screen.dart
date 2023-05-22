import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/validator.dart';
import 'package:habitr_tfg/widgets/rounded_container.dart';
import 'package:habitr_tfg/widgets/rounded_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/bottom_nav_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _displayName, _email, _password;
  var _obscureText = true;
  Country _country = Country.worldWide;
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
                  onSaved: (String? value) {
                    this._displayName = value!;
                  },
                  validator: (value) {
                    return textNotEmptyValidator(value);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedTextFormField(
                hintText: 'E-mail',
                onSaved: (String? value) {
                  this._email = value!;
                },
                validator: (value) {
                  return emailValidator(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedTextFormField(
                  hintText: 'Password',
                  obscureText: _obscureText,
                  suffixIcon: Icons.visibility,
                  onSaved: (String? value) {
                    this._password = value!;
                  },
                  onSuffixIcon: () {
                    setState(() => this._obscureText = !this._obscureText);
                  },
                  validator: (value) {
                    return passwordValidator(value);
                  }),
            ),
            AspectRatio(
              aspectRatio: 5.5, //TODO: Prettify this!
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedContainer(
                      child: GestureDetector(
                          child: Center(
                              child: Text(_country == Country.worldWide
                                  ? "Country"
                                  : _country.name)),
                          onTap: () => showCountryPicker(
                              context: context,
                              onSelect: (value) =>
                                  setState(() => _country = value)))),
                ),
              ),
            ),
            ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data is not correct.')),
                    );
                    return;
                  }
                  if (_country == Country.worldWide) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Remember to pick a country!')),
                    );
                    return;
                  }
                  _formKey.currentState!.save();
                  //TODO: Make a webpage to prevent users from being redirected to localhost
                  //TODO: Return a waiting for email confirmation screen
                  try {
                    final result = await supabase.auth.signUp(
                        email: _email!,
                        password: _password!,
                        data: {
                          'name': _displayName,
                          'country': _country.countryCode
                        });
                    if (result.user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Please verify your e-mail and come back")));
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
                }),
          ],
        ),
      ),
    );
  }
}
