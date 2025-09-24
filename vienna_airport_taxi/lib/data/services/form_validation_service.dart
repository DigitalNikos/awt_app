import 'package:flutter/material.dart';

class FormValidationService {
  // Validation rules
  static bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return true; // Allow empty if not required
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(value);
  }

  static bool isValidPhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return true; // Allow empty if not required
    final regex = RegExp(r'^[0-9\s+()-]{8,}$');
    return regex.hasMatch(value);
  }

  static bool isMinLength(String? value, int length) {
    if (value == null) return false;
    return value.trim().length >= length;
  }

  static bool isChecked(bool? value) {
    return value ?? false;
  }

  // Validation functions for specific fields
  static ValidationResult validateDate(DateTime? date) {
    if (date == null) {
      return ValidationResult(isValid: false, errorMessage: 'Datum auswählen');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Uhrzeit auswählen');
    }

    final regex = RegExp(r'^(\d{1,2}):(\d{1,2})$');
    if (!regex.hasMatch(time)) {
      return ValidationResult(
          isValid: false, errorMessage: 'Ungültiges Zeitformat');
    }

    final parts = time.split(':');
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null ||
        hours < 0 ||
        hours > 23 ||
        minutes == null ||
        minutes < 0 ||
        minutes > 59) {
      return ValidationResult(isValid: false, errorMessage: 'Ungültige Zeit');
    }

    return ValidationResult(isValid: true);
  }

  static ValidationResult validateCity(String? city) {
    if (city == null || city.trim().isEmpty) {
      return ValidationResult(isValid: false, errorMessage: 'Ort auswählen');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validatePostalCode(String? postalCode, String? city) {
    if (city == 'Wien' && (postalCode == null || postalCode.trim().isEmpty)) {
      return ValidationResult(isValid: false, errorMessage: 'PLZ auswählen');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Adresse erforderlich');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Name erforderlich');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Email erforderlich');
    }

    if (!isValidEmail(email)) {
      return ValidationResult(
          isValid: false, errorMessage: 'Ungültige Email-Adresse');
    }

    return ValidationResult(isValid: true);
  }

  static ValidationResult validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Telefonnummer erforderlich');
    }

    if (!isValidPhone(phone)) {
      return ValidationResult(
          isValid: false, errorMessage: 'Ungültige Telefonnummer');
    }

    return ValidationResult(isValid: true);
  }

  // FLIGHT VALIDATION METHODS (for FROM AIRPORT)
  static ValidationResult validateFlightFrom(String? flightFrom) {
    if (flightFrom == null || flightFrom.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Abflugort erforderlich');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateFlightNumber(String? flightNumber) {
    if (flightNumber == null || flightNumber.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: 'Flugnummer erforderlich');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateRequiredField(String? value,
      {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
          isValid: false, errorMessage: '$fieldName erforderlich');
    }
    return ValidationResult(isValid: true);
  }

  static ValidationResult validateTermsAccepted(bool? accepted) {
    if (!isChecked(accepted)) {
      return ValidationResult(
          isValid: false,
          errorMessage:
              'Bitte akzeptieren Sie die AGB und Datenschutzerklärung');
    }
    return ValidationResult(isValid: true);
  }

  // Helper to show field errors
  static void showFieldError(
    GlobalKey<FormState> formKey,
    GlobalKey fieldKey,
    String errorMessage,
  ) {
    // Note: Field errors are now handled directly in the widgets
    // This method is kept for backward compatibility
  }

  // Helper to clear field errors
  static void clearFieldError(GlobalKey fieldKey) {
    // Note: Field errors are now handled directly in the widgets
    // This method is kept for backward compatibility
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});
}
