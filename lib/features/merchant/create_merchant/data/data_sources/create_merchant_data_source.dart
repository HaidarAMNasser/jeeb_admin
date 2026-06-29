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
  }) async {
    final type = (merchantType == 'STORE' || merchantType == 'RESTAURANT')
        ? merchantType
        : 'RESTAURANT';

    final formData = FormData.fromMap({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'countryId': countryId,
      'cityId': cityId,
      'areaId': areaId,
      'restaurantName': restaurantName,
      'type': type,
      'location': {'lat': latitude, 'lng': longitude},
      if (address != null && address.isNotEmpty) 'address': address,
      if (notificationChannel != null && notificationChannel.isNotEmpty)
        'notificationChannel': notificationChannel,
    });

    return _appApiServiceClient.createMerchant(formData);
  }
}
