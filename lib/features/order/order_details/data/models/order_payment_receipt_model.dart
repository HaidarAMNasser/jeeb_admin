class OrderPaymentReceiptModel {
  final int id;
  final int imageId;
  final String url;

  const OrderPaymentReceiptModel({
    required this.id,
    required this.imageId,
    required this.url,
  });

  factory OrderPaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    int intFromJson(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return OrderPaymentReceiptModel(
      id: intFromJson(json['id']),
      imageId: intFromJson(json['imageId']),
      url: json['url']?.toString() ?? '',
    );
  }
}
