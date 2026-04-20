import 'package:equatable/equatable.dart';

/// Entity for admin-editable settings from GET/PATCH `/settings`.
class SettingsEntity extends Equatable {
  final String supportPhone;
  final String whatsappNumber;
  final num defaultProductCommissionRate;
  final num deliveryTipPerKilometer;
  /// Max active (incomplete) orders a driver may have before new assignments are blocked.
  final int maxIncompleteOrdersForDriverSearch;

  const SettingsEntity({
    required this.supportPhone,
    required this.whatsappNumber,
    required this.defaultProductCommissionRate,
    this.deliveryTipPerKilometer = 0,
    required this.maxIncompleteOrdersForDriverSearch,
  });

  @override
  List<Object?> get props => [
        supportPhone,
        whatsappNumber,
        defaultProductCommissionRate,
        deliveryTipPerKilometer,
        maxIncompleteOrdersForDriverSearch,
      ];
}
