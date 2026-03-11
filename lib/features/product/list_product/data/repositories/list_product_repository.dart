import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/data/data_sources/list_product_data_source.dart';
import 'package:jeeb_admin/features/product/list_product/data/mappers/product_mapper.dart';
import 'package:jeeb_admin/features/product/list_product/data/models/product_model.dart';

class ListProductRepository {
  final ListProductRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ListProductRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? page,
    int? limit,
    String? search,
    String? categoryId,
    String? restaurantId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.getProducts(
        page: page,
        limit: limit,
        search: search,
        categoryId: categoryId,
        restaurantId: restaurantId,
      );

      final responseData = response.data;
      if (responseData == null) {
        return Left(ErrorHandler.handle(DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: response.requestOptions,
        )));
      }

      BaseResponseModel<List<ProductModel>> baseResponseModel =
          BaseResponseModel<List<ProductModel>>.fromJson(
        responseData,
        (json) {
          List<dynamic> rawList;
          if (json == null) {
            rawList = [];
          } else if (json is String) {
            final parsedJson = jsonDecode(json) as List<dynamic>? ?? [];
            rawList = parsedJson;
          } else if (json is List) {
            rawList = json;
          } else if (json is Map<String, dynamic>) {
            final list = json['items'] ?? json['content'] ?? json['data'];
            if (list is List) {
              rawList = list;
            } else if (list == null) {
              rawList = [];
            } else {
              throw FormatException(
                  'Expected data to be String, List, or Map with items/content/data, but got map with non-list value');
            }
          } else {
            throw FormatException(
                'Expected data to be String, List, or Map, but got ${json.runtimeType}');
          }
          return rawList
              .whereType<Map>()
              .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
              .where((model) => model.id.isNotEmpty)
              .toList();
        },
      );

      if (baseResponseModel.status == 200 ||
          baseResponseModel.success == true ||
          baseResponseModel.statusCode == 200) {
        final data = baseResponseModel.data;
        if (data == null) {
          return const Right([]);
        }
        try {
          return Right(data.toDomain());
        } catch (domainError) {
          return Left(ErrorHandler.handle(domainError));
        }
      } else {
        return Left(ErrorHandler.handle(DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: response.requestOptions,
        )));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}

