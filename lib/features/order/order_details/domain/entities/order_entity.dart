import 'package:equatable/equatable.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<ProductEntity> products;
  final DeliveryManEntity? deliveryMan;
  final DateTime? date;
  final double? longitude;
  final double? latitude;
  final int? numberOfPeople;
  final String? status;

  /// Resolved status for UI logic; use this instead of comparing raw [status] strings.
  OrderStatus get statusEnum => OrderStatus.fromString(status);
  final String? merchantId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.id,
    required this.products,
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

  @override
  List<Object?> get props => [
        id,
        products,
        deliveryMan,
        date,
        longitude,
        latitude,
        numberOfPeople,
        status,
        merchantId,
        createdAt,
        updatedAt,
      ];
}

