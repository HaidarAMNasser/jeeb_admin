part of 'list_delivery_bloc.dart';

abstract class ListDeliveryState extends Equatable {
  const ListDeliveryState();

  @override
  List<Object?> get props => [];
}

class ListDeliveryInitial extends ListDeliveryState {
  const ListDeliveryInitial();
}

class ListDeliveryLoading extends ListDeliveryState {
  const ListDeliveryLoading();
}

class ListDeliveryLoaded extends ListDeliveryState {
  final List<DeliveryManEntity> deliveryMen;
  final bool hasMore;
  final int currentPage;

  const ListDeliveryLoaded({
    required this.deliveryMen,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [deliveryMen, hasMore, currentPage];
}

class ListDeliveryError extends ListDeliveryState {
  final String message;

  const ListDeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ListDeliveryLoadingMore extends ListDeliveryState {
  final List<DeliveryManEntity> deliveryMen;
  final int currentPage;

  const ListDeliveryLoadingMore({
    required this.deliveryMen,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [deliveryMen, currentPage];
}
