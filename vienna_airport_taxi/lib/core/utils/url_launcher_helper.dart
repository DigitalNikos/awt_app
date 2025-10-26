// lib/core/utils/url_launcher_helper.dart
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Launch phone call with the given [phoneNumber]
  static Future<bool> launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    return await _launchUrl(uri);
  }

  /// Launch email with the given [email]
  static Future<bool> launchEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    return await _launchUrl(uri);
  }

  /// Launch WhatsApp with the given [phoneNumber]
  static Future<bool> launchWhatsApp(String phoneNumber) async {
    // Format phone number (remove any non-numeric characters)
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri uri = Uri.parse('https://wa.me/$formattedNumber');
    return await _launchUrl(uri);
  }

  /// Generic method to launch URLs
  static Future<bool> _launchUrl(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
