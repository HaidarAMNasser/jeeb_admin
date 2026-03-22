import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/icon_value_row.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/domain/entities/merchant_entity.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_header.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_owner_row.dart';

class MerchantListItem extends StatelessWidget {
  final MerchantEntity merchant;

  const MerchantListItem({super.key, required this.merchant});

  static String _cityCountryLine(String? cityName, String? countryName) {
    if (cityName != null && countryName != null) {
      return '$cityName • $countryName';
    }
    if (cityName != null) return cityName;
    return countryName!;
  }

  /// Space so the restaurant line does not run under the phone chip.
  static double _phoneReserveEndPadding(bool hasPhone) =>
      hasPhone ? 104.w : 0;

  @override
  Widget build(BuildContext context) {
    final hasPhone =
        merchant.phoneNumber != null && merchant.phoneNumber!.isNotEmpty;

    return InkWell(
      onTap: () {
        AppRouter.navigateTo(
          context,
          Routes.merchantDetails,
          arguments: {'merchantId': merchant.id},
        );
      },
      child: Card(
        color: ColorManager.defaultWhite,
        margin: EdgeInsets.only(bottom: AppMargin.m16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: _phoneReserveEndPadding(hasPhone),
                      ),
                      child: MerchantListItemHeader(merchant: merchant),
                    ),
                  ),
                  if (hasPhone)
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: SizedBox(
                        width: 96.w,
                        child: IconValueRow(
                          icon: Icons.phone,
                          value: merchant.phoneNumber!,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppHeight.s12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MerchantListItemOwnerRow(ownerName: merchant.name),
                    SizedBox(height: AppHeight.s8),
                    CustomText(
                      text: merchant.email,
                      textStyle: getRegularStyle(
                        fontSize: AppFontSize.s12,
                        color: ColorManager.descriptionColor,
                      ),
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (merchant.address != null &&
                  merchant.address!.trim().isNotEmpty) ...[
                SizedBox(height: AppHeight.s8),
                IconValueRow(
                  icon: Icons.location_on_outlined,
                  value: merchant.address!.trim(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
              if (merchant.cityName != null ||
                  merchant.countryName != null) ...[
                SizedBox(height: AppHeight.s12),
                IconValueRow(
                  icon: Icons.location_city,
                  value: _cityCountryLine(
                    merchant.cityName,
                    merchant.countryName,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
