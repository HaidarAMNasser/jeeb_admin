/// Google Cloud API keys used by the app (HTTP Directions).
///
/// Override at build time: `--dart-define=GOOGLE_DIRECTIONS_API_KEY=...`
/// Restrict the key in Google Cloud Console (API restrictions + app/HTTP).
class GoogleApiConfig {
  GoogleApiConfig._();

  static const String directionsApiKey = String.fromEnvironment(
    'GOOGLE_DIRECTIONS_API_KEY',
    defaultValue: 'AIzaSyAdqlE7f_SLca5cAAxAxDXIqRDjm0uNCes',
  );
}
