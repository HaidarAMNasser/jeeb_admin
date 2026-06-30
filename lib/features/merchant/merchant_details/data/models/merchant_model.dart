import '../../../../country/data/models/country_model.dart';
import '../../../../city/data/models/city_model.dart';
import '../../../../areas/list_areas/data/models/area_model.dart';

class MerchantImageModel {
  final int id;
  final String url;
  final String mobileUrl;
  final String thumbnailUrl;
  final bool isMain;

  MerchantImageModel({
    required this.id,
    required this.url,
    required this.mobileUrl,
    required this.thumbnailUrl,
    required this.isMain,
  });

  factory MerchantImageModel.fromJson(Map<String, dynamic> json) {
    return MerchantImageModel(
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

class MerchantModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String restaurantName;
  final String phone;
  final String? role;
  final String? notificationChannel;
  final String? merchantType;
  final double? currentLat;
  final double? currentLng;
  final int? countryId;
  final int? cityId;
  final int? areaId;
  final String? address;
  final String? birthday;
  final bool? isOnline;
  final bool? isActive;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final bool? hidePhoneNumber;
  final MerchantImageModel? image;
  final CountryModel? country;
  final CityModel? city;
  final AreaModel? area;

  MerchantModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.restaurantName,
    required this.phone,
    this.role,
    this.notificationChannel,
    this.merchantType,
    this.currentLat,
    this.currentLng,
    this.countryId,
    this.cityId,
    this.areaId,
    this.address,
    this.birthday,
    this.isOnline,
    this.isActive,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.hidePhoneNumber,
    this.image,
    this.country,
    this.city,
    this.area,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString(),
      notificationChannel: json['notificationChannel']?.toString(),
      merchantType: json['type']?.toString() ?? json['merchantType']?.toString(),
      currentLat: _parseCoordinate(json['currentLat'], json['location'], 'lat'),
      currentLng: _parseCoordinate(json['currentLng'], json['location'], 'lng'),
      countryId: json['countryId'] as int?,
      cityId: json['cityId'] as int?,
      areaId: json['areaId'] as int? ??
          (json['area'] is Map<String, dynamic>
              ? int.tryParse(
                  (json['area'] as Map<String, dynamic>)['id']?.toString() ??
                      '',
                )
              : null),
      address: json['address']?.toString(),
      birthday: json['birthday']?.toString(),
      isOnline: json['isOnline'] as bool?,
      isActive: json['isActive'] as bool?,
      verifiedAt: json['verifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      hidePhoneNumber: json['hidePhoneNumber'] as bool?,
      image: json['image'] != null
          ? MerchantImageModel.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      area: json['area'] != null
          ? AreaModel.fromJson(json['area'] as Map<String, dynamic>)
          : null,
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
  String? get areaName =>
      area?.name.isNotEmpty == true ? area?.name : null;
  int? get areaPrice => area?.price;
  String? get phoneNumber => phone;
  String? get imageUrl => image?.url;

  static double? _parseCoordinate(
    dynamic directValue,
    dynamic locationValue,
    String key,
  ) {
    if (directValue != null) {
      return (directValue as num?)?.toDouble();
    }
    if (locationValue is Map<String, dynamic>) {
      return (locationValue[key] as num?)?.toDouble();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'restaurantName': restaurantName,
      'phone': phone,
      'role': role,
      'notificationChannel': notificationChannel,
      'type': merchantType,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'countryId': countryId,
      'cityId': cityId,
      'areaId': areaId,
      'address': address,
      'birthday': birthday,
      'isOnline': isOnline,
      'isActive': isActive,
      'verifiedAt': verifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'hidePhoneNumber': hidePhoneNumber,
      'image': image?.toJson(),
      'country': country?.toJson(),
      'city': city?.toJson(),
      'area': area?.toJson(),
    };
  }
}

