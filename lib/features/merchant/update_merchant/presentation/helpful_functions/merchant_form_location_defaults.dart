import 'package:jeeb_admin/core/common/utils/constants.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';

const double merchantFormDefaultLatitude = AppConstants.defaultMapLatitude;
const double merchantFormDefaultLongitude = AppConstants.defaultMapLongitude;

CountryEntity? findSyriaCountry(List<CountryEntity> countries) {
  for (final country in countries) {
    final en = country.name.en.toLowerCase();
    if (en == 'syria' || en.contains('syrian') || country.name.ar == 'سوريا') {
      return country;
    }
  }
  return null;
}

CityEntity? findRaqqahCity(List<CityEntity> cities) {
  for (final city in cities) {
    final en = city.name.en.toLowerCase();
    if (en.contains('raqq') ||
        en.contains('ar-raqq') ||
        city.name.ar.contains('الرقة')) {
      return city;
    }
  }
  return null;
}

bool isMerchantFormDefaultMapLocation(double? lat, double? lng) {
  if (lat == null || lng == null) return false;
  return (lat - merchantFormDefaultLatitude).abs() < 0.0001 &&
      (lng - merchantFormDefaultLongitude).abs() < 0.0001;
}
