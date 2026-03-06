import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/product/confirm_product/data/data_sources/confirm_product_data_source.dart';

class ConfirmProductRepository {
  final ConfirmProductRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ConfirmProductRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> confirmProduct({
    required String productId,
    required double newPrice,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Right(null);
    }
    try {
      final response = await _remoteDataSource.confirmProduct(
        productId: productId,
        newPrice: newPrice,
      );

      final baseResponse = BaseResponseModel<dynamic>.fromJson(
        response.data!,
        (json) => json,
      );

      if (baseResponse.status == 200 ||
          baseResponse.success == true ||
          baseResponse.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      }
    } catch (error) {
      return const Right(null);
    }
  }
}

