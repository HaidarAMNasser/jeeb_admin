import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/list_order/data/repositories/list_order_repository.dart';
import 'package:jeeb_admin/features/order/order_details/data/repositories/order_details_repository.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDetailsRepository _repository;
  final ListOrderRepository _listOrderRepository;

  /// Set on confirm success; attached to next [OrderDetailsLoaded] then cleared here.
  bool _pendingMerchantEducation = false;

  OrderDetailsBloc(this._repository, this._listOrderRepository)
    : super(const OrderDetailsInitial()) {
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<ConfirmMerchantOrderEvent>(_onConfirmMerchantOrder);
    on<MerchantSetPreparingEvent>(_onMerchantSetPreparing);
    on<MerchantSetReadyForPickupEvent>(_onMerchantSetReadyForPickup);
    on<ClearMerchantEducationDialogEvent>(_onClearMerchantEducation);
  }

  Future<void> _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(const OrderDetailsLoading());
    final result = await _repository.getOrderDetails(event.id);

    result.fold(
      (failure) => emit(OrderDetailsError(message: failure.message)),
      (order) {
        final showEducation = _pendingMerchantEducation;
        _pendingMerchantEducation = false;
        emit(
          OrderDetailsLoaded(
            order: order,
            merchantEducationPending: showEducation,
          ),
        );
      },
    );
  }

  Future<void> _onConfirmMerchantOrder(
    ConfirmMerchantOrderEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    final previous = state;
    if (previous is! OrderDetailsLoaded) return;

    emit(previous.copyWith(isConfirming: true));

    final result = await _listOrderRepository.confirmOrder(
      previous.order.id,
      mealPreparationTime: event.mealPreparationMinutes,
    );

    result.fold(
      (failure) {
        emit(previous.copyWith(clearConfirming: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderConfirmedSuccessfully);
        _pendingMerchantEducation = true;
        emit(previous.copyWith(clearConfirming: true));
        add(GetOrderDetailsEvent(previous.order.id));
      },
    );
  }

  Future<void> _onMerchantSetPreparing(
    MerchantSetPreparingEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    final previous = state;
    if (previous is! OrderDetailsLoaded) return;

    emit(previous.copyWith(isKitchenLoading: true));

    final result = await _listOrderRepository.setOrderPreparing(
      previous.order.id,
    );

    result.fold(
      (failure) {
        emit(previous.copyWith(clearKitchenLoading: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
        emit(previous.copyWith(clearKitchenLoading: true));
        add(GetOrderDetailsEvent(previous.order.id));
      },
    );
  }

  Future<void> _onMerchantSetReadyForPickup(
    MerchantSetReadyForPickupEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    final previous = state;
    if (previous is! OrderDetailsLoaded) return;

    emit(previous.copyWith(isKitchenLoading: true));

    final result = await _listOrderRepository.setOrderReadyForPickup(
      previous.order.id,
    );

    result.fold(
      (failure) {
        emit(previous.copyWith(clearKitchenLoading: true));
        customToast(msg: failure.message);
      },
      (_) {
        customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
        emit(previous.copyWith(clearKitchenLoading: true));
        add(GetOrderDetailsEvent(previous.order.id));
      },
    );
  }

  void _onClearMerchantEducation(
    ClearMerchantEducationDialogEvent event,
    Emitter<OrderDetailsState> emit,
  ) {
    final s = state;
    if (s is! OrderDetailsLoaded) return;
    emit(s.copyWith(clearMerchantEducation: true));
  }
}
