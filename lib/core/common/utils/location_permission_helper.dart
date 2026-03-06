import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Helper for location permission and fetching current position.
/// Used when merchant chooses "Use my location" during registration.
class LocationPermissionHelper {
  LocationPermissionHelper._();

  /// Request location permission (when in use).
  /// Returns true if granted, false otherwise.
  /// If permanently denied, opens app settings.
  static Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.locationWhenInUse.status;

      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      final result = await Permission.locationWhenInUse.request();
      return result.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Check if location permission is granted.
  static Future<bool> isLocationPermissionGranted() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Get current position. Requires location permission.
  /// Returns null on failure (permission denied, service disabled, or error).
  static Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final hasPermission = await isLocationPermissionGranted();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Request permission and get current position in one call.
  /// Returns (lat, lng) or null if failed.
  static Future<({double latitude, double longitude})?> requestAndGetPosition() async {
    final granted = await requestLocationPermission();
    if (!granted) return null;

    final position = await getCurrentPosition();
    if (position == null) return null;

    return (latitude: position.latitude, longitude: position.longitude);
  }
}
