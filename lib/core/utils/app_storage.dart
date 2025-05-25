import 'dart:developer';

class AppStorage {
  static String? accessToken;
  static String? userEmail;

  static void setCredentials({String? token, String? email}) {
    accessToken = token;
    userEmail = email;
    log('Credentials set in AppStorage \n token : $accessToken'); // Add this line (optional)
  }

  static void clearCredentials() {
    accessToken = null;
    userEmail = null;
  }
}
