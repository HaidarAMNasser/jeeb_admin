part of 'list_order_bloc.dart';

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

  const ListOrderLoaded({
    required this.orders,
    this.hasMore = true,
    this.currentPage = 1,
    this.search,
    this.merchantId,
    this.isLoadingMore = false,
  });

  ListOrderLoaded copyWith({
    List<OrderEntity>? orders,
    bool? hasMore,
    int? currentPage,
    String? search,
    String? merchantId,
    bool? isLoadingMore,
  }) {
    return ListOrderLoaded(
      orders: orders ?? this.orders,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      search: search ?? this.search,
      merchantId: merchantId ?? this.merchantId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [orders, hasMore, currentPage, search, merchantId, isLoadingMore];
}

class ListOrderError extends ListOrderState {
  final String message;

  const ListOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}


