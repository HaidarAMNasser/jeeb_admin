import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteMerchantRemoteDataSource {
  Future<Response> deleteMerchant(String id);
}

class DeleteMerchantRemoteDataSourceImpl
    implements DeleteMerchantRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteMerchantRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteMerchant(String id) {
    return _appApiServiceClient.deleteMerchant(id);
  }
}

