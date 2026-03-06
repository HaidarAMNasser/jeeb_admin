import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ProfileRemoteDataSource {
  Future<Response> getProfile();

  Future<Response> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ProfileRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getProfile() {
    return _appApiServiceClient.getProfile();
  }

  @override
  Future<Response> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
  }) {
    return _appApiServiceClient.updateProfile(
      firstName,
      lastName,
      phone,
      countryId,
      cityId,
      address,
      latitude,
      longitude,
      isActive,
    );
  }
}

