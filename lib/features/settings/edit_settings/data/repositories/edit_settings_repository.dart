import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/settings/edit_settings/data/data_sources/edit_settings_data_source.dart';

class EditSettingsRepository {
  final EditSettingsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const EditSettingsRepository(this._remoteDataSource, this._networkInfo);

  Future<Either<Failure, void>> patchSettings(List<Map<String, dynamic>> body) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.patchSettings(body);
      final responseData = response.data;
      if (responseData == null || responseData is! Map<String, dynamic>) {
        return Left(ErrorHandler.handle(DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: response.requestOptions,
        )));
      }

      final statusCode = responseData['statusCode'] as int? ?? responseData['status_code'] as int?;
      if (statusCode != 200) {
        final message = responseData['message'] as String? ?? 'Unknown error';
        return Left(ServerFailure(message: message));
      }

      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
