part of 'list_product_bloc.dart';

abstract class ListProductState extends Equatable {
  const ListProductState();

  @override
  List<Object?> get props => [];
}

class ListProductInitial extends ListProductState {
  const ListProductInitial();
}

class ListProductLoading extends ListProductState {
  const ListProductLoading();
}

class ListProductLoaded extends ListProductState {
  final List<ProductEntity> products;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? merchantId;
  final String? search;

  const ListProductLoaded({
    required this.products,
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.merchantId,
    this.search,
  });

  ListProductLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? merchantId,
    String? search,
  }) {
    return ListProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      merchantId: merchantId ?? this.merchantId,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [
    products,
    hasMore,
    currentPage,
    isLoadingMore,
    isRefreshing,
    merchantId,
    search,
  ];
}

class ListProductError extends ListProductState {
  final String message;

  const ListProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

