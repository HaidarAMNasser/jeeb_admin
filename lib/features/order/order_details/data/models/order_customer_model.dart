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
    var firstName = json['firstName']?.toString();
    var lastName = json['lastName']?.toString();
    final name = json['name']?.toString().trim();
    final fnEmpty = firstName == null || firstName.trim().isEmpty;
    final lnEmpty = lastName == null || lastName.trim().isEmpty;
    if (fnEmpty && lnEmpty && name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        firstName = parts.first;
        lastName = parts.sublist(1).join(' ');
      } else {
        firstName = name;
        lastName = null;
      }
    }
    return OrderCustomerModel(
      id: json['id']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      role: json['role']?.toString(),
    );
  }
}
