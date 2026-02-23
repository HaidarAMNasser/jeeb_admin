part of 'delete_product_bloc.dart';

abstract class DeleteProductState extends Equatable {
  const DeleteProductState();

  @override
  List<Object?> get props => [];
}

class DeleteProductInitial extends DeleteProductState {
  const DeleteProductInitial();
}

class DeleteProductLoading extends DeleteProductState {
  const DeleteProductLoading();
}

class DeleteProductSuccess extends DeleteProductState {
  const DeleteProductSuccess();
}

class DeleteProductError extends DeleteProductState {
  final String message;

  const DeleteProductError({required this.message});

  @override
  List<Object> get props => [message];
}

