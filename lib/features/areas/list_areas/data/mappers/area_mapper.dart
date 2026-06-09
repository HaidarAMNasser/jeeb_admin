import 'package:jeeb_admin/features/areas/list_areas/data/models/area_model.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

extension AreaModelMapper on AreaModel {
  AreaEntity toDomain() {
    return AreaEntity(
      id: id,
      name: name,
      price: price,
      description: description,
    );
  }
}

extension AreaModelListMapper on List<AreaModel> {
  List<AreaEntity> toDomain() {
    return map((model) => model.toDomain()).toList();
  }
}
