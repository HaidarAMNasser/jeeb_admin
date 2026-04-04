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

  /// API `status` query (uppercase wire). `null` = use [merchantTab] mapping only ("follow tab").
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
  List<Object?> get props =>
      [orderId, mealPreparationMinutes, deliveryMinutes];
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
