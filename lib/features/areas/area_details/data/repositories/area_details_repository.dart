import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/areas/area_details/data/data_sources/area_details_data_source.dart';
import 'package:jeeb_admin/features/areas/list_areas/data/mappers/area_mapper.dart';
import 'package:jeeb_admin/features/areas/list_areas/data/models/area_model.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

class AreaDetailsRepository {
  final AreaDetailsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AreaDetailsRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, AreaEntity>> getAreaDetails(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getAreaDetails(id);

        BaseResponseModel<AreaModel> baseResponseModel =
            BaseResponseModel<AreaModel>.fromJson(
          response.data!,
          (json) {
            if (json is String) {
              final parsedJson = jsonDecode(json) as Map<String, dynamic>;
              return AreaModel.fromJson(parsedJson);
            } else if (json is Map<String, dynamic>) {
              return AreaModel.fromJson(json);
            } else {
              throw FormatException(
                  'Expected data to be String or Map, but got ${json.runtimeType}');
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
