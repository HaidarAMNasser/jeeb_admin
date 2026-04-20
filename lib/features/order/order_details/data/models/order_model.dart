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
  final String? restaurantName;
  final String? merchantId;
  final String? createdAt;
  final String? updatedAt;
  final String? deliveryLandmark;
  final String? deliverySpecialInstructions;
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerPhone;
  final String? imagePayFromDelivery;
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
    this.receipts,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productsList = <ProductModel>[];
    final orderItemsList = <OrderItemModel>[];

    void appendLineItems(dynamic rawList) {
      if (rawList is! List || rawList.isEmpty) return;
      for (final e in rawList) {
        if (e is! Map) continue;
        final m = Map<String, dynamic>.from(e);
        productsList.add(_productModelFromOrderItem(m));
        orderItemsList.add(OrderItemModel.fromJson(m));
      }
    }

    appendLineItems(json['items']);

    final offers = json['offers'];
    if (offers is List) {
      for (final o in offers) {
        if (o is! Map) continue;
        final offerMap = Map<String, dynamic>.from(o);
        appendLineItems(offerMap['products']);
      }
    }

    List<ProductModel>? products;
    List<OrderItemModel>? orderItems;
    if (productsList.isNotEmpty) {
      products = productsList;
      orderItems = orderItemsList;
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
    String? deliveryLandmark;
    String? deliverySpecialInstructions;
    if (coords is Map<String, dynamic>) {
      if (coords['address'] != null) {
        deliveryAddress = coords['address']?.toString();
      }
      if (coords['landmark'] != null) {
        deliveryLandmark = coords['landmark']?.toString();
      }
      if (coords['specialInstructions'] != null) {
        deliverySpecialInstructions =
            coords['specialInstructions']?.toString();
      }
    }

    String? ownerFirstName;
    String? ownerLastName;
    String? ownerPhone;
    final ownerJson = json['owner'];
    if (ownerJson is Map<String, dynamic>) {
      ownerFirstName = ownerJson['firstName']?.toString();
      ownerLastName = ownerJson['lastName']?.toString();
      ownerPhone = ownerJson['phone']?.toString();
    }

    final customer = _parseOrderCustomer(json);

    int? _int(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    String? trimmedNonEmpty(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    String? restaurantName = trimmedNonEmpty(json['restaurantName']) ??
        trimmedNonEmpty(json['storeName']);
    final merchantJson = json['merchant'];
    if (restaurantName == null && merchantJson is Map<String, dynamic>) {
      restaurantName = trimmedNonEmpty(merchantJson['restaurantName']) ??
          trimmedNonEmpty(merchantJson['name']);
      if (restaurantName == null) {
        final fn = merchantJson['firstName']?.toString() ?? '';
        final ln = merchantJson['lastName']?.toString() ?? '';
        final combined = '$fn $ln'.trim();
        if (combined.isNotEmpty) restaurantName = combined;
      }
    }
    if (restaurantName == null && json['owner'] is Map<String, dynamic>) {
      final o = json['owner'] as Map<String, dynamic>;
      restaurantName = trimmedNonEmpty(o['restaurantName']);
    }

    final imagePayFromDelivery = trimmedNonEmpty(json['imagePayFromDelivery']) ??
        trimmedNonEmpty(json['imagepayfromdelivery']);

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
          : (json['delivery'] != null
              ? DeliveryManModel.fromJson(
                  json['delivery'] as Map<String, dynamic>,
                )
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
      restaurantName: restaurantName,
      merchantId: json['merchantId']?.toString() ?? json['ownerId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      deliveryLandmark: deliveryLandmark,
      deliverySpecialInstructions: deliverySpecialInstructions,
      ownerFirstName: ownerFirstName,
      ownerLastName: ownerLastName,
      ownerPhone: ownerPhone,
      imagePayFromDelivery: imagePayFromDelivery,
      receipts: receipts,
    );
  }

  static OrderCustomerModel? _parseOrderCustomer(Map<String, dynamic> json) {
    const keys = ['customer', 'user', 'client', 'buyer', 'orderUser'];
    for (final key in keys) {
      final v = json[key];
      if (v is Map<String, dynamic>) {
        return OrderCustomerModel.fromJson(v);
      }
      if (v is Map) {
        return OrderCustomerModel.fromJson(Map<String, dynamic>.from(v));
      }
    }
    return null;
  }

  static int _linePriceInt(Map<String, dynamic> item) {
    final price = item['unitPrice'] ??
        item['originalUnitPrice'] ??
        item['totalPrice'] ??
        0;
    if (price is int) return price;
    if (price is num) return price.toInt();
    return int.tryParse(price.toString()) ?? 0;
  }

  static int _lineQuantityInt(Map<String, dynamic> item) {
    final q = item['quantity'];
    if (q is int) return q;
    if (q is num) return q.toInt();
    return int.tryParse(q?.toString() ?? '') ?? 0;
  }

  /// Line shape: flat `productName` / `productId` or nested `product` (catalog object).
  static ProductModel _productModelFromOrderItem(Map<String, dynamic> item) {
    final linePrice = _linePriceInt(item);
    final qty = _lineQuantityInt(item);

    final nested = item['product'];
    Map<String, dynamic>? productMap;
    if (nested is Map<String, dynamic>) {
      productMap = nested;
    } else if (nested is Map) {
      productMap = Map<String, dynamic>.from(nested);
    }

    if (productMap != null) {
      try {
        final base = ProductModel.fromJson(productMap);
        final pid = item['productId']?.toString() ?? '';
        final id = pid.isNotEmpty
            ? pid
            : (base.id.isNotEmpty ? base.id : item['id']?.toString() ?? '');
        return ProductModel(
          id: id,
          name: base.name.isNotEmpty
              ? base.name
              : (item['productName']?.toString() ?? ''),
          description: base.description,
          shortDescription: base.shortDescription,
          price: linePrice > 0 ? linePrice : base.price,
          priceAfterDiscount: base.priceAfterDiscount,
          restaurantId: base.restaurantId,
          categoryId: base.categoryId,
          categoryName: base.categoryName,
          discount: base.discount,
          discountType: base.discountType,
          hasStock: base.hasStock,
          stockQuantity: base.stockQuantity,
          servesCount: base.servesCount,
          isAvailable: base.isAvailable,
          isExternal: base.isExternal,
          externalProvider: base.externalProvider,
          externalId: base.externalId,
          merchantId: base.merchantId,
          images: base.images,
          rating: base.rating,
          createdAt: base.createdAt,
          updatedAt: base.updatedAt,
          offerQuantity: qty > 0 ? qty : base.offerQuantity,
        );
      } catch (_) {
        return ProductModel(
          id: item['productId']?.toString() ??
              productMap['id']?.toString() ??
              item['id']?.toString() ??
              '',
          name: productMap['name']?.toString() ??
              item['productName']?.toString() ??
              '',
          price: linePrice,
          images: const [],
          offerQuantity: qty > 0 ? qty : null,
        );
      }
    }

    return ProductModel(
      id: item['productId']?.toString() ?? item['id']?.toString() ?? '',
      name: item['productName']?.toString() ?? '',
      price: linePrice,
      images: const [],
      offerQuantity: qty > 0 ? qty : null,
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
      'restaurantName': restaurantName,
      'merchantId': merchantId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'receipts': receipts?.map((r) => {'id': r.id, 'imageId': r.imageId, 'url': r.url}).toList(),
    };
  }
}

