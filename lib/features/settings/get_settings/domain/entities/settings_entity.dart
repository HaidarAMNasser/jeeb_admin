import 'package:equatable/equatable.dart';

/// Entity for admin-editable settings from GET/PATCH `/settings`.
class SettingsEntity extends Equatable {
  final String supportPhone;
  final String whatsappNumber;
  final num defaultProductCommissionRate;
  final num deliveryTipPerKilometer;
  /// API key: `maxOrdersPerDelivery` (max orders a driver may handle per day / per delivery scope).
  final int maxOrdersPerDelivery;

  const SettingsEntity({
    required this.supportPhone,
    required this.whatsappNumber,
    required this.defaultProductCommissionRate,
    this.deliveryTipPerKilometer = 0,
    required this.maxOrdersPerDelivery,
  });

  @override
  List<Object?> get props => [
        supportPhone,
        whatsappNumber,
        defaultProductCommissionRate,
        deliveryTipPerKilometer,
        maxOrdersPerDelivery,
      ];
}
