class FieldValidator {
  String? validateTextOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[0-9]').hasMatch(value))
      return 'Please enter valid text, no numbers allowed';
    return null;
  }

  String? validateNumberOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[a-zA-Z]').hasMatch(value))
      return 'Please enter valid numbers, no letters allowed';
    return null;
  }
}
