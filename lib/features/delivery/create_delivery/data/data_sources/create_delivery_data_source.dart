import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateDeliveryRemoteDataSource {
  Future<Response> createDeliveryMan({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    int? countryId,
    int? cityId,
    String? address,
    String? birthday,
    String? notificationChannel,
    int? officeOwnerId,
    String? imagePath,
    double? latitude,
    double? longitude,
  });
}

class CreateDeliveryRemoteDataSourceImpl
    implements CreateDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createDeliveryMan({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    int? countryId,
    int? cityId,
    String? address,
    String? birthday,
    String? notificationChannel,
    int? officeOwnerId,
    String? imagePath,
    double? latitude,
    double? longitude,
  }) async {
    // Create FormData for multipart/form-data request
    final formDataMap = <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      if (countryId != null) 'countryId': countryId,
      if (cityId != null) 'cityId': cityId,
      if (address != null && address.isNotEmpty) 'address': address,
      if (birthday != null && birthday.isNotEmpty) 'birthday': birthday,
      if (notificationChannel != null && notificationChannel.isNotEmpty)
        'notificationChannel': notificationChannel,
      if (officeOwnerId != null) 'officeOwnerId': officeOwnerId,
      if (latitude != null && longitude != null)
        'location': jsonEncode({'lat': latitude, 'lng': longitude}),
    };

    if (imagePath != null && imagePath.isNotEmpty) {
      formDataMap['image'] = await MultipartFile.fromFile(imagePath);
    }

    final formData = FormData.fromMap(formDataMap);

    return _appApiServiceClient.createDeliveryMan(formData);
  }
}
