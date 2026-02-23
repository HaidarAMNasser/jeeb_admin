import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/update_product/data/data_sources/update_product_data_source.dart';

class UpdateProductRepository {
  final UpdateProductRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const UpdateProductRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, ProductEntity>> updateProduct({
    required String id,
    required String name,
    String? description,
    required double price,
    required String categoryId,
    int? quantity,
    required List<String> images,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.updateProduct(
          id: id,
          name: name,
          description: description,
          price: price,
          categoryId: categoryId,
          quantity: quantity,
          images: images,
        );

        BaseResponseModel<dynamic> baseResponseModel =
            BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          // Construct entity directly from response data
          dynamic data = baseResponseModel.data;
          if (data is String) {
            data = jsonDecode(data);
          }
          
          if (data is Map<String, dynamic>) {
            final productEntity = ProductEntity(
              id: data['id']?.toString() ?? id,
              name: data['name']?.toString() ?? name,
              description: data['description']?.toString(),
              price: (data['price'] as num?)?.toDouble() ?? price,
              categoryId: data['category_id']?.toString() ?? categoryId,
              categoryName: data['category_name']?.toString() ?? '',
              quantity: data['quantity'] as int? ?? quantity,
              images: data['images'] != null
                  ? List<String>.from(data['images'] as List)
                  : images,
            );
            return Right(productEntity);
          } else {
            // If no data returned, create entity with provided values
            return Right(ProductEntity(
              id: id,
              name: name,
              description: description,
              price: price,
              categoryId: categoryId,
              categoryName: '',
              quantity: quantity,
              images: images,
            ));
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

