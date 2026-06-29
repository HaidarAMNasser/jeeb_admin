import '../../domain/entities/merchant_entity.dart';
import '../models/merchant_model.dart';

extension MerchantMapper on MerchantModel {
  MerchantEntity toDomain() {
    return MerchantEntity(
      id: id,
      name: name, // firstName + lastName
      restaurantName: restaurantName,
      firstName: firstName,
      lastName: lastName,
      email: email,
      countryId: countryId,
      cityId: cityId,
      address: address,
      cityName: cityName, // from city.nameEn or city.nameAr
      countryName: countryName, // from country.nameEn or country.nameAr
      location: address,
      phoneNumber: phoneNumber, // from phone
      hidePhoneNumber: hidePhoneNumber,
      image: imageUrl, // from image.url
      role: role,
      notificationChannel: notificationChannel,
      merchantType: merchantType,
      currentLat: currentLat,
      currentLng: currentLng,
      birthday: birthday,
      isOnline: isOnline,
      isActive: isActive,
      verifiedAt: verifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MerchantListMapper on List<MerchantModel> {
  List<MerchantEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}

