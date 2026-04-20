import 'package:equatable/equatable.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_customer_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_item_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_payment_receipt_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<ProductEntity> products;
  final List<OrderItemEntity> orderItems;
  final OrderCustomerEntity? customer;
  final DeliveryManEntity? deliveryMan;
  final DateTime? date;
  final double? longitude;
  final double? latitude;
  final String? deliveryAddress;
  final int? numberOfPeople;
  final String? status;
  final String? paymentMethod;
  final int? priceBeforeDiscount;
  final int? discountAmount;
  final int? totalAmount;
  final String? currencyCode;
  final int? deliveryFee;
  final int? platformCommission;
  final int? ownerRevenue;
  final int? tipAmount;
  final String? couponCode;
  final List<OrderPaymentReceiptEntity> receipts;

  /// Resolved status for UI logic; use this instead of comparing raw [status] strings.
  OrderStatus get statusEnum => OrderStatus.fromString(status);

  /// Store / restaurant display name when provided by the API.
  final String? restaurantName;
  final String? merchantId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? deliveryLandmark;
  final String? deliverySpecialInstructions;
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerPhone;

  /// Screenshot URL from delivery payment flow (API key may change later).
  final String? imagePayFromDelivery;

  const OrderEntity({
    required this.id,
    required this.products,
    this.orderItems = const [],
    this.customer,
    this.deliveryMan,
    this.date,
    this.longitude,
    this.latitude,
    this.deliveryAddress,
    this.numberOfPeople,
    this.status,
    this.paymentMethod,
    this.priceBeforeDiscount,
    this.discountAmount,
    this.totalAmount,
    this.currencyCode,
    this.deliveryFee,
    this.platformCommission,
    this.ownerRevenue,
    this.tipAmount,
    this.couponCode,
    this.restaurantName,
    this.merchantId,
    this.createdAt,
    this.updatedAt,
    this.deliveryLandmark,
    this.deliverySpecialInstructions,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerPhone,
    this.imagePayFromDelivery,
    this.receipts = const [],
  });

  /// Delivery location section: coordinates and/or address fields from API.
  bool get hasDeliveryLocationInfo =>
      (latitude != null && longitude != null) ||
      (deliveryAddress != null && deliveryAddress!.trim().isNotEmpty) ||
      (deliveryLandmark != null && deliveryLandmark!.trim().isNotEmpty) ||
      (deliverySpecialInstructions != null &&
          deliverySpecialInstructions!.trim().isNotEmpty);

  @override
  List<Object?> get props => [
        id,
        products,
        orderItems,
        customer,
        deliveryMan,
        date,
        longitude,
        latitude,
        deliveryAddress,
        numberOfPeople,
        status,
        paymentMethod,
        priceBeforeDiscount,
        discountAmount,
        totalAmount,
        currencyCode,
        deliveryFee,
        platformCommission,
        ownerRevenue,
        tipAmount,
        couponCode,
        restaurantName,
        merchantId,
        createdAt,
        updatedAt,
        deliveryLandmark,
        deliverySpecialInstructions,
        ownerFirstName,
        ownerLastName,
        ownerPhone,
        imagePayFromDelivery,
        receipts,
      ];
}

