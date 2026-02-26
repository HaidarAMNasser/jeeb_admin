class DeliveryManModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? vehicleType;
  final String? status;
  final String? image;

  DeliveryManModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.vehicleType,
    this.status,
    this.image,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    return DeliveryManModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString(),
      status: json['status']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'vehicleType': vehicleType,
      'status': status,
      'image': image,
    };
  }
}
