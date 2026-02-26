import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateDeliveryRemoteDataSource {
  Future<Response> updateDeliveryMan({
    required String id,
    String? name,
    String? phone,
    String? email,
    String? vehicleType,
    String? status,
  });
}

class UpdateDeliveryRemoteDataSourceImpl
    implements UpdateDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateDeliveryMan({
    required String id,
    String? name,
    String? phone,
    String? email,
    String? vehicleType,
    String? status,
  }) {
    return _appApiServiceClient.updateDeliveryMan(
      id,
      name,
      phone,
      email,
      vehicleType,
      status,
    );
  }
}
