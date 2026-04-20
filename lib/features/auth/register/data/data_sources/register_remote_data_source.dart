import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class RegisterRemoteDataSource {
  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String role,
    int? countryId,
    int? cityId,
    double? latitude,
    double? longitude,
    required String notificationChannel,
    String? address,
    String? restaurantName,
    /// `RESTAURANT` or `STORE` — sent only for [role] `MERCHANT` via `POST users/merchants`.
    String? merchantType,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  RegisterRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String role,
    int? countryId,
    int? cityId,
    double? latitude,
    double? longitude,
    required String notificationChannel,
    String? address,
    String? restaurantName,
    String? merchantType,
  }) {
    if (role == 'MERCHANT') {
      final type = (merchantType == 'STORE' || merchantType == 'RESTAURANT')
          ? merchantType!
          : 'RESTAURANT';
      final map = <String, dynamic>{
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'type': type,
        if (latitude != null && longitude != null)
          'location': jsonEncode({'lat': latitude, 'lng': longitude}),
      };
      if (countryId != null) map['countryId'] = countryId;
      if (cityId != null) map['cityId'] = cityId;
      if (address != null && address.isNotEmpty) map['address'] = address;
      if (restaurantName != null && restaurantName.isNotEmpty) {
        map['restaurantName'] = restaurantName;
      }
      return _appApiServiceClient.createMerchant(FormData.fromMap(map));
    }

    return _appApiServiceClient.register(
      firstName,
      lastName,
      email,
      password,
      phone,
      role,
      countryId,
      cityId,
      latitude,
      longitude,
      notificationChannel,
      address,
      restaurantName,
    );
  }
}

