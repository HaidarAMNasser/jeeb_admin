import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String categoryId;
  final String categoryName;
  final int? quantity;
  final List<String> images;
  final double? rating; // تقييم

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    this.quantity,
    required this.images,
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        categoryName,
        quantity,
        images,
        rating,
      ];
}

