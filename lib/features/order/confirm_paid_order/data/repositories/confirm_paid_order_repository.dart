import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/data/data_sources/confirm_paid_order_remote_data_source.dart';

class ConfirmPaidOrderRepository {
  final ConfirmPaidOrderRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ConfirmPaidOrderRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> confirmPaidOrder(
    String orderId, {
    String? imagePayFromDelivery,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.confirmPaidOrder(
        orderId,
        imagePayFromDelivery: imagePayFromDelivery,
      );

      BaseResponseModel<dynamic> baseResponseModel =
          BaseResponseModel<dynamic>.fromJson(
        response.data!,
        (json) => json,
      );

      if (baseResponseModel.status == 200 ||
          baseResponseModel.success == true ||
          baseResponseModel.statusCode == 200) {
        return const Right(null);
      }
      return Left(ErrorHandler.handle(DioException(
        type: DioExceptionType.badResponse,
        response: response,
        requestOptions: RequestOptions(),
      )));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
