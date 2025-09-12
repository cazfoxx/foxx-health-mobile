import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static String? accessToken;
  static String? userEmail;

  static Future<void> setCredentials({String? token, String? email}) async {
    accessToken = token;
    userEmail = email;
    
    // Persist to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('access_token', token);
    }
    if (email != null) {
      await prefs.setString('user_email', email);
    }
    
    log('Credentials set in AppStorage \n token : $accessToken');
  }

  static Future<void> clearCredentials() async {
    accessToken = null;
    userEmail = null;
    
    // Clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_email');
  }

  static Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    userEmail = prefs.getString('user_email');
    
    log('Credentials loaded from storage \n token : $accessToken');
  }
}
