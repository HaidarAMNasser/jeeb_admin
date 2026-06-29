import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/merchant/create_merchant/data/data_sources/create_merchant_data_source.dart';

class CreateMerchantRepository {
  final CreateMerchantRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const CreateMerchantRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> createMerchant({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required int countryId,
    required int cityId,
    required int areaId,
    required String restaurantName,
    required String merchantType,
    required double latitude,
    required double longitude,
    String? address,
    String? notificationChannel,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.createMerchant(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phone: phone,
          countryId: countryId,
          cityId: cityId,
          areaId: areaId,
          restaurantName: restaurantName,
          merchantType: merchantType,
          latitude: latitude,
          longitude: longitude,
          address: address,
          notificationChannel: notificationChannel,
        );

        final baseResponseModel = BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 201 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 201) {
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
