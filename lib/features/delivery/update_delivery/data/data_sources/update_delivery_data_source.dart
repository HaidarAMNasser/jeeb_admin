import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateDeliveryRemoteDataSource {
  Future<Response> updateDeliveryMan({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    int? countryId,
    int? cityId,
    String? address,
    String? birthday,
    String? notificationChannel,
    String? imagePath,
    double? latitude,
    double? longitude,
  });
}

class UpdateDeliveryRemoteDataSourceImpl
    implements UpdateDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateDeliveryMan({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    int? countryId,
    int? cityId,
    String? address,
    String? birthday,
    String? notificationChannel,
    String? imagePath,
    double? latitude,
    double? longitude,
  }) async {
    // Create FormData for multipart/form-data request
    final formData = FormData.fromMap({
      if (firstName != null && firstName.isNotEmpty) 'firstName': firstName,
      if (lastName != null && lastName.isNotEmpty) 'lastName': lastName,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (password != null && password.isNotEmpty) 'password': password,
      if (countryId != null) 'countryId': countryId,
      if (cityId != null) 'cityId': cityId,
      if (address != null && address.isNotEmpty) 'address': address,
      if (birthday != null && birthday.isNotEmpty) 'birthday': birthday,
      if (notificationChannel != null && notificationChannel.isNotEmpty)
        'notificationChannel': notificationChannel,
      if (latitude != null && longitude != null)
        'location': {'lat': latitude, 'lng': longitude},
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });

    return _appApiServiceClient.updateDeliveryMan(id, formData);
  }
}
