import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/create_merchant/presentation/bloc/create_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/helpful_functions/merchant_form_validation.dart';

void submitMerchantForm({
  required BuildContext context,
  required bool isEditMode,
  required String? merchantId,
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String password,
  required String restaurantName,
  required String address,
  required int? countryId,
  required int? cityId,
  required int? areaId,
  required String merchantBusinessType,
  required double? latitude,
  required double? longitude,
}) {
  merchantFormValidationToast(
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    restaurantName: restaurantName,
    address: address,
    countryId: countryId,
    cityId: cityId,
    areaId: areaId,
    latitude: latitude,
    longitude: longitude,
    isEditMode: isEditMode,
    password: password,
  );

  if (!isMerchantFormValid(
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    restaurantName: restaurantName,
    address: address,
    countryId: countryId,
    cityId: cityId,
    areaId: areaId,
    latitude: latitude,
    longitude: longitude,
    isEditMode: isEditMode,
    password: password,
  )) {
    return;
  }

  if (isEditMode) {
    context.read<UpdateMerchantBloc>().add(
          UpdateMerchantSubmitted(
            id: merchantId!,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: email,
            countryId: countryId,
            cityId: cityId,
            areaId: areaId,
            restaurantName: restaurantName,
            merchantType: merchantBusinessType,
            latitude: latitude,
            longitude: longitude,
            address: address,
          ),
        );
    return;
  }

  context.read<CreateMerchantBloc>().add(
        CreateMerchantSubmitted(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phone: phone,
          countryId: countryId!,
          cityId: cityId!,
          areaId: areaId!,
          restaurantName: restaurantName,
          merchantType: merchantBusinessType,
          latitude: latitude!,
          longitude: longitude!,
          address: address,
          notificationChannel: 'WHATSAPP',
        ),
      );
}
