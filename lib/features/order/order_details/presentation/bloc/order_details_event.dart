part of 'order_details_bloc.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetOrderDetailsEvent extends OrderDetailsEvent {
  final String id;

  const GetOrderDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ConfirmMerchantOrderEvent extends OrderDetailsEvent {
  final int mealPreparationMinutes;

  const ConfirmMerchantOrderEvent({required this.mealPreparationMinutes});

  @override
  List<Object?> get props => [mealPreparationMinutes];
}

class MerchantSetPreparingEvent extends OrderDetailsEvent {
  const MerchantSetPreparingEvent();
}

class MerchantSetReadyForPickupEvent extends OrderDetailsEvent {
  const MerchantSetReadyForPickupEvent();
}

class ClearMerchantEducationDialogEvent extends OrderDetailsEvent {
  const ClearMerchantEducationDialogEvent();
}
