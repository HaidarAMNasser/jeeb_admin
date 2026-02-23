import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateProductRemoteDataSource {
  Future<Response> updateProduct({
    required String id,
    required String name,
    String? description,
    required double price,
    required String categoryId,
    int? quantity,
    required List<String> images,
  });
}

class UpdateProductRemoteDataSourceImpl
    implements UpdateProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateProduct({
    required String id,
    required String name,
    String? description,
    required double price,
    required String categoryId,
    int? quantity,
    required List<String> images,
  }) {
    return _appApiServiceClient.updateProduct(
      id,
      name,
      description,
      price,
      categoryId,
      quantity,
      images,
    );
  }
}

