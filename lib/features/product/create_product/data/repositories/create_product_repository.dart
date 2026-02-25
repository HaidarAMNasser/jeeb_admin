import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/create_product/data/data_sources/create_product_data_source.dart';
import 'package:jeeb_admin/features/product/list_product/data/mappers/product_mapper.dart';
import 'package:jeeb_admin/features/product/list_product/data/models/product_model.dart';

class CreateProductRepository {
  final CreateProductRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const CreateProductRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, ProductEntity>> createProduct(FormData formData) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.createProduct(formData);

        BaseResponseModel<ProductModel> baseResponseModel =
            BaseResponseModel<ProductModel>.fromJson(
          response.data!,
          (json) {
            if (json is String) {
              final parsedJson = jsonDecode(json) as Map<String, dynamic>;
              return ProductModel.fromJson(parsedJson);
            } else if (json is Map<String, dynamic>) {
              return ProductModel.fromJson(json);
            } else {
              throw FormatException(
                  'Expected data to be String or Map, but got ${json.runtimeType}');
            }
          },
        );

        if (baseResponseModel.statusCode == 201 ||
            baseResponseModel.statusCode == 200 ||
            baseResponseModel.success == true) {
          if (baseResponseModel.data == null) {
            return Left(ErrorHandler.handle(DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: RequestOptions(),
            )));
          }

          try {
            return Right(baseResponseModel.data!.toDomain());
          } catch (domainError) {
            return Left(ErrorHandler.handle(domainError));
          }
        } else {
          return Left(ErrorHandler.handle(DioException(
            type: DioExceptionType.badResponse,
            response: response,
            requestOptions: RequestOptions(),
          )));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}

