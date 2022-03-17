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