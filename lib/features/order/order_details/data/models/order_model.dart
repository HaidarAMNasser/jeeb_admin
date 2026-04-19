import 'package:jeeb_admin/features/product/list_product/data/models/product_model.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/models/delivery_man_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_customer_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_item_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_payment_receipt_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel>? products;
  final List<OrderItemModel>? orderItems;
  final OrderCustomerModel? customer;
  final DeliveryManModel? deliveryMan;
  final String? date;
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
  final String? merchantId;
  final String? createdAt;
  final String? updatedAt;
  final List<OrderPaymentReceiptModel>? receipts;

  OrderModel({
    required this.id,
    this.products,
    this.orderItems,
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
    this.merchantId,
    this.createdAt,
    this.updatedAt,
    this.receipts,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    List<ProductModel>? products;
    List<OrderItemModel>? orderItems;
    if (items != null && items is List && items.isNotEmpty) {
      final itemMaps = items.map((e) => e as Map<String, dynamic>).toList();
      products = itemMaps.map(_productModelFromOrderItem).toList();
      orderItems = itemMaps.map(OrderItemModel.fromJson).toList();
    }

    final coords = json['deliveryCoordinates'];
    double? longitude;
    double? latitude;
    if (coords is Map<String, dynamic>) {
      if (coords['longitude'] != null) {
        longitude = (coords['longitude'] is num)
            ? (coords['longitude'] as num).toDouble()
            : double.tryParse(coords['longitude'].toString());
      }
      if (coords['latitude'] != null) {
        latitude = (coords['latitude'] is num)
            ? (coords['latitude'] as num).toDouble()
            : double.tryParse(coords['latitude'].toString());
      }
    }
    if (longitude == null && json['longitude'] != null) {
      longitude = (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude'].toString());
    }
    if (latitude == null && json['latitude'] != null) {
      latitude = (json['latitude'] is num)
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude'].toString());
    }

    final dateStr = json['deliveryDeadline']?.toString() ??
        json['date']?.toString() ??
        json['createdAt']?.toString();

    String? deliveryAddress;
    if (coords is Map<String, dynamic> && coords['address'] != null) {
      deliveryAddress = coords['address']?.toString();
    }

    OrderCustomerModel? customer;
    if (json['customer'] != null && json['customer'] is Map<String, dynamic>) {
      customer = OrderCustomerModel.fromJson(json['customer'] as Map<String, dynamic>);
    }

    int? _int(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    List<OrderPaymentReceiptModel>? receipts;
    if (json['receipts'] is List) {
      receipts = (json['receipts'] as List)
          .map((e) => OrderPaymentReceiptModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return OrderModel(
      id: json['id']?.toString() ?? json['orderId']?.toString() ?? '',
      products: products,
      orderItems: orderItems,
      customer: customer,
      deliveryMan: json['deliveryMan'] != null
          ? DeliveryManModel.fromJson(json['deliveryMan'] as Map<String, dynamic>)
          : (json['owner'] != null
              ? DeliveryManModel.fromJson(json['owner'] as Map<String, dynamic>)
              : null),
      date: dateStr,
      longitude: longitude,
      latitude: latitude,
      deliveryAddress: deliveryAddress,
      numberOfPeople: json['numberOfPeople'] != null
          ? (json['numberOfPeople'] is int
              ? json['numberOfPeople'] as int
              : int.tryParse(json['numberOfPeople'].toString()))
          : null,
      status: json['status']?.toString(),
      paymentMethod: json['paymentMethod']?.toString(),
      priceBeforeDiscount: _int(json['priceBeforeDiscount']),
      discountAmount: _int(json['discountAmount']),
      totalAmount: _int(json['totalAmount']),
      currencyCode: json['currencyCode']?.toString(),
      deliveryFee: _int(json['deliveryFee']),
      platformCommission: _int(json['platformCommission']),
      ownerRevenue: _int(json['ownerRevenue']),
      tipAmount: _int(json['tipAmount']),
      couponCode: json['couponCode']?.toString(),
      merchantId: json['merchantId']?.toString() ?? json['ownerId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      receipts: receipts,
    );
  }

  static ProductModel _productModelFromOrderItem(Map<String, dynamic> item) {
    final price = item['unitPrice'] ?? item['originalUnitPrice'] ?? 0;
    final priceInt = price is int
        ? price
        : (price is num ? price.toInt() : int.tryParse(price.toString()) ?? 0);
    return ProductModel(
      id: item['productId']?.toString() ?? item['id']?.toString() ?? '',
      name: item['productName']?.toString() ?? '',
      price: priceInt,
      images: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products?.map((p) => p.toJson()).toList(),
      'orderItems': null,
      'deliveryMan': deliveryMan?.toJson(),
      'date': date,
      'longitude': longitude,
      'latitude': latitude,
      'deliveryAddress': deliveryAddress,
      'numberOfPeople': numberOfPeople,
      'status': status,
      'paymentMethod': paymentMethod,
      'priceBeforeDiscount': priceBeforeDiscount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'currencyCode': currencyCode,
      'deliveryFee': deliveryFee,
      'platformCommission': platformCommission,
      'ownerRevenue': ownerRevenue,
      'tipAmount': tipAmount,
      'couponCode': couponCode,
      'merchantId': merchantId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'receipts': receipts?.map((r) => {'id': r.id, 'imageId': r.imageId, 'url': r.url}).toList(),
    };
  }
}

