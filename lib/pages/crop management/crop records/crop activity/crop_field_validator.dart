class CropFieldValidator {
  String? validateTextOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Please enter valid text, no numbers allowed';
    }
    return null;
  }

  String? validateNumberOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Please enter valid numbers, no letters allowed';
    }
    return null;
  }

  String? validateSeedAmount(String? value) {
    if (value == null || value.isEmpty) return 'Please enter seed amount';
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Please enter a valid positive number for seed amount';
    }
    return null;
  }

  String? validateFertilizerAmount(String? value) {
    if (value == null || value.isEmpty) return 'Please enter fertilizer amount';
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Please enter a valid positive number for fertilizer amount';
    }
    return null;
  }

  String? validateSprayAmount(String? value) {
    if (value == null || value.isEmpty) return 'Please enter spray amount';
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Please enter a valid positive number for spray amount';
    }
    return null;
  }
}
