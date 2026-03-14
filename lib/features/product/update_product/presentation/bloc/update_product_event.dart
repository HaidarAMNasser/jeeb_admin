part of 'update_product_bloc.dart';

abstract class UpdateProductEvent extends Equatable {
  const UpdateProductEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProductSubmitted extends UpdateProductEvent {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String categoryId;
  final int? quantity;
  final int? servesCount;
  final List<String> images;

  const UpdateProductSubmitted({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.categoryId,
    this.quantity,
    this.servesCount,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        quantity,
        servesCount,
        images,
      ];
}
