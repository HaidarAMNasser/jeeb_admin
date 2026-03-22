class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int totalPrice;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    int _int(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return OrderItemModel(
      productId: json['productId']?.toString() ?? json['id']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      quantity: _int(json['quantity']),
      unitPrice: _int(json['unitPrice'] ?? json['originalUnitPrice']),
      totalPrice: _int(json['totalPrice']),
    );
  }
}
