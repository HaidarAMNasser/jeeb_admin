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

  static Map<String, dynamic>? _settingObjByKey(
    Map<String, dynamic> data,
    String settingKey,
  ) {
    final direct = data[settingKey];
    if (direct is Map<String, dynamic>) return direct;
    if (direct is Map) return Map<String, dynamic>.from(direct);

    // Some API responses return indexed objects: {"0": {...}, "1": {...}}
    for (final entry in data.values) {
      if (entry is! Map) continue;
      final map = entry is Map<String, dynamic>
          ? entry
          : Map<String, dynamic>.from(entry);
      if (map['key']?.toString() == settingKey) {
        return map;
      }
    }
    return null;
  }

  static SettingsEntity fromJson(Map<String, dynamic>? data) {
    if (data == null) {
      return const SettingsEntity(
        supportPhone: '',
        whatsappNumber: '',
        defaultProductCommissionRate: 0,
        deliveryTipPerKilometer: 0,
        maxOrdersPerDelivery: 3,
      );
    }

    final supportPhoneObj = _settingObjByKey(data, 'supportPhone');
    final whatsappObj = _settingObjByKey(data, 'whatsappNumber');
    final commissionObj = _settingObjByKey(data, 'defaultProductCommissionRate');
    final tipKmObj = _settingObjByKey(data, 'deliveryTipPerKilometer');
    final maxOrdersObj = _settingObjByKey(data, 'maxOrdersPerDelivery') ??
        _settingObjByKey(data, 'maxIncompleteOrdersForDriverSearch');

    return SettingsEntity(
      supportPhone: _valueToString(supportPhoneObj?['value']),
      whatsappNumber: _valueToString(whatsappObj?['value']),
      defaultProductCommissionRate: _valueToNum(commissionObj?['value']),
      deliveryTipPerKilometer: _valueToNum(tipKmObj?['value']),
      maxOrdersPerDelivery:
          _valueToInt(maxOrdersObj?['value'], fallback: 3),
    );
  }
}
