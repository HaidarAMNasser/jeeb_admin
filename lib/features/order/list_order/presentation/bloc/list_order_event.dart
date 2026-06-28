part of 'list_order_bloc.dart';

abstract class ListOrderEvent extends Equatable {
  const ListOrderEvent();

  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends ListOrderEvent {
  final bool loadMore;
  final String? search;
  final String? merchantId;
  final MerchantOrdersTab? merchantTab;
  final String? statusFilter;
  const GetOrdersEvent({
    this.loadMore = false,
    this.search,
    this.merchantId,
    this.merchantTab,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [
    loadMore,
    search ?? '',
    merchantId ?? '',
    merchantTab,
    statusFilter,
  ];
}

class ConfirmOrderEvent extends ListOrderEvent {
  final String orderId;
  final int? mealPreparationMinutes;
  final int? deliveryMinutes;

  const ConfirmOrderEvent({
    required this.orderId,
    this.mealPreparationMinutes,
    this.deliveryMinutes,
  });

  @override
  List<Object?> get props => [orderId, mealPreparationMinutes, deliveryMinutes];
}

/// A single order's status changed remotely (Firebase RTDB).
///
/// Updates only that order in place instead of refetching the whole list.
/// If the new status no longer matches the active filter/tab, the order is
/// removed from the current view.
class OrderRtdbStatusChanged extends ListOrderEvent {
  final String orderId;

  /// Raw RTDB status value (case-insensitive); null/unknown values are ignored.
  final String? status;

  const OrderRtdbStatusChanged({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class ClearMerchantEducationDialogEvent extends ListOrderEvent {
  const ClearMerchantEducationDialogEvent();
}

class MerchantSetPreparingEvent extends ListOrderEvent {
  const MerchantSetPreparingEvent(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class MerchantSetReadyForPickupEvent extends ListOrderEvent {
  const MerchantSetReadyForPickupEvent(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}
