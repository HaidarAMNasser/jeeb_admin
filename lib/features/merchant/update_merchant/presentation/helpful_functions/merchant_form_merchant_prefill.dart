import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';

class MerchantPrefillData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String restaurantName;
  final CountryEntity? country;
  final CityEntity? city;
  final String merchantBusinessType;
  final double? latitude;
  final double? longitude;
  final int? cityIdToHydrate;

  const MerchantPrefillData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.restaurantName,
    required this.country,
    required this.city,
    required this.merchantBusinessType,
    required this.latitude,
    required this.longitude,
    required this.cityIdToHydrate,
  });
}

MerchantPrefillData buildMerchantPrefillData(MerchantDetailsLoaded state) {
  final merchant = state.merchant;

  final prefillCountry = merchant.countryId != null
      ? CountryEntity(
          id: merchant.countryId!,
          name: CountryName(
            en: (merchant.countryName ?? '').trim().isEmpty
                ? '${merchant.countryId}'
                : (merchant.countryName ?? '').trim(),
            ar: (merchant.countryName ?? '').trim().isEmpty
                ? '${merchant.countryId}'
                : (merchant.countryName ?? '').trim(),
          ),
          code: '',
          callingCode: '',
          currencyCode: '',
          currencySymbol: '',
          currencySmallestUnit: '',
          currencyFactor: 1,
          isActive: true,
        )
      : null;

  final prefillCity = merchant.cityId != null
      ? CityEntity(
          id: merchant.cityId!,
          name: CityName(
            en: (merchant.cityName ?? '').trim().isEmpty
                ? '${merchant.cityId}'
                : (merchant.cityName ?? '').trim(),
            ar: (merchant.cityName ?? '').trim().isEmpty
                ? '${merchant.cityId}'
                : (merchant.cityName ?? '').trim(),
          ),
          countryId: merchant.countryId ?? 0,
        )
      : null;

  final merchantType = merchant.merchantType;
  final normalizedType =
      merchantType == 'STORE' || merchantType == 'RESTAURANT'
          ? merchantType!
          : 'RESTAURANT';

  return MerchantPrefillData(
    firstName: merchant.firstName ?? '',
    lastName: merchant.lastName ?? '',
    email: merchant.email,
    phone: merchant.phoneNumber ?? '',
    address: merchant.address ?? '',
    restaurantName: merchant.restaurantName,
    country: prefillCountry,
    city: prefillCity,
    merchantBusinessType: normalizedType,
    latitude: merchant.currentLat,
    longitude: merchant.currentLng,
    cityIdToHydrate: merchant.cityId,
  );
}
