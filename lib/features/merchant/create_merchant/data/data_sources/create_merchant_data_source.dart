import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateMerchantRemoteDataSource {
  Future<Response> createMerchant({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required int countryId,
    required int cityId,
    required int areaId,
    required String restaurantName,
    required String merchantType,
    required double latitude,
    required double longitude,
    String? address,
    String? notificationChannel,
  });
}

class CreateMerchantRemoteDataSourceImpl
    implements CreateMerchantRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateMerchantRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createMerchant({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required int countryId,
    required int cityId,
    required int areaId,
    required String restaurantName,
    required String merchantType,
    required double latitude,
    required double longitude,
    String? address,
    String? notificationChannel,
  }) {
    final type = (merchantType == 'STORE' || merchantType == 'RESTAURANT')
        ? merchantType
        : 'RESTAURANT';

    return _appApiServiceClient.createMerchant(
      firstName,
      lastName,
      email,
      password,
      phone,
      countryId,
      cityId,
      areaId,
      restaurantName,
      type,
      latitude,
      longitude,
      address,
      notificationChannel,
    );
  }
}
