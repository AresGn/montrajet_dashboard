class Validators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    return null;
  }

  /// Validate phone number (Benin format +229)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Benin phone: +229 followed by 8 digits
    final phoneRegex = RegExp(r'^\+229\d{8}$|^\d{8}$');

    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Veuillez entrer un numéro valide (+229 XXXXXXXX)';
    }

    return null;
  }

  /// Validate not empty
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Validate number
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Un nombre est requis';
    }

    if (double.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Un nombre positif est requis';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Veuillez entrer un nombre positif';
    }

    return null;
  }

  /// Validate min length
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }

    if (value.length < minLength) {
      return 'Minimum $minLength caractères requis';
    }

    return null;
  }

  /// Validate max length
  static String? validateMaxLength(String? value, int maxLength) {
    if (value == null) return null;

    if (value.length > maxLength) {
      return 'Maximum $maxLength caractères autorisés';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'URL est requise';
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'Veuillez entrer une URL valide';
    }
  }
}
