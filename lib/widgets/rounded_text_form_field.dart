import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {

  const RoundedTextFormField({Key? key, this.hintText, this.validator, this.onSaved, this.suffixIcon, this.obscureText = false}) : super(key: key);
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? hintText;
  final IconData? suffixIcon;
  final bool? obscureText;
  //FIXME: Suffix Icon makes everything look off-center as it takes space up
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textAlign: TextAlign.center,
      onSaved: onSaved,
      obscureText: obscureText!,
      decoration: InputDecoration(
        hintText: hintText,
        errorMaxLines: 3,
        prefixIcon: Icon(null), //FIXME: Delete this, ffs
        suffixIcon: Icon(suffixIcon),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0)
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
       ),
        fillColor: Theme.of(context).primaryColorDark,
        filled: true,
      ),

    );
  }
}

