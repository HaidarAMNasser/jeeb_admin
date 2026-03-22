import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/icon_value_row.dart';

class MerchantListItemLocationSection extends StatelessWidget {
  final String? cityName;
  final String? countryName;
  final String? address;

  const MerchantListItemLocationSection({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.address,
  });

  static String _cityCountryLine(String? cityName, String? countryName) {
    if (cityName != null && countryName != null) {
      return '$cityName • $countryName';
    }
    if (cityName != null) return cityName;
    return countryName!;
  }

  @override
  Widget build(BuildContext context) {
    final hasCityCountry = cityName != null || countryName != null;
    final hasAddress = address != null && address!.trim().isNotEmpty;
    if (!hasCityCountry && !hasAddress) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppHeight.s12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasCityCountry)
              Expanded(
                child: IconValueRow(
                  icon: Icons.location_city,
                  value: _cityCountryLine(cityName, countryName),
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            if (hasCityCountry && hasAddress) SizedBox(width: AppWidth.s8),
            if (hasAddress)
              Expanded(
                child: IconValueRow(
                  icon: Icons.location_on_outlined,
                  value: address!.trim(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
