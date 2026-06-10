import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';

class MerchantStatisticsModel {
  final int id;
  final int userId;
  final String? name;
  final String type;
  final MerchantStatsLocation location;
  final MerchantStatsValues stats;

  const MerchantStatisticsModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.location,
    required this.stats,
  });

  factory MerchantStatisticsModel.fromJson(Map<String, dynamic> json) {
    int intFromJson(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    double? doubleFromJson(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    MerchantStatsLocalizedName localizedName(dynamic value) {
      if (value is Map<String, dynamic>) {
        return MerchantStatsLocalizedName(
          ar: value['ar']?.toString() ?? '',
          en: value['en']?.toString() ?? '',
        );
      }
      return const MerchantStatsLocalizedName(ar: '', en: '');
    }

    MerchantStatsPlace? place(dynamic value) {
      if (value is! Map<String, dynamic>) return null;
      return MerchantStatsPlace(
        id: intFromJson(value['id']),
        name: localizedName(value['name']),
      );
    }

    MerchantStatsCoordinates? coordinates(dynamic value) {
      if (value is! Map<String, dynamic>) return null;
      final lat = doubleFromJson(value['lat']);
      final lng = doubleFromJson(value['lng']);
      if (lat == null || lng == null) return null;
      return MerchantStatsCoordinates(lat: lat, lng: lng);
    }

    final locationJson = json['location'] as Map<String, dynamic>?;
    final statsJson = json['stats'] as Map<String, dynamic>?;

    return MerchantStatisticsModel(
      id: intFromJson(json['id']),
      userId: intFromJson(json['userId']),
      name: json['name']?.toString(),
      type: json['type']?.toString() ?? '',
      location: MerchantStatsLocation(
        country: place(locationJson?['country']),
        city: place(locationJson?['city']),
        coordinates: coordinates(locationJson?['coordinates']),
      ),
      stats: MerchantStatsValues(
        totalOrders: intFromJson(statsJson?['totalOrders']),
        totalRevenue: intFromJson(statsJson?['totalRevenue']),
      ),
    );
  }

  MerchantStatisticsEntity toDomain() {
    return MerchantStatisticsEntity(
      id: id,
      userId: userId,
      name: name,
      type: type,
      location: location,
      stats: stats,
    );
  }
}

class MerchantStatisticsPaginationModel {
  final MerchantStatisticsPagination pagination;

  const MerchantStatisticsPaginationModel(this.pagination);

  factory MerchantStatisticsPaginationModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    int intFromJson(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    if (json == null) {
      return const MerchantStatisticsPaginationModel(
        MerchantStatisticsPagination.empty(),
      );
    }
    return MerchantStatisticsPaginationModel(
      MerchantStatisticsPagination(
        total: intFromJson(json['total']),
        page: intFromJson(json['page']),
        limit: intFromJson(json['limit']),
        totalPages: intFromJson(json['totalPages']),
        hasNextPage: json['hasNextPage'] == true,
        hasPreviousPage: json['hasPreviousPage'] == true,
      ),
    );
  }
}
