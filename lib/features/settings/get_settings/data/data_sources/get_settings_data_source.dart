import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class GetSettingsRemoteDataSource {
  Future<Response> getSettings();
}

class GetSettingsRemoteDataSourceImpl implements GetSettingsRemoteDataSource {
  final AppApiServiceClient _api;

  GetSettingsRemoteDataSourceImpl(this._api);

  @override
  Future<Response> getSettings() => _api.getSettings();
}
