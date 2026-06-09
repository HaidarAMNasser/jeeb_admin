import '../../domain/entities/delivery_man_entity.dart';
import '../models/delivery_man_model.dart';

extension DeliveryManMapper on DeliveryManModel {
  DeliveryManEntity toDomain() {
    return DeliveryManEntity(
      id: id,
      name: name, // firstName + lastName
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      cityName: cityName,
      countryName: countryName,
      countryId: countryId,
      cityId: cityId,
      country: country?.toDomain(),
      city: city?.toDomain(),
      address: address,
      image: imageUrlFull,
      isOnline: isOnline,
      confirmed: confirmed,
      isActive: isActive,
      officeOwnerId: officeOwnerId,
      role: role,
      notificationChannel: notificationChannel,
      birthday: birthday,
      verifiedAt: verifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      currentLat: currentLat,
      currentLng: currentLng,
    );
  }
}

extension DeliveryManListMapper on List<DeliveryManModel> {
  List<DeliveryManEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}
