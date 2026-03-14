part of 'create_product_bloc.dart';

abstract class CreateProductEvent extends Equatable {
  const CreateProductEvent();

  @override
  List<Object?> get props => [];
}

class InitializeProductForm extends CreateProductEvent {
  final ProductEntity? product; // null for create, ProductEntity for edit

  const InitializeProductForm({this.product});

  @override
  List<Object?> get props => [product];
}

class UpdateProductName extends CreateProductEvent {
  final String name;

  const UpdateProductName({required this.name});

  @override
  List<Object> get props => [name];
}

class UpdateProductDescription extends CreateProductEvent {
  final String description;

  const UpdateProductDescription({required this.description});

  @override
  List<Object> get props => [description];
}

class UpdateProductPrice extends CreateProductEvent {
  final String price;

  const UpdateProductPrice({required this.price});

  @override
  List<Object> get props => [price];
}

class UpdateProductQuantity extends CreateProductEvent {
  final String quantity;

  const UpdateProductQuantity({required this.quantity});

  @override
  List<Object> get props => [quantity];
}

class UpdateProductServesCount extends CreateProductEvent {
  final String servesCount;

  const UpdateProductServesCount({required this.servesCount});

  @override
  List<Object> get props => [servesCount];
}

class UpdateSelectedCategory extends CreateProductEvent {
  final String? categoryId;

  const UpdateSelectedCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class AddProductImage extends CreateProductEvent {
  final String imageUrl;

  const AddProductImage({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class RemoveProductImage extends CreateProductEvent {
  final int index;

  const RemoveProductImage({required this.index});

  @override
  List<Object> get props => [index];
}

class CreateProductSubmitted extends CreateProductEvent {
  const CreateProductSubmitted();
}

class CheckValidationEvent extends CreateProductEvent {
  const CheckValidationEvent();
}

class ResetForm extends CreateProductEvent {
  const ResetForm();
}

