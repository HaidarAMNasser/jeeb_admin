part of 'order_details_bloc.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {
  const OrderDetailsInitial();
}

class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderEntity order;
  final bool isConfirming;
  final bool isKitchenLoading;

  /// After confirm success: show pipeline education once UI consumes it (then clear).
  final bool merchantEducationPending;

  const OrderDetailsLoaded({
    required this.order,
    this.isConfirming = false,
    this.isKitchenLoading = false,
    this.merchantEducationPending = false,
  });

  OrderDetailsLoaded copyWith({
    OrderEntity? order,
    bool? isConfirming,
    bool? isKitchenLoading,
    bool? merchantEducationPending,
    bool clearConfirming = false,
    bool clearKitchenLoading = false,
    bool clearMerchantEducation = false,
  }) {
    return OrderDetailsLoaded(
      order: order ?? this.order,
      isConfirming: clearConfirming ? false : (isConfirming ?? this.isConfirming),
      isKitchenLoading:
          clearKitchenLoading ? false : (isKitchenLoading ?? this.isKitchenLoading),
      merchantEducationPending: clearMerchantEducation
          ? false
          : (merchantEducationPending ?? this.merchantEducationPending),
    );
  }

  @override
  List<Object?> get props => [
        order,
        isConfirming,
        isKitchenLoading,
        merchantEducationPending,
      ];
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  const OrderDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
