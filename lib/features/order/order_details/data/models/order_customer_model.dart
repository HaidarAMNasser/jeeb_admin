class OrderCustomerModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;

  OrderCustomerModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.role,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      role: json['role']?.toString(),
    );
  }
}
