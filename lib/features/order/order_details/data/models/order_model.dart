import 'package:jeeb_admin/features/product/list_product/data/models/product_model.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/models/delivery_man_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel>? products;
  final DeliveryManModel? deliveryMan;
  final String? date;
  final double? longitude;
  final double? latitude;
  final int? numberOfPeople;
  final String? status;
  final String? merchantId;
  final String? createdAt;
  final String? updatedAt;

  OrderModel({
    required this.id,
    this.products,
    this.deliveryMan,
    this.date,
    this.longitude,
    this.latitude,
    this.numberOfPeople,
    this.status,
    this.merchantId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      products: json['products'] != null
          ? (json['products'] as List)
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      deliveryMan: json['deliveryMan'] != null
          ? DeliveryManModel.fromJson(json['deliveryMan'] as Map<String, dynamic>)
          : null,
      date: json['date']?.toString(),
      longitude: json['longitude'] != null
          ? (json['longitude'] is num
              ? (json['longitude'] as num).toDouble()
              : double.tryParse(json['longitude'].toString()))
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] is num
              ? (json['latitude'] as num).toDouble()
              : double.tryParse(json['latitude'].toString()))
          : null,
      numberOfPeople: json['numberOfPeople'] != null
          ? (json['numberOfPeople'] is int
              ? json['numberOfPeople'] as int
              : int.tryParse(json['numberOfPeople'].toString()))
          : null,
      status: json['status']?.toString(),
      merchantId: json['merchantId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products?.map((p) => p.toJson()).toList(),
      'deliveryMan': deliveryMan?.toJson(),
      'date': date,
      'longitude': longitude,
      'latitude': latitude,
      'numberOfPeople': numberOfPeople,
      'status': status,
      'merchantId': merchantId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

