part of 'list_order_bloc.dart';

/// Last query used for a list fetch; kept across [ListOrderError] for retry.
class OrderListFetchParams extends Equatable {
  final String? search;
  final String? merchantId;
  final MerchantOrdersTab? merchantTab;
  final String? statusFilter;

  const OrderListFetchParams({
    this.search,
    this.merchantId,
    this.merchantTab,
    this.statusFilter,
  });

  GetOrdersEvent toEvent({bool clearSearch = false}) => GetOrdersEvent(
        search: clearSearch ? null : search,
        merchantId: merchantId,
        merchantTab: merchantTab,
        statusFilter: statusFilter,
      );

  @override
  List<Object?> get props => [search, merchantId, merchantTab, statusFilter];
}

abstract class ListOrderState extends Equatable {
  const ListOrderState();

  @override
  List<Object?> get props => [];
}

class ListOrderInitial extends ListOrderState {
  const ListOrderInitial();
}

class ListOrderLoading extends ListOrderState {
  const ListOrderLoading();
}

class ListOrderLoaded extends ListOrderState {
  final List<OrderEntity> orders;
  final bool hasMore;
  final int currentPage;
  final String? search;
  final String? merchantId;
  final bool isLoadingMore;
  final MerchantOrdersTab? merchantTab;
  final String? confirmingOrderId;

  /// When non-null, overrides tab-based status on the API until cleared.
  final String? statusFilter;

  /// After confirm success: show pipeline education once UI consumes it (then clear).
  final String? merchantEducationPendingOrderId;

  /// Order id while a kitchen status API call is in flight.
  final String? kitchenActionLoadingOrderId;

  const ListOrderLoaded({
    required this.orders,
    this.hasMore = true,
    this.currentPage = 1,
    this.search,
    this.merchantId,
    this.isLoadingMore = false,
    this.merchantTab,
    this.confirmingOrderId,
    this.statusFilter,
    this.merchantEducationPendingOrderId,
    this.kitchenActionLoadingOrderId,
  });

  /// True after applying status filter from the sheet and/or a non-empty search.
  bool get isFiltered =>
      (search != null && search!.trim().isNotEmpty) ||
      (statusFilter != null && statusFilter!.trim().isNotEmpty);

  ListOrderLoaded copyWith({
    List<OrderEntity>? orders,
    bool? hasMore,
    int? currentPage,
    String? search,
    String? merchantId,
    bool? isLoadingMore,
    MerchantOrdersTab? merchantTab,
    String? confirmingOrderId,
    String? statusFilter,
    String? merchantEducationPendingOrderId,
    String? kitchenActionLoadingOrderId,
    bool clearConfirmingOrderId = false,
    bool clearStatusFilter = false,
    bool clearMerchantEducation = false,
    bool clearKitchenAction = false,
  }) {
    return ListOrderLoaded(
      orders: orders ?? this.orders,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      search: search ?? this.search,
      merchantId: merchantId ?? this.merchantId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      merchantTab: merchantTab ?? this.merchantTab,
      confirmingOrderId: clearConfirmingOrderId
          ? null
          : (confirmingOrderId ?? this.confirmingOrderId),
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      merchantEducationPendingOrderId: clearMerchantEducation
          ? null
          : (merchantEducationPendingOrderId ??
              this.merchantEducationPendingOrderId),
      kitchenActionLoadingOrderId: clearKitchenAction
          ? null
          : (kitchenActionLoadingOrderId ?? this.kitchenActionLoadingOrderId),
    );
  }

  @override
  List<Object?> get props => [
        orders,
        hasMore,
        currentPage,
        search,
        merchantId,
        isLoadingMore,
        merchantTab,
        confirmingOrderId,
        statusFilter,
        merchantEducationPendingOrderId,
        kitchenActionLoadingOrderId,
      ];
}

class ListOrderError extends ListOrderState {
  final String message;

  const ListOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
