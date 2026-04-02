import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

/// Localized labels for the 7 tracking steps (indices 0–6).
class OrderStatusStepLabels {
  OrderStatusStepLabels._();

  static List<String> asList() => [
        AppTranslation.orderStepPlaced,
        AppTranslation.orderStepConfirmed,
        AppTranslation.orderStepSearching,
        AppTranslation.orderStepReady,
        AppTranslation.orderStepWithDriver,
        AppTranslation.orderStepOnTheWay,
        AppTranslation.orderStepDelivered,
      ];
}
