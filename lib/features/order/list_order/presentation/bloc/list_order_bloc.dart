import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/list_order/data/repositories/list_order_repository.dart';
import 'package:jeeb_admin/features/order/list_order/domain/merchant_orders_tab.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';

part 'list_order_event.dart';
part 'list_order_state.dart';

class ListOrderBloc extends Bloc<ListOrderEvent, ListOrderState> {
  final ListOrderRepository _repository;
  static const int _pageSize = 20;

  /// Set on confirm success; attached to next [ListOrderLoaded] then cleared here.
  String? _pendingMerchantEducationOrderId;

  ListOrderBloc(this._repository) : super(const ListOrderInitial()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<ConfirmOrderEvent>(_onConfirmOrder);
    on<ClearMerchantEducationDialogEvent>(_onClearMerchantEducation);
    on<MerchantSetPreparingEvent>(_onMerchantSetPreparing);
    on<MerchantSetReadyForPickupEvent>(_onMerchantSetReadyForPickup);
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
