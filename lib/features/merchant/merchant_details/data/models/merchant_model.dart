class MerchantModel {
  final String id;
  final String name;
  final String email;
  final String? cityName;
  final String? countryName;
  final String? location;
  final String? phoneNumber;
  final String? image;

  MerchantModel({
    required this.id,
    required this.name,
    required this.email,
    this.cityName,
    this.countryName,
    this.location,
    this.phoneNumber,
    this.image,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cityName: json['cityName']?.toString(),
      countryName: json['countryName']?.toString(),
      location: json['location']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cityName': cityName,
      'countryName': countryName,
      'location': location,
      'phoneNumber': phoneNumber,
      'image': image,
    };
  }
}

