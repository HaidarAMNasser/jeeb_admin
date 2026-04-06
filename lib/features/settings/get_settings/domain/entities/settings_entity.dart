import 'package:equatable/equatable.dart';

/// Entity for the three admin-editable settings: support phone, WhatsApp number, commission rate.
class SettingsEntity extends Equatable {
  final String supportPhone;
  final String whatsappNumber;
  final num defaultProductCommissionRate;
  final num deliveryTipPerKilometer;

  const SettingsEntity({
    required this.supportPhone,
    required this.whatsappNumber,
    required this.defaultProductCommissionRate,
    this.deliveryTipPerKilometer = 0,
  });

  @override
  List<Object?> get props => [
        supportPhone,
        whatsappNumber,
        defaultProductCommissionRate,
        deliveryTipPerKilometer,
      ];
}
