import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/data/data_sourse/create_offer_price_data_sourse.dart';
// Import your actual Offer Price models and entities
import 'package:fatoorahapp/feature/offer_price/offer_price/data/models/offer_price_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/mapper/offer_price_mapper.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

class OfferPriceCreateRepository {
  final OfferPriceCreateRemoteDataSource _remoteDataSource;
  final InternetConnection _internetConnection;

  const OfferPriceCreateRepository(
    this._remoteDataSource,
    this._internetConnection,
  );

  Future<Either<Failure, CreateOfferPriceDataEntity>> createOfferPrice({
    required String referenceNumber,
    required int userId,
    required String supplyDate,
    required String serviceEndDate,
    required int workPalceId,
    required String expirationDate,
    required int employeeId,
    required List<PaymentMethodEntryOffer> payments,
    required String date,
    required int status,
    required List<CreateProductEntity> details,
  }) async {
    if (await _internetConnection.isConnected) {
      try {
        final response = await _remoteDataSource.createOfferPrice(
          referenceNumber: referenceNumber,
          userId: userId,
          supplyDate: supplyDate,
          serviceEndDate: serviceEndDate,
          workPalceId: workPalceId,
          expirationDate: expirationDate,
          employeeId: employeeId,
          payments: payments,
          date: date,
          status: status,
          details: details,
        );

        BaseResponseModel<CreateOfferPriceDataModel> baseResponseModel =
            BaseResponseModel<CreateOfferPriceDataModel>.fromJson(
          response.data!,
          (json) {
            // Handle case where data field is a JSON string instead of a Map
            if (json is String) {
              final parsedJson = jsonDecode(json) as Map<String, dynamic>;
              return CreateOfferPriceDataModel.fromJson(parsedJson);
            } else if (json is Map<String, dynamic>) {
              return CreateOfferPriceDataModel.fromJson(json);
            } else {
              throw FormatException('Expected data to be String or Map, but got ${json.runtimeType}');
            }
          },
        );

        if (baseResponseModel.status == ApiInternalStatus.success ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          
          // Check if data is null before calling toDomain()
          if (baseResponseModel.data == null) {
            print('❌ Error: Response data is null');
            return Left(ErrorHandler.handle(DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: RequestOptions(),
            )).failure);
          }

          try {
            return Right(baseResponseModel.data!.toDomain());
          } catch (domainError) {
            print('❌ Error converting to domain: $domainError');
            return Left(ErrorHandler.handle(domainError).failure);
          }
        } else {
          print('❌ API status is not success. Status: ${baseResponseModel.status}, Success: ${baseResponseModel.success}');
          return Left(ErrorHandler.handle(DioException(
            type: DioExceptionType.badResponse,
            response: response,
            requestOptions: RequestOptions(),
          )).failure);
        }
      } catch (error) {
        print("❌ Error in createOfferPrice catch section: $error");
        print("   Error type: ${error.runtimeType}");
        if (error is DioException) {
          print("   DioException response: ${error.response?.data}");
        }
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
