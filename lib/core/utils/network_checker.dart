import 'dart:io';

class NetworkChecker {
  /// Returns true if an internet connection is available, false otherwise.
  static Future<bool> hasConnection() async {
    try {
      // Wrap the lookup in a timeout of 5 seconds.
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
