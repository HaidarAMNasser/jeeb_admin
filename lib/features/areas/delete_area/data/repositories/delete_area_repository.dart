import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/areas/delete_area/data/data_sources/delete_area_data_source.dart';

class DeleteAreaRepository {
  final DeleteAreaRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const DeleteAreaRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> deleteArea(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.deleteArea(id);

        BaseResponseModel<dynamic> baseResponseModel =
            BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200 ||
            baseResponseModel.statusCode == 204) {
          return const Right(null);
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
