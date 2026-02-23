import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/add_category/data/data_sources/add_category_data_source.dart';

class AddCategoryRepository {
  final AddCategoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AddCategoryRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, CategoryEntity>> addCategory({
    required String name,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.addCategory(name: name);

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
            final categoryEntity = CategoryEntity(
              id: data['id']?.toString() ?? '',
              name: data['name']?.toString() ?? name,
            );
            return Right(categoryEntity);
          } else {
            // If no data returned, create entity with just the name
            return Right(CategoryEntity(id: '', name: name));
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

