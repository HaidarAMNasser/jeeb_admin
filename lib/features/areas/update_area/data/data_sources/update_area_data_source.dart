import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateAreaRemoteDataSource {
  Future<Response> updateArea({
    required String id,
    required Map<String, dynamic> body,
  });
}

class UpdateAreaRemoteDataSourceImpl implements UpdateAreaRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateAreaRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateArea({
    required String id,
    required Map<String, dynamic> body,
  }) {
    return _appApiServiceClient.updateArea(id, body);
  }
}
