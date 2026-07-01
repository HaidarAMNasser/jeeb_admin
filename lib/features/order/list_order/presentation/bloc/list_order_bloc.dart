import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/list_order/data/repositories/list_order_repository.dart';
import 'package:jeeb_admin/features/order/list_order/domain/merchant_orders_tab.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

part 'list_order_event.dart';
part 'list_order_state.dart';

class ListOrderBloc extends Bloc<ListOrderEvent, ListOrderState> {
  final ListOrderRepository _repository;
  static const int _pageSize = 20;

  /// Set on confirm success; attached to next [ListOrderLoaded] then cleared here.
  String? _pendingMerchantEducationOrderId;

  OrderListFetchParams? _lastFetchParams;

  /// Query params from the most recent list fetch (survives [ListOrderError]).
  OrderListFetchParams? get lastFetchParams => _lastFetchParams;

  ListOrderBloc(this._repository) : super(const ListOrderInitial()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<ConfirmOrderEvent>(_onConfirmOrder);
    on<ClearMerchantEducationDialogEvent>(_onClearMerchantEducation);
    on<MerchantSetPreparingEvent>(_onMerchantSetPreparing);
    on<MerchantSetReadyForPickupEvent>(_onMerchantSetReadyForPickup);
    on<OrderRtdbStatusChanged>(_onOrderRtdbStatusChanged);
  }

  void _resolveStatusParams({
    required MerchantOrdersTab? merchantTab,
    required String? statusFilter,
    required void Function(String? apiStatus, bool filterOthers) onResolved,
  }) {
    final trimmed = statusFilter?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      onResolved(trimmed, false);
      return;
    }
    if (merchantTab != null) {
      onResolved(
        merchantTabToApiStatus(merchantTab),
        merchantTab == MerchantOrdersTab.others,
      );
      return;
    }
    onResolved(null, false);
  }

  Future<void> _onGetOrders(
    GetOrdersEvent event,
    Emitter<ListOrderState> emit,
  ) async {
    if (event.loadMore) {
      final currentState = state;
      if (currentState is! ListOrderLoaded) return;
      if (!currentState.hasMore || currentState.isLoadingMore) return;

      final searchQuery = event.search ?? currentState.search;
      final merchantId = event.merchantId ?? currentState.merchantId;
      final tab = event.merchantTab ?? currentState.merchantTab;
      final statusFilter = currentState.statusFilter;

      String? apiStatus;
      var filterOthers = false;
      _resolveStatusParams(
        merchantTab: tab,
        statusFilter: statusFilter,
        onResolved: (a, f) {
          apiStatus = a;
          filterOthers = f;
        },
      );

      _lastFetchParams = OrderListFetchParams(
        search: searchQuery,
        merchantId: merchantId,
        merchantTab: tab,
        statusFilter: statusFilter,
      );

      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      final result = await _repository.getOrders(
        page: nextPage,
        limit: _pageSize,
        search: searchQuery,
        merchantId: merchantId,
        status: apiStatus,
        filterMerchantOthers: filterOthers,
      );

      result.fold(
        (_) => emit(currentState.copyWith(isLoadingMore: false)),
        (newOrders) {
          final updatedOrders = [...currentState.orders, ...newOrders];
          emit(ListOrderLoaded(
            orders: updatedOrders,
            hasMore: newOrders.length >= _pageSize,
            currentPage: nextPage,
            search: searchQuery,
            merchantId: merchantId,
            isLoadingMore: false,
            merchantTab: tab,
            confirmingOrderId: currentState.confirmingOrderId,
            statusFilter: statusFilter,
            merchantEducationPendingOrderId:
                currentState.merchantEducationPendingOrderId,
            kitchenActionLoadingOrderId:
                currentState.kitchenActionLoadingOrderId,
          ));
        },
      );
      return;
    }

    String? apiStatus;
    var filterOthers = false;
    _resolveStatusParams(
      merchantTab: event.merchantTab,
      statusFilter: event.statusFilter,
      onResolved: (a, f) {
        apiStatus = a;
        filterOthers = f;
      },
    );

    final sf = event.statusFilter?.trim();
    _lastFetchParams = OrderListFetchParams(
      search: event.search,
      merchantId: event.merchantId,
      merchantTab: event.merchantTab,
      statusFilter: (sf == null || sf.isEmpty) ? null : sf,
    );

    emit(const ListOrderLoading());
    final result = await _repository.getOrders(
      page: 1,
      limit: _pageSize,
      search: event.search,
      merchantId: event.merchantId,
      status: apiStatus,
      filterMerchantOthers: filterOthers,
    );

    result.fold(
      (failure) => emit(ListOrderError(message: failure.message)),
      (orders) {
        final sf = event.statusFilter?.trim();
        final educationId = _pendingMerchantEducationOrderId;
        _pendingMerchantEducationOrderId = null;
        emit(ListOrderLoaded(
          orders: orders,
          hasMore: orders.length >= _pageSize,
          currentPage: 1,
          search: event.search,
          merchantId: event.merchantId,
          isLoadingMore: false,
          merchantTab: event.merchantTab,
          statusFilter: (sf == null || sf.isEmpty) ? null : sf,
          merchantEducationPendingOrderId: educationId,
        ));
      },
    );
  }

  Future<void> _onConfirmOrder(
    ConfirmOrderEvent event,
    Emitter<ListOrderState> emit,
  ) async {
    final previous = state;
    if (previous is! ListOrderLoaded) return;

    emit(previous.copyWith(confirmingOrderId: event.orderId));

    final result = await _repository.confirmOrder(
      event.orderId,
      mealPreparationTime: event.mealPreparationMinutes,
      deliveryTime: event.deliveryMinutes,
    );

    result.fold(
      (failure) {
        emit(previous.copyWith(clearConfirmingOrderId: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderConfirmedSuccessfully);
        _pendingMerchantEducationOrderId = event.orderId;
        emit(previous.copyWith(clearConfirmingOrderId: true));
        add(GetOrdersEvent(
          search: previous.search,
          merchantId: previous.merchantId,
          merchantTab: previous.merchantTab,
          statusFilter: previous.statusFilter,
        ));
      },
    );
  }

  /// Applies a remote (RTDB) status change to a single order without refetching
  /// the whole list. Removes the order from the current view if its new status
  /// no longer matches the active filter/tab.
  void _onOrderRtdbStatusChanged(
    OrderRtdbStatusChanged event,
    Emitter<ListOrderState> emit,
  ) {
    final s = state;
    if (s is! ListOrderLoaded) return;

    final index = s.orders.indexWhere((o) => o.id == event.orderId);
    if (index < 0) return; // not currently on screen

    final newStatus = OrderStatus.fromString(event.status);
    // Ignore null / unrecognized values so we never corrupt a real status.
    if (newStatus == OrderStatus.unknown) return;

    final current = s.orders[index];
    if (current.statusEnum == newStatus) return; // no-op, avoids rebuilds

    final updated = current.copyWith(status: newStatus.apiWireValue);

    final updatedOrders = List<OrderEntity>.of(s.orders);
    if (_matchesActiveFilter(updated, s)) {
      updatedOrders[index] = updated;
    } else {
      updatedOrders.removeAt(index);
    }

    emit(s.copyWith(orders: updatedOrders));
  }

  /// Whether [order] still belongs in the list given the active filter/tab.
  /// Mirrors the status logic applied server-side in [_resolveStatusParams] +
  /// the repository's `filterMerchantOthers`.
  bool _matchesActiveFilter(OrderEntity order, ListOrderLoaded state) {
    final sf = state.statusFilter?.trim();
    if (sf != null && sf.isNotEmpty) {
      return order.statusEnum.apiWireValue == sf.toUpperCase();
    }
    final tab = state.merchantTab;
    if (tab != null) {
      switch (tab) {
        case MerchantOrdersTab.pending:
          return order.statusEnum == OrderStatus.pending;
        case MerchantOrdersTab.preparing:
          return order.statusEnum == OrderStatus.preparing;
        case MerchantOrdersTab.others:
          return order.statusEnum != OrderStatus.pending &&
              order.statusEnum != OrderStatus.preparing;
      }
    }
    return true; // no status filter active
  }

  void _onClearMerchantEducation(
    ClearMerchantEducationDialogEvent event,
    Emitter<ListOrderState> emit,
  ) {
    final s = state;
    if (s is! ListOrderLoaded) return;
    emit(s.copyWith(clearMerchantEducation: true));
  }

  Future<void> _onMerchantSetPreparing(
    MerchantSetPreparingEvent event,
    Emitter<ListOrderState> emit,
  ) async {
    final previous = state;
    if (previous is! ListOrderLoaded) return;

    emit(previous.copyWith(kitchenActionLoadingOrderId: event.orderId));

    final result = await _repository.setOrderPreparing(event.orderId);

    result.fold(
      (failure) {
        emit(previous.copyWith(clearKitchenAction: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
        emit(previous.copyWith(clearKitchenAction: true));
        add(GetOrdersEvent(
          search: previous.search,
          merchantId: previous.merchantId,
          merchantTab: previous.merchantTab,
          statusFilter: previous.statusFilter,
        ));
      },
    );
  }

  Future<void> _onMerchantSetReadyForPickup(
    MerchantSetReadyForPickupEvent event,
    Emitter<ListOrderState> emit,
  ) async {
    final previous = state;
    if (previous is! ListOrderLoaded) return;

    emit(previous.copyWith(kitchenActionLoadingOrderId: event.orderId));

    final result = await _repository.setOrderReadyForPickup(event.orderId);

    result.fold(
      (failure) {
        emit(previous.copyWith(clearKitchenAction: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
        emit(previous.copyWith(clearKitchenAction: true));
        add(GetOrdersEvent(
          search: previous.search,
          merchantId: previous.merchantId,
          merchantTab: previous.merchantTab,
          statusFilter: previous.statusFilter,
        ));
      },
    );
  }
}
