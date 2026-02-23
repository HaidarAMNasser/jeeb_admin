import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateProductRemoteDataSource {
  Future<Response> createProduct({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    int? quantity,
    required List<String> images,
  });
}

class CreateProductRemoteDataSourceImpl
    implements CreateProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createProduct({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    int? quantity,
    required List<String> images,
  }) {
    return _appApiServiceClient.createProduct(
      name,
      description,
      price,
      categoryId,
      quantity,
      images,
    );
  }
}

