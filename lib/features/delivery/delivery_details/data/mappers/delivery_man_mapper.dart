import '../../domain/entities/delivery_man_entity.dart';
import '../models/delivery_man_model.dart';

extension DeliveryManMapper on DeliveryManModel {
  DeliveryManEntity toDomain() {
    return DeliveryManEntity(
      id: id,
      name: name, // firstName + lastName
      phone: phone,
      email: email,
      cityName: cityName,
      countryName: countryName,
      image: imageUrlFull,
      isOnline: isOnline,
      confirmed: confirmed,
      isActive: isActive,
      officeOwnerId: officeOwnerId,
    );
  }
}

extension DeliveryManListMapper on List<DeliveryManModel> {
  List<DeliveryManEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}
