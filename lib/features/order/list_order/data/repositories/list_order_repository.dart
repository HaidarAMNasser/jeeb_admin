import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/order/list_order/data/data_sources/list_order_data_source.dart';
import 'package:jeeb_admin/features/order/order_details/data/models/order_model.dart';
import 'package:jeeb_admin/features/order/order_details/data/mappers/order_mapper.dart';

class ListOrderRepository {
  final ListOrderRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ListOrderRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, List<OrderEntity>>> getOrders({
    int? page,
    int? limit,
    String? search,
    String? merchantId,
    String? status,
    bool filterMerchantOthers = false,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getOrders(
          page: page,
          limit: limit,
          search: search,
          status: status,
          merchantId: merchantId,
        );

        BaseResponseModel<List<OrderModel>> baseResponseModel =
            BaseResponseModel<List<OrderModel>>.fromJson(
          response.data!,
          (json) {
            if (json is String) {
              final parsedJson = jsonDecode(json) as List<dynamic>;
              return parsedJson
                  .map((item) =>
                      OrderModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            } else if (json is List) {
              return json
                  .map((item) =>
                      OrderModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            } else {
              throw FormatException(
                  'Expected data to be String or List, but got ${json.runtimeType}');
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
            var list = baseResponseModel.data!.toDomain();
            if (filterMerchantOthers) {
              list = list
                  .where((o) => o.statusEnum != OrderStatus.pending)
                  .toList();
            }
            return Right(list);
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

  Future<Either<Failure, void>> confirmOrder(
    String orderId, {
    int? mealPreparationTime,
    int? deliveryTime,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final body = <String, dynamic>{};
      if (mealPreparationTime != null) {
        body['mealPreparationTime'] = mealPreparationTime;
      }
      if (deliveryTime != null) {
        body['deliveryTime'] = deliveryTime;
      }
      final response = await _remoteDataSource.confirmOrder(
        orderId,
        body.isEmpty ? null : body,
      );
      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
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

  Future<Either<Failure, void>> setOrderPreparing(String orderId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.setOrderPreparing(orderId);
      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
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

  Future<Either<Failure, void>> setOrderReadyForPickup(String orderId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.setOrderReadyForPickup(orderId);
      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
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

