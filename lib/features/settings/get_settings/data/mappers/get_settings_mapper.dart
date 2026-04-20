import 'package:jeeb_admin/features/settings/get_settings/domain/entities/settings_entity.dart';

/// Maps API response data map to [SettingsEntity].
/// API returns data as map of key -> { id, key, value, description, isActive, ... }.
class GetSettingsMapper {
  const GetSettingsMapper._();

  static String _valueToString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    return v.toString();
  }

  static num _valueToNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  static int _valueToInt(dynamic v, {int fallback = 3}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.round();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static SettingsEntity fromJson(Map<String, dynamic>? data) {
    if (data == null) {
      return const SettingsEntity(
        supportPhone: '',
        whatsappNumber: '',
        defaultProductCommissionRate: 0,
        deliveryTipPerKilometer: 0,
        maxIncompleteOrdersForDriverSearch: 3,
      );
    }

    final supportPhoneObj = data['supportPhone'] as Map<String, dynamic>?;
    final whatsappObj = data['whatsappNumber'] as Map<String, dynamic>?;
    final commissionObj = data['defaultProductCommissionRate'] as Map<String, dynamic>?;
    final tipKmObj = data['deliveryTipPerKilometer'] as Map<String, dynamic>?;
    final maxIncompleteObj =
        data['maxIncompleteOrdersForDriverSearch'] as Map<String, dynamic>?;

    return SettingsEntity(
      supportPhone: _valueToString(supportPhoneObj?['value']),
      whatsappNumber: _valueToString(whatsappObj?['value']),
      defaultProductCommissionRate: _valueToNum(commissionObj?['value']),
      deliveryTipPerKilometer: _valueToNum(tipKmObj?['value']),
      maxIncompleteOrdersForDriverSearch:
          _valueToInt(maxIncompleteObj?['value'], fallback: 3),
    );
  }
}
