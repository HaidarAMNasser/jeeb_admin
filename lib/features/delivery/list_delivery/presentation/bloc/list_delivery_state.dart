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
  final String? search;
  final bool isLoadingMore;

  const ListDeliveryLoaded({
    required this.deliveryMen,
    this.hasMore = true,
    this.currentPage = 1,
    this.search,
    this.isLoadingMore = false,
  });

  ListDeliveryLoaded copyWith({
    List<DeliveryManEntity>? deliveryMen,
    bool? hasMore,
    int? currentPage,
    String? search,
    bool? isLoadingMore,
  }) {
    return ListDeliveryLoaded(
      deliveryMen: deliveryMen ?? this.deliveryMen,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      search: search ?? this.search,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [deliveryMen, hasMore, currentPage, search, isLoadingMore];
}

class ListDeliveryError extends ListDeliveryState {
  final String message;

  const ListDeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}

