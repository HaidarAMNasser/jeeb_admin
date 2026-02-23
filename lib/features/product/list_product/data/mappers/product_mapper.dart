import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

extension ProductMapper on ProductModel {
  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      categoryName: categoryName,
      quantity: quantity,
      images: images,
      rating: rating,
    );
  }
}

extension ProductListMapper on List<ProductModel> {
  List<ProductEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}

