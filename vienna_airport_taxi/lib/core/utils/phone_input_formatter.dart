import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ensure the text always starts with '+'
    String newText = newValue.text;

    // If user tries to delete the '+', restore it
    if (!newText.startsWith('+')) {
      newText = '+$newText';
    }

    // Remove any non-digit characters except the leading '+'
    String cleanText = '+';
    for (int i = 1; i < newText.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(newText[i])) {
        cleanText += newText[i];
      }
    }

    // Limit total length (+ plus up to 15 digits for international format)
    if (cleanText.length > 16) {
      cleanText = cleanText.substring(0, 16);
    }

    // Calculate cursor position
    int selectionIndex = newValue.selection.end;
    int difference = cleanText.length - newValue.text.length;
    selectionIndex += difference;

    // Ensure cursor doesn't go before the '+' or after the text
    selectionIndex = selectionIndex.clamp(1, cleanText.length);

    return TextEditingValue(
      text: cleanText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PhoneInputController extends TextEditingController {
  PhoneInputController({String? text}) : super(text: text ?? '');

  @override
  set text(String newText) {
    // Only format if text has content
    if (newText.isNotEmpty && !newText.startsWith('+')) {
      super.text = '+$newText';
    } else {
      super.text = newText;
    }
  }

  // Method to initialize with +43 when field gets focus
  void initializeWithPrefix() {
    if (text.isEmpty) {
      text = '+43';
      // Move cursor to end
      selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    }
  }

  // Method to get the phone number without the country code
  String getPhoneWithoutCountryCode() {
    if (text.startsWith('+43')) {
      return text.substring(3);
    } else if (text.startsWith('+')) {
      return text.substring(1);
    }
    return text;
  }

  // Method to get the full international format
  String getInternationalFormat() {
    return text;
  }

  // Method to check if field is empty or has only prefix
  bool isEmpty() {
    return text.isEmpty || text == '+' || text == '+43';
  }
}
