import '../../domain/entities/delivery_man_entity.dart';
import '../models/delivery_man_model.dart';

extension DeliveryManMapper on DeliveryManModel {
  DeliveryManEntity toDomain() {
    return DeliveryManEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      vehicleType: vehicleType,
      status: status,
      image: image,
    );
  }
}

extension DeliveryManListMapper on List<DeliveryManModel> {
  List<DeliveryManEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}
