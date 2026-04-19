part of 'edit_settings_bloc.dart';

abstract class EditSettingsEvent extends Equatable {
  const EditSettingsEvent();

  @override
  List<Object?> get props => [];
}

class EditSettingsSubmitted extends EditSettingsEvent {
  final String supportPhone;
  final String whatsappNumber;
  final num defaultProductCommissionRate;
  final int maxIncompleteOrdersForDriverSearch;

  const EditSettingsSubmitted({
    required this.supportPhone,
    required this.whatsappNumber,
    required this.defaultProductCommissionRate,
    required this.maxIncompleteOrdersForDriverSearch,
  });

  @override
  List<Object?> get props => [
        supportPhone,
        whatsappNumber,
        defaultProductCommissionRate,
        maxIncompleteOrdersForDriverSearch,
      ];
}
