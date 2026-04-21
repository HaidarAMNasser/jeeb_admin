import '../../../../../core/config/app_config.dart';
import '../../../../country/data/models/country_model.dart';
import '../../../../city/data/models/city_model.dart';

/// Single `image` object or `images[]` (main first, else first entry).
DeliveryImageModel? _deliveryManImageFromJson(Map<String, dynamic> json) {
  final single = json['image'];
  if (single is Map<String, dynamic>) {
    return DeliveryImageModel.fromJson(single);
  }
  final raw = json['images'];
  if (raw is! List || raw.isEmpty) return null;
  Map<String, dynamic>? chosen;
  for (final e in raw) {
    if (e is! Map<String, dynamic>) continue;
    if (e['isMain'] == true) {
      chosen = e;
      break;
    }
  }
  chosen ??= raw.first is Map<String, dynamic>
      ? raw.first as Map<String, dynamic>
      : null;
  if (chosen == null) return null;
  return DeliveryImageModel.fromJson(chosen);
}

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
  final double? currentLat;
  final double? currentLng;

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
    this.currentLat,
    this.currentLng,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    double? lat = (json['currentLat'] as num?)?.toDouble();
    double? lng = (json['currentLng'] as num?)?.toDouble();
    final loc = json['location'];
    if (lat == null && loc is Map<String, dynamic>) {
      lat = (loc['lat'] as num?)?.toDouble() ?? (loc['latitude'] as num?)?.toDouble();
      lng = (loc['lng'] as num?)?.toDouble() ?? (loc['longitude'] as num?)?.toDouble();
    }
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
      countryId: json['countryId'] == null
          ? null
          : (json['countryId'] as num).toInt(),
      cityId: json['cityId'] == null
          ? null
          : (json['cityId'] as num).toInt(),
      address: json['address']?.toString(),
      birthday: json['birthday']?.toString(),
      isOnline: json['isOnline'] as bool?,
      verifiedAt: json['verifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      image: _deliveryManImageFromJson(json),
      country: json['country'] != null
          ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      officeOwnerId: json['officeOwnerId'] as int?,
      currentLat: lat,
      currentLng: lng,
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
