import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/data/data_sources/update_merchant_data_source.dart';

class UpdateMerchantRepository {
  final UpdateMerchantRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const UpdateMerchantRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> updateMerchant({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    int? countryId,
    int? cityId,
    String? address,
    bool? hidePhoneNumber,
    bool? isActive,
    String? imagePath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.updateMerchant(
          id: id,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          countryId: countryId,
          cityId: cityId,
          address: address,
          hidePhoneNumber: hidePhoneNumber,
          isActive: isActive,
          imagePath: imagePath,
        );

        final baseResponseModel = BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          return const Right(null);
        }

        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
