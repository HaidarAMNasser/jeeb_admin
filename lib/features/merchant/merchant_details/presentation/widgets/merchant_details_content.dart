import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/core/presentation/widgets/expandable_detail_rows.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/domain/entities/merchant_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/widgets/merchant_offers_section.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/widgets/merchant_products_section.dart';

class MerchantDetailsContent extends StatelessWidget {
  final MerchantEntity merchant;
  final String merchantId;
  final ScrollController? scrollController;

  const MerchantDetailsContent({
    super.key,
    required this.merchant,
    required this.merchantId,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: ColorManager.defaultWhite,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r16),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (merchant.image != null)
                        SizedBox(
                          width: AppWidth.s100,
                          height: AppHeight.s100,
                          child: CustomCachedNetworkImage(
                            imageUrl: merchant.image!,
                            fit: BoxFit.cover,
                            width: AppWidth.s100,
                            height: AppHeight.s100,
                            borderRadius: BorderRadius.circular(AppRadius.r100),
                            errorWidget: Container(
                              color: ColorManager.background,
                              child: Icon(
                                Icons.store,
                                color: ColorManager.primary,
                                size: AppSize.s40,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: AppWidth.s100,
                          height: AppHeight.s100,
                          decoration: BoxDecoration(
                            color: ColorManager.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.store,
                            color: ColorManager.primary,
                            size: AppSize.s40,
                          ),
                        ),
                      SizedBox(width: AppWidth.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: merchant.restaurantName.trim().isNotEmpty
                                  ? merchant.restaurantName.trim()
                                  : merchant.name,
                              textStyle: getBoldStyle(
                                fontSize: AppFontSize.s20,
                                color: ColorManager.productNameColor,
                              ),
                            ),
                            if (merchant.restaurantName.trim().isNotEmpty) ...[
                              SizedBox(height: AppHeight.s4),
                              CustomText(
                                text:
                                    '${AppTranslation.owner}: ${merchant.name}',
                                textStyle: getRegularStyle(
                                  fontSize: AppFontSize.s14,
                                  color: ColorManager.descriptionColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s20),
                  Divider(
                    height: 1,
                    color: ColorManager.background,
                  ),
                  SizedBox(height: AppHeight.s16),
                  ExpandableDetailRows(
                    rows: _buildDetailRows(),
                    collapsedCount: 3,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppHeight.s24),
          MerchantProductsSection(merchantId: merchantId),
          SizedBox(height: AppHeight.s24),
          MerchantOffersSection(merchantId: merchantId),
        ],
      ),
    );
  }

  List<Widget> _buildDetailRows() {
    final widgets = <Widget>[];

    void add(Widget w) {
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(height: AppHeight.s12));
      }
      widgets.add(w);
    }

    String? t(String? s) {
      final v = s?.trim();
      if (v == null || v.isEmpty) return null;
      return v;
    }

    final headerTitle = merchant.restaurantName.trim().isNotEmpty
        ? merchant.restaurantName.trim()
        : merchant.name;

    add(
      _buildInfoRow(
        Icons.email_outlined,
        AppTranslation.email,
        merchant.email,
      ),
    );

    add(
      _buildInfoRow(
        Icons.badge_outlined,
        AppTranslation.merchantUserId,
        merchant.id,
      ),
    );

    final fn = t(merchant.firstName);
    if (fn != null) {
      add(
        _buildInfoRow(
          Icons.person_outline_rounded,
          AppTranslation.firstName,
          fn,
        ),
      );
    }

    final ln = t(merchant.lastName);
    if (ln != null) {
      add(
        _buildInfoRow(
          Icons.person_outline_rounded,
          AppTranslation.lastName,
          ln,
        ),
      );
    }

    final phone = t(merchant.phoneNumber);
    if (phone != null) {
      add(
        _buildInfoRow(
          Icons.phone,
          AppTranslation.phone,
          phone,
          subtitle: merchant.hidePhoneNumber == true
              ? AppTranslation.merchantPhoneHiddenLabel
              : null,
        ),
      );
    }

    final rName = t(merchant.restaurantName);
    if (rName != null && rName != headerTitle) {
      add(
        _buildInfoRow(
          Icons.storefront_outlined,
          AppTranslation.restaurantName,
          rName,
        ),
      );
    }

    final addr = t(merchant.address);
    if (addr != null) {
      add(
        _buildInfoRow(
          Icons.home_outlined,
          AppTranslation.address,
          addr,
        ),
      );
    }

    final loc = _locationLine();
    if (loc != null) {
      add(
        _buildInfoRow(
          Icons.location_on_outlined,
          AppTranslation.location,
          loc,
        ),
      );
    }

    final role = t(merchant.role);
    if (role != null) {
      add(
        _buildInfoRow(
          Icons.manage_accounts_outlined,
          AppTranslation.merchantRole,
          role,
        ),
      );
    }

    final channel = t(merchant.notificationChannel);
    if (channel != null) {
      add(
        _buildInfoRow(
          Icons.notifications_outlined,
          AppTranslation.notificationChannel,
          channel,
        ),
      );
    }

    final birthday = t(merchant.birthday);
    if (birthday != null) {
      add(
        _buildInfoRow(
          Icons.cake_outlined,
          AppTranslation.merchantBirthday,
          birthday,
        ),
      );
    }

    if (merchant.isOnline != null) {
      add(
        _buildInfoRow(
          Icons.wifi_tethering,
          AppTranslation.merchantOnlineStatus,
          merchant.isOnline!
              ? AppTranslation.merchantOnlineYes
              : AppTranslation.merchantOnlineNo,
        ),
      );
    }

    if (merchant.isActive != null) {
      add(
        _buildInfoRow(
          Icons.power_settings_new_outlined,
          AppTranslation.merchantIsActiveLabel,
          merchant.isActive!
              ? AppTranslation.merchantOnlineYes
              : AppTranslation.merchantOnlineNo,
        ),
      );
    }

    if (phone == null && merchant.hidePhoneNumber != null) {
      add(
        _buildInfoRow(
          Icons.visibility_outlined,
          AppTranslation.merchantPhoneHiddenLabel,
          merchant.hidePhoneNumber!
              ? AppTranslation.merchantValueYes
              : AppTranslation.merchantValueNo,
        ),
      );
    }

    final verified = t(merchant.verifiedAt);
    if (verified != null) {
      add(
        _buildInfoRow(
          Icons.verified_outlined,
          AppTranslation.merchantVerifiedAt,
          verified,
        ),
      );
    }

    final created = t(merchant.createdAt);
    if (created != null) {
      add(
        _buildInfoRow(
          Icons.event_available_outlined,
          AppTranslation.merchantCreatedAt,
          created,
        ),
      );
    }

    final updated = t(merchant.updatedAt);
    if (updated != null) {
      add(
        _buildInfoRow(
          Icons.update_outlined,
          AppTranslation.merchantUpdatedAt,
          updated,
        ),
      );
    }

    return widgets;
  }

  String? _locationLine() {
    final city = merchant.cityName?.trim();
    final country = merchant.countryName?.trim();
    if ((city == null || city.isEmpty) &&
        (country == null || country.isEmpty)) {
      return null;
    }
    if (city != null &&
        city.isNotEmpty &&
        country != null &&
        country.isNotEmpty) {
      return '$city, $country';
    }
    return city?.isNotEmpty == true ? city : country;
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppSize.s20,
          color: ColorManager.descriptionColor,
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s12,
                  color: ColorManager.descriptionColor,
                ),
              ),
              SizedBox(height: AppHeight.s4),
              CustomText(
                text: value,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.productNameColor,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                SizedBox(height: AppHeight.s4),
                CustomText(
                  text: subtitle,
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s12,
                    color: ColorManager.descriptionColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
