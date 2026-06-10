import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/common/errors/failure.dart';
import '../../../../../core/common/models/api_response_model.dart';
import '../../../../../core/common/utils/error_handler.dart';
import '../../../../../core/infrastructure/network/network_info.dart';
import '../../domain/entities/verify_result_entity.dart';
import '../data_sources/verify_remote_data_source.dart';

class VerifyRepository {
  final VerifyRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const VerifyRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  /// Returns [VerifyResultEntity] on success so the bloc can read token+user if present.
  Future<Either<Failure, VerifyResultEntity>> verify({
    required String email,
    required String otp,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.verify(
          email: email,
          otp: otp,
        );

        final raw = response.data;
        final jsonMap = raw is Map ? Map<String, dynamic>.from(raw) : null;
        if (jsonMap == null) {
          return Left(ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ));
        }
        final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
          jsonMap,
          (json) => json != null && json is Map
              ? Map<String, dynamic>.from(json)
              : <String, dynamic>{},
        );

        if (apiResponse.isSuccess) {
          final data = apiResponse.data is Map
              ? Map<String, dynamic>.from(apiResponse.data as Map)
              : <String, dynamic>{};
          return Right(
            VerifyResultEntity(
              statusCode: apiResponse.statusCode,
              message: apiResponse.message,
              data: data,
            ),
          );
        } else {
          return Left(ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  Future<Either<Failure, void>> resendOtp({
    required String email,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.resendOtp(email: email);

        final apiResponse = ApiResponseModel<void>.fromJson(
          response.data as Map<String, dynamic>,
          null,
        );

        if (apiResponse.isSuccess) {
          return const Right(null);
        } else {
          return Left(ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}

