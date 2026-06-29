import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ResetMerchantPasswordRemoteDataSource {
  Future<Response> resetMerchantPassword({
    required String id,
    required String password,
  });
}

class ResetMerchantPasswordRemoteDataSourceImpl
    implements ResetMerchantPasswordRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ResetMerchantPasswordRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> resetMerchantPassword({
    required String id,
    required String password,
  }) {
    return _appApiServiceClient.resetMerchantPassword(id, password);
  }
}
