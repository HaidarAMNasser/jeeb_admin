import 'package:equatable/equatable.dart';

class MerchantStatsLocalizedName extends Equatable {
  final String ar;
  final String en;

  const MerchantStatsLocalizedName({required this.ar, required this.en});

  String displayName(String languageCode) {
    if (languageCode == 'ar' && ar.isNotEmpty) return ar;
    if (en.isNotEmpty) return en;
    return ar;
  }

  @override
  List<Object?> get props => [ar, en];
}

class MerchantStatsPlace extends Equatable {
  final int id;
  final MerchantStatsLocalizedName name;

  const MerchantStatsPlace({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class MerchantStatsCoordinates extends Equatable {
  final double lat;
  final double lng;

  const MerchantStatsCoordinates({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

class MerchantStatsLocation extends Equatable {
  final MerchantStatsPlace? country;
  final MerchantStatsPlace? city;
  final MerchantStatsCoordinates? coordinates;

  const MerchantStatsLocation({
    this.country,
    this.city,
    this.coordinates,
  });

  @override
  List<Object?> get props => [country, city, coordinates];
}

class MerchantStatsValues extends Equatable {
  final int totalOrders;
  final int totalRevenue;

  const MerchantStatsValues({
    required this.totalOrders,
    required this.totalRevenue,
  });

  double get totalRevenueDisplay => totalRevenue / 100;

  @override
  List<Object?> get props => [totalOrders, totalRevenue];
}

class MerchantStatisticsEntity extends Equatable {
  final int id;
  final int userId;
  final String? name;
  final String type;
  final MerchantStatsLocation location;
  final MerchantStatsValues stats;

  const MerchantStatisticsEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.location,
    required this.stats,
  });

  @override
  List<Object?> get props => [id, userId, name, type, location, stats];
}

class MerchantStatisticsPagination extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const MerchantStatisticsPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  const MerchantStatisticsPagination.empty()
      : total = 0,
        page = 1,
        limit = 10,
        totalPages = 0,
        hasNextPage = false,
        hasPreviousPage = false;

  @override
  List<Object?> get props => [
        total,
        page,
        limit,
        totalPages,
        hasNextPage,
        hasPreviousPage,
      ];
}

class MerchantStatisticsPageEntity extends Equatable {
  final List<MerchantStatisticsEntity> items;
  final MerchantStatisticsPagination pagination;

  const MerchantStatisticsPageEntity({
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [items, pagination];
}
