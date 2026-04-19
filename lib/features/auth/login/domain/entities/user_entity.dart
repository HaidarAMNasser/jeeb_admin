import 'package:equatable/equatable.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';

enum UserRole {
  customer,
  delivery,
  merchant,
  admin,
}

enum NotificationChannel {
  email,
  whatsapp,
}

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final UserRole role;
  final NotificationChannel notificationChannel;
  final String? address;
  final bool? isOnline;
  final bool? isActive;
  /// Merchant "open" status; used for profile toggle and API isOpen.
  final bool? isOpen;
  final DateTime? verifiedAt;
  final bool isVerified;
  final double? currentLat;
  final double? currentLng;
  final int countryId;
  final CountryEntity? country;
  final int cityId;
  final CityEntity? city;
  final DateTime createdAt;
  final DateTime updatedAt;
  /// Profile image URL from backend (user.image.url / thumbnailUrl / mobileUrl). May be relative.
  final String? profileImageUrl;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.notificationChannel,
    this.address,
    this.isOnline,
    this.isActive,
    this.isOpen,
    this.verifiedAt,
    this.isVerified = false,
    this.currentLat,
    this.currentLng,
    required this.countryId,
    this.country,
    required this.cityId,
    this.city,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';

  UserEntity copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    UserRole? role,
    NotificationChannel? notificationChannel,
    String? address,
    bool? isOnline,
    bool? isActive,
    bool? isOpen,
    DateTime? verifiedAt,
    bool? isVerified,
    double? currentLat,
    double? currentLng,
    int? countryId,
    CountryEntity? country,
    int? cityId,
    CityEntity? city,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      notificationChannel: notificationChannel ?? this.notificationChannel,
      address: address ?? this.address,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      isOpen: isOpen ?? this.isOpen,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isVerified: isVerified ?? this.isVerified,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      countryId: countryId ?? this.countryId,
      country: country ?? this.country,
      cityId: cityId ?? this.cityId,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        role,
        notificationChannel,
        address,
        isOnline,
        isActive,
        isOpen,
        verifiedAt,
        isVerified,
        currentLat,
        currentLng,
        countryId,
        country,
        cityId,
        city,
        createdAt,
        updatedAt,
        profileImageUrl,
      ];
}

