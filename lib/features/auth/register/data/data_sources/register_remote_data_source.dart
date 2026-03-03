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
  }) {
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
    );
  }
}

