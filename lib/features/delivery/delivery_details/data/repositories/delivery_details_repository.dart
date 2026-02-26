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
import 'package:jeeb_admin/features/delivery/delivery_details/data/data_sources/delivery_details_data_source.dart';

class DeliveryDetailsRepository {
  final DeliveryDetailsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const DeliveryDetailsRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, DeliveryManEntity>> getDeliveryManDetails(
      String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getDeliveryManDetails(id);

        BaseResponseModel<DeliveryManModel> baseResponseModel =
            BaseResponseModel<DeliveryManModel>.fromJson(
          response.data!,
          (json) {
            if (json is String) {
              final parsedJson = jsonDecode(json) as Map<String, dynamic>;
              return DeliveryManModel.fromJson(parsedJson);
            } else if (json is Map<String, dynamic>) {
              return DeliveryManModel.fromJson(json);
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
