import '../../../../../core/config/app_config.dart';
import '../../../../country/data/models/country_model.dart';
import '../../../../city/data/models/city_model.dart';

class DeliveryImageModel {
  final int id;
  final String url;
  final String mobileUrl;
  final String thumbnailUrl;
  final bool isMain;

  DeliveryImageModel({
    required this.id,
    required this.url,
    required this.mobileUrl,
    required this.thumbnailUrl,
    required this.isMain,
  });

  factory DeliveryImageModel.fromJson(Map<String, dynamic> json) {
    return DeliveryImageModel(
      id: json['id'] as int? ?? 0,
      url: json['url']?.toString() ?? '',
      mobileUrl: json['mobileUrl']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      isMain: json['isMain'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'mobileUrl': mobileUrl,
      'thumbnailUrl': thumbnailUrl,
      'isMain': isMain,
    };
  }
}

class DeliveryManModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool confirmed;
  final bool? isActive;
  final String? role;
  final String? notificationChannel;
  final int? countryId;
  final int? cityId;
  final String? address;
  final String? birthday;
  final bool? isOnline;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final DeliveryImageModel? image;
  final CountryModel? country;
  final CityModel? city;
  final int? officeOwnerId;

  DeliveryManModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.confirmed,
    this.isActive,
    this.role,
    this.notificationChannel,
    this.countryId,
    this.cityId,
    this.address,
    this.birthday,
    this.isOnline,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.country,
    this.city,
    this.officeOwnerId,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    return DeliveryManModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      confirmed: json['confirmed'] as bool? ?? false,
      isActive: json['isActive'] as bool?,
      role: json['role']?.toString(),
      notificationChannel: json['notificationChannel']?.toString(),
      countryId: json['countryId'] as int?,
      cityId: json['cityId'] as int?,
      address: json['address']?.toString(),
      birthday: json['birthday']?.toString(),
      isOnline: json['isOnline'] as bool?,
      verifiedAt: json['verifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      image: json['image'] != null
          ? DeliveryImageModel.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      officeOwnerId: json['officeOwnerId'] as int?,
    );
  }

  // Helper getters for backward compatibility
  String get name => '$firstName $lastName';
  String? get cityName => city?.name.en.isNotEmpty == true
      ? city?.name.en
      : (city?.name.ar.isNotEmpty == true ? city?.name.ar : null);
  String? get countryName => country?.name.en.isNotEmpty == true
      ? country?.name.en
      : (country?.name.ar.isNotEmpty == true ? country?.name.ar : null);
  String? get imageUrl => image?.url;

  /// Full URL for display (resolves relative backend paths like "users/33/...").
  String? get imageUrlFull {
    if (image == null) return null;
    final u = image!.thumbnailUrl.isNotEmpty
        ? image!.thumbnailUrl
        : (image!.mobileUrl.isNotEmpty ? image!.mobileUrl : image!.url);
    if (u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    return '${AppConfig.assetsBaseUrl}uploads/$u';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'confirmed': confirmed,
      'isActive': isActive,
      'role': role,
      'notificationChannel': notificationChannel,
      'countryId': countryId,
      'cityId': cityId,
      'address': address,
      'birthday': birthday,
      'isOnline': isOnline,
      'verifiedAt': verifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'image': image?.toJson(),
      'country': country?.toJson(),
      'city': city?.toJson(),
      'officeOwnerId': officeOwnerId,
    };
  }
}
