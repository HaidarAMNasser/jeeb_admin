class AreaModel {
  final String id;
  final String name;
  final int price;
  final String? description;

  AreaModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  /// API may return price as int, num, or string (e.g. "1500", "1500.00", "15.00").
  /// App stores price in smallest currency unit (piastres).
  static int _parsePriceInSmallestUnit(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.round();

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return fallback;

      final parsed = num.tryParse(trimmed);
      if (parsed == null) return fallback;

      // Decimal strings under 1000 are major units (e.g. "15.00" SYP → 1500).
      if (trimmed.contains('.') && parsed.abs() < 1000) {
        return (parsed * 100).round();
      }

      return parsed.round();
    }

    return fallback;
  }

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id']?.toString() ?? '',
      name: _parseName(json['name']),
      price: _parsePriceInSmallestUnit(json['price']),
      description: json['description']?.toString(),
    );
  }

  static String _parseName(dynamic name) {
    if (name is String) return name;
    if (name is Map) {
      final en = name['en']?.toString().trim() ?? '';
      final ar = name['ar']?.toString().trim() ?? '';
      if (en.isNotEmpty) return en;
      if (ar.isNotEmpty) return ar;
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      if (description != null) 'description': description,
    };
  }
}
