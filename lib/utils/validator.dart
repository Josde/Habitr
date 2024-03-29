/// {@category Miscelaneo}
/// Clase que provee varios validadores para el texto que introduce el usuario.
library;

String? textNotEmptyValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

String? numericInputValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the length of the activity';
  } else if (int.tryParse(value) == null) {
    return 'Please only enter numbers';
  }
  return null;
}

String? emailValidator(value) {
  // https://regexr.com/2rhq7 for the RegEx: RFC2822 E-Mail Validation
  // Technically this allows aaa@aaa type mails, without a proper TLD, but other than that it's perfect.
  if (value == null || value == '') {
    return 'Please enter a e-mail';
  }
  bool validEmail = RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value);
  if (validEmail) {
    return null;
  } else {
    return 'This e-mail is not correct';
  }
}

String? passwordValidator(value) {
  // https://regexr.com/3bfsi
  // 8 characters min, one uppercase, one lowercase and one number.
  //Allows symbols but doesn't require them
  // Allows tildes, ñ ç and other characters
  if (value == null || value == '') {
    return 'Please enter a password';
  }
  bool validPassword =
      RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$")
          .hasMatch(value);
  if (validPassword) {
    return null;
  } else {
    return 'Must be longer than 8 characters, and contain at least an uppercase letter, an lowercase letter and a symbol.';
  }
}

String? iconValidator(value) {
  RegExp regex = RegExp(
      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  if (value == null || value == "") {
    return null;
  }
  if (value.runes.length > 1) {
    return 'Please enter only emoji character';
  }
  if (!regex.hasMatch(value)) {
    return 'Only emojis are allowed.';
  }
  return null;
}
