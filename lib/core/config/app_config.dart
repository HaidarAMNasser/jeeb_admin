/// Application Configuration
class AppConfig {
  AppConfig._();

  static const String appName = 'zawada';
  static const String appVersion = '1.0.1';
  static const String buildNumber = '2';

  // Developer Info
  static const String developerName = 'Haidar Nasser';
  static const String developerEmail = 'haideramnasser09@gmail.com';

  // Environment — set [isProduction] false for local/dev builds.
  static const bool isProduction = true;
  static const bool enableLogging = !isProduction;
  // static bool get enableChucker => false;

  // API Configuration
  static String get baseUrl {
    return 'https://dev-api.jeeb2.com/api/v1/';
  }

  /// Base URL for user/media assets (profile images etc.). Backend may return relative paths.
  static String get assetsBaseUrl {
    final u = baseUrl;
    final match = RegExp(r'^(https?://[^/]+)').firstMatch(u);
    return match != null ? '${match.group(1)}/' : u;
  }
}
