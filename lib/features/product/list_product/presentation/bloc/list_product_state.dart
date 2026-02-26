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

  const ListProductLoaded({
    required this.products,
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  ListProductLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return ListProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, currentPage, isLoadingMore];
}

class ListProductLoadingMore extends ListProductState {
  final List<ProductEntity> products;
  final int currentPage;

  const ListProductLoadingMore({
    required this.products,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [products, currentPage];
}

class ListProductError extends ListProductState {
  final String message;

  const ListProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

