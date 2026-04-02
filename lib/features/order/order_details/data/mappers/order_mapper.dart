import 'package:jeeb_admin/features/order/order_details/data/models/order_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_customer_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_item_model.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_customer_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_item_entity.dart';
import 'package:jeeb_admin/features/product/list_product/data/mappers/product_mapper.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/mappers/delivery_man_mapper.dart';

extension OrderItemMapper on OrderItemModel {
  OrderItemEntity toDomain() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
    );
  }
}

extension OrderCustomerMapper on OrderCustomerModel {
  OrderCustomerEntity toDomain() {
    return OrderCustomerEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      role: role,
    );
  }
}

extension OrderMapper on OrderModel {
  OrderEntity toDomain() {
    return OrderEntity(
      id: id,
      products: products != null && products!.isNotEmpty
          ? products!.map((p) => p.toDomain()).toList()
          : [],
      orderItems: orderItems != null && orderItems!.isNotEmpty
          ? orderItems!.map((o) => o.toDomain()).toList()
          : [],
      customer: customer?.toDomain(),
      deliveryMan: deliveryMan?.toDomain(),
      date: date != null ? DateTime.tryParse(date!) : null,
      longitude: longitude,
      latitude: latitude,
      deliveryAddress: deliveryAddress,
      numberOfPeople: numberOfPeople,
      status: status,
      paymentMethod: paymentMethod,
      priceBeforeDiscount: priceBeforeDiscount,
      discountAmount: discountAmount,
      totalAmount: totalAmount,
      currencyCode: currencyCode,
      deliveryFee: deliveryFee,
      platformCommission: platformCommission,
      ownerRevenue: ownerRevenue,
      tipAmount: tipAmount,
      couponCode: couponCode,
      restaurantName: restaurantName,
      merchantId: merchantId,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

extension OrderListMapper on List<OrderModel> {
  List<OrderEntity> toDomain() {
    return map((order) => order.toDomain()).toList();
  }
}

