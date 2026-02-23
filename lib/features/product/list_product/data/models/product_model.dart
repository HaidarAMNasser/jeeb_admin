class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String categoryId;
  final String categoryName;
  final int? quantity;
  final List<String> images;
  final double? rating;

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      quantity: json['quantity'] as int?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'quantity': quantity,
      'images': images,
      'rating': rating,
    };
  }
}

