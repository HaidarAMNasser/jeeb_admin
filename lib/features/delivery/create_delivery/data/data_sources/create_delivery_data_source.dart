import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateDeliveryRemoteDataSource {
  Future<Response> createDeliveryMan({
    required String name,
    required String phone,
    required String email,
    String? vehicleType,
    String? status,
  });
}

class CreateDeliveryRemoteDataSourceImpl
    implements CreateDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createDeliveryMan({
    required String name,
    required String phone,
    required String email,
    String? vehicleType,
    String? status,
  }) {
    return _appApiServiceClient.createDeliveryMan(
      name,
      phone,
      email,
      vehicleType,
      status,
    );
  }
}
