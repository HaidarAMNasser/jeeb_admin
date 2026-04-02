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
    int intVal(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    final nested = json['product'];
    Map<String, dynamic>? productMap;
    if (nested is Map<String, dynamic>) {
      productMap = nested;
    } else if (nested is Map) {
      productMap = Map<String, dynamic>.from(nested);
    }

    var productId = json['productId']?.toString() ?? '';
    if (productId.isEmpty && productMap != null) {
      productId = productMap['id']?.toString() ?? '';
    }
    if (productId.isEmpty) {
      productId = json['id']?.toString() ?? '';
    }

    var productName = json['productName']?.toString() ?? '';
    if (productName.isEmpty && productMap != null) {
      productName = productMap['name']?.toString() ?? '';
    }

    return OrderItemModel(
      productId: productId,
      productName: productName,
      quantity: intVal(json['quantity']),
      unitPrice: intVal(json['unitPrice'] ?? json['originalUnitPrice']),
      totalPrice: intVal(json['totalPrice']),
    );
  }
}
