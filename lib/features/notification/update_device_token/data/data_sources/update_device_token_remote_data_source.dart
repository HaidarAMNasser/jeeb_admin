import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateDeviceTokenRemoteDataSource {
  Future<Response> updateDeviceToken({
    required String token,
    required String platform,
  });
}

class UpdateDeviceTokenRemoteDataSourceImpl
    implements UpdateDeviceTokenRemoteDataSource {
  final AppApiServiceClient _client;

  UpdateDeviceTokenRemoteDataSourceImpl(this._client);

  @override
  Future<Response> updateDeviceToken({
    required String token,
    required String platform,
  }) {
    return _client.updateDeviceToken(token: token, platform: platform);
  }
}
