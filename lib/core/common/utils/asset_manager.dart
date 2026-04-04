/// Asset Manager - Centralized asset path management
/// Provides easy access to all images and icons used in the app
class AssetManager {
  AssetManager._();
}

/// Image Asset Paths
/// All image assets used in the application
class ImageAsset {
  ImageAsset._();

  // Logo Images
  static const String appLogo = 'assets/images/app_logo.png';

  /// Order tracking illustrations; folder: `assets/images/order_status/`.
  static const String _orderStatus = 'assets/images/order_status';
  static const String orderStatusPending = '$_orderStatus/pending.png';
  static const String orderStatusConfirmed = '$_orderStatus/confirmed.png';
  static const String orderStatusPreparing = '$_orderStatus/preparing.png';
  static const String orderStatusReadyForPickup =
      '$_orderStatus/ready_for_pickup.png';
  static const String orderStatusAssigned = '$_orderStatus/assigned.png';
  static const String orderStatusPickedUp = orderStatusAssigned;
  static const String orderStatusOnTheWay = '$_orderStatus/on_the_way.png';
  static const String orderStatusDelivered = '$_orderStatus/delivered.png';

  /// [stepIndex] 0–6 matches [orderStatusToTimelineIndex].
  static String timelineStepImagePath(int stepIndex) {
    switch (stepIndex.clamp(0, 6)) {
      case 0:
        return orderStatusPending;
      case 1:
        return orderStatusConfirmed;
      case 2:
        return orderStatusPreparing;
      case 3:
        return orderStatusReadyForPickup;
      case 4:
        return orderStatusAssigned;
      case 5:
        return orderStatusOnTheWay;
      case 6:
        return orderStatusDelivered;
      default:
        return orderStatusPending;
    }
  }
}

/// Icon Asset Paths
/// All icon assets used in the application
class IconAsset {
  IconAsset._();
}
