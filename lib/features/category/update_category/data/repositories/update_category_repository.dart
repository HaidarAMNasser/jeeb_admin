import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/update_category/data/data_sources/update_category_data_source.dart';

class UpdateCategoryRepository {
  final UpdateCategoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const UpdateCategoryRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, CategoryEntity>> updateCategory({

    required int id,
    required String name,
    String? imagePath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.updateCategory(
          id: id,
          name: name,
          imagePath: imagePath,
        );

        BaseResponseModel<dynamic> baseResponseModel =
            BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          dynamic data = baseResponseModel.data;
          if (data is String) {
            data = jsonDecode(data);
          }
          if (data is Map<String, dynamic>) {
            String? imageUrl;
            final images = data['images'];
            if (images is List && images.isNotEmpty) {
              final first = images.first;
              if (first is Map && first['url'] != null) {
                imageUrl = first['url']?.toString();
              }
            }
            final categoryEntity = CategoryEntity(

              id: (data['id'] as num?)?.toInt() ?? id,
              name: data['name']?.toString() ?? name,
              imageUrl: imageUrl,
            );
            return Right(categoryEntity);
          } else {
            return Right(CategoryEntity(id: id, name: name, imageUrl: null));
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
