import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class EditSettingsRemoteDataSource {
  Future<Response> patchSettings(List<Map<String, dynamic>> body);
}

class EditSettingsRemoteDataSourceImpl implements EditSettingsRemoteDataSource {
  final AppApiServiceClient _api;

  EditSettingsRemoteDataSourceImpl(this._api);

  @override
  Future<Response> patchSettings(List<Map<String, dynamic>> body) =>
      _api.patchSettings(body);
}
