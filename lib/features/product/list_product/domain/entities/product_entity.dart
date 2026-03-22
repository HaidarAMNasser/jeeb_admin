import 'package:equatable/equatable.dart';
import 'product_image_entity.dart';
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? shortDescription;
  final int price; // Price in smallest currency unit (e.g., 1299 for 12.99)
  final int? priceAfterDiscount;
  final String? restaurantId;
  final String? categoryId;
  final String? categoryName;
  final int? discount;
  final String? discountType; // 'PERCENTAGE' or 'FIXED'
  final bool? hasStock;
  final int? stockQuantity;
  final int? servesCount;
  final bool? isAvailable;
  final bool? isExternal;
  final String? externalProvider;
  final String? externalId;
  final String? merchantId;
  final List<ProductImageEntity> images;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  /// Quantity when this product is attached to an offer (from `offerProducts` API).
  final int? offerQuantity;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    this.shortDescription,
    required this.price,
    this.priceAfterDiscount,
    this.restaurantId,
    this.categoryId,
    this.categoryName,
    this.discount,
    this.discountType,
    this.hasStock,
    this.stockQuantity,
    this.servesCount,
    this.isAvailable,
    this.isExternal,
    this.externalProvider,
    this.externalId,
    this.merchantId,
    required this.images,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.offerQuantity,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        shortDescription,
        price,
        priceAfterDiscount,
        restaurantId,
        categoryId,
        categoryName,
        discount,
        discountType,
        hasStock,
        stockQuantity,
        servesCount,
        isAvailable,
        isExternal,
        externalProvider,
        externalId,
        merchantId,
        images,
        rating,
    createdAt,
    updatedAt,
    offerQuantity,
  ];

  /// Same product with a different per-offer quantity (UI / payload).
  ProductEntity withOfferQuantity(int quantity) {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      shortDescription: shortDescription,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      restaurantId: restaurantId,
      categoryId: categoryId,
      categoryName: categoryName,
      discount: discount,
      discountType: discountType,
      hasStock: hasStock,
      stockQuantity: stockQuantity,
      servesCount: servesCount,
      isAvailable: isAvailable,
      isExternal: isExternal,
      externalProvider: externalProvider,
      externalId: externalId,
      merchantId: merchantId,
      images: images,
      rating: rating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      offerQuantity: quantity,
    );
  }
}

