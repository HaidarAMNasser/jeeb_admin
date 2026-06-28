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

  OrderEntity copyWith({
    String? id,
    List<ProductEntity>? products,
    List<OrderItemEntity>? orderItems,
    OrderCustomerEntity? customer,
    DeliveryManEntity? deliveryMan,
    DateTime? date,
    double? longitude,
    double? latitude,
    String? deliveryAddress,
    int? numberOfPeople,
    String? status,
    String? paymentMethod,
    int? priceBeforeDiscount,
    int? discountAmount,
    int? totalAmount,
    String? currencyCode,
    int? deliveryFee,
    int? platformCommission,
    int? ownerRevenue,
    int? tipAmount,
    String? couponCode,
    String? restaurantName,
    String? merchantId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deliveryLandmark,
    String? deliverySpecialInstructions,
    String? ownerFirstName,
    String? ownerLastName,
    String? ownerPhone,
    String? imagePayFromDelivery,
    List<OrderPaymentReceiptEntity>? receipts,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      products: products ?? this.products,
      orderItems: orderItems ?? this.orderItems,
      customer: customer ?? this.customer,
      deliveryMan: deliveryMan ?? this.deliveryMan,
      date: date ?? this.date,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      platformCommission: platformCommission ?? this.platformCommission,
      ownerRevenue: ownerRevenue ?? this.ownerRevenue,
      tipAmount: tipAmount ?? this.tipAmount,
      couponCode: couponCode ?? this.couponCode,
      restaurantName: restaurantName ?? this.restaurantName,
      merchantId: merchantId ?? this.merchantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryLandmark: deliveryLandmark ?? this.deliveryLandmark,
      deliverySpecialInstructions:
          deliverySpecialInstructions ?? this.deliverySpecialInstructions,
      ownerFirstName: ownerFirstName ?? this.ownerFirstName,
      ownerLastName: ownerLastName ?? this.ownerLastName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      imagePayFromDelivery: imagePayFromDelivery ?? this.imagePayFromDelivery,
      receipts: receipts ?? this.receipts,
    );
  }

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

