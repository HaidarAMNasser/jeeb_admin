import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/mappers/delivery_man_mapper.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/models/delivery_man_model.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/data/data_sources/list_delivery_data_source.dart';

class ListDeliveryRepository {
  final ListDeliveryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ListDeliveryRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, List<DeliveryManEntity>>> getDeliveryMen({
    int? page,
    int? limit,
    String? search,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getDeliveryMen(
          page: page,
          limit: limit,
          search: search,
        );

        BaseResponseModel<List<DeliveryManModel>> baseResponseModel =
            BaseResponseModel<List<DeliveryManModel>>.fromJson(
          response.data!,
          (json) {
            if (json is String) {
              final parsedJson = jsonDecode(json) as List<dynamic>;
              return parsedJson
                  .map((item) =>
                      DeliveryManModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            } else if (json is List) {
              return json
                  .map((item) =>
                      DeliveryManModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            } else {
              throw FormatException(
                  'Expected data to be String or List, but got ${json.runtimeType}');
            }
          },
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
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
