import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/data/data_sources/merchant_statistics_data_source.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/data/models/merchant_statistics_model.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';

class MerchantStatisticsRepository {
  final MerchantStatisticsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const MerchantStatisticsRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, MerchantStatisticsPageEntity>> getMerchantStatistics({
    int? page,
    int? limit,
    String? search,
    String? from,
    String? to,
    int? merchantId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.getMerchantStatistics(
        page: page,
        limit: limit,
        search: search,
        from: from,
        to: to,
        merchantId: merchantId,
      );
      final raw = response.data as Map<String, dynamic>?;
      final statusCode = raw?['statusCode'] as int? ?? response.statusCode ?? 0;
      if (raw == null || statusCode < 200 || statusCode >= 300) {
        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ),
        );
      }

      final items = (raw['data'] as List? ?? const [])
          .map(
            (item) => MerchantStatisticsModel.fromJson(
              item as Map<String, dynamic>,
            ).toDomain(),
          )
          .toList();
      final pagination = MerchantStatisticsPaginationModel.fromJson(
        raw['pagination'] as Map<String, dynamic>?,
      ).pagination;

      return Right(
        MerchantStatisticsPageEntity(
          items: items,
          pagination: pagination,
        ),
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
