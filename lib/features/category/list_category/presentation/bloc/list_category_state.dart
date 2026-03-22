part of 'list_category_bloc.dart';

abstract class ListCategoryState extends Equatable {
  const ListCategoryState();

  @override
  List<Object?> get props => [];
}

class ListCategoryInitial extends ListCategoryState {
  const ListCategoryInitial();
}

class ListCategoryLoading extends ListCategoryState {
  const ListCategoryLoading();
}

class ListCategoryLoaded extends ListCategoryState {
  final List<CategoryEntity> categories;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? search;

  const ListCategoryLoaded({
    required this.categories,
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.search,
  });

  ListCategoryLoaded copyWith({
    List<CategoryEntity>? categories,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? search,
  }) {
    return ListCategoryLoaded(
      categories: categories ?? this.categories,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    hasMore,
    currentPage,
    isLoadingMore,
    isRefreshing,
    search,
  ];
}

class ListCategoryError extends ListCategoryState {
  final String message;

  const ListCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
