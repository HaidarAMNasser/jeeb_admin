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

  const ListProductLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ListProductError extends ListProductState {
  final String message;

  const ListProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

