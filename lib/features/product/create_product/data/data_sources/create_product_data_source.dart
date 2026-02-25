import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateProductRemoteDataSource {
  Future<Response> createProduct(FormData formData);
}

class CreateProductRemoteDataSourceImpl
    implements CreateProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createProduct(FormData formData) {
    return _appApiServiceClient.createProduct(formData);
  }
}

