part of 'update_product_bloc.dart';

abstract class UpdateProductState extends Equatable {
  const UpdateProductState();

  @override
  List<Object?> get props => [];
}

class UpdateProductInitial extends UpdateProductState {
  const UpdateProductInitial();
}

class UpdateProductLoading extends UpdateProductState {
  const UpdateProductLoading();
}

class UpdateProductSuccess extends UpdateProductState {
  final ProductEntity product;

  const UpdateProductSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class UpdateProductError extends UpdateProductState {
  final String message;

  const UpdateProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
