import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/core/presentation/widgets/expandable_detail_rows.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';

class DeliveryDetailsContent extends StatelessWidget {
  final DeliveryManEntity deliveryMan;

  const DeliveryDetailsContent({
    super.key,
    required this.deliveryMan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Card(
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
                  _DeliveryAvatar(imageUrl: deliveryMan.image),
                  SizedBox(width: AppWidth.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: deliveryMan.name,
                          textStyle: getBoldStyle(
                            fontSize: AppFontSize.s20,
                            color: ColorManager.productNameColor,
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        Wrap(
                          spacing: AppWidth.s8,
                          runSpacing: AppHeight.s8,
                          children: [
                            _buildBadge(
                              label: (deliveryMan.isActive == true ||
                                      deliveryMan.confirmed)
                                  ? AppTranslation.confirmed
                                  : AppTranslation.notConfirmed,
                              backgroundColor:
                                  (deliveryMan.isActive == true ||
                                          deliveryMan.confirmed)
                                      ? ColorManager.success.withOpacity(0.12)
                                      : ColorManager.defaultYellow
                                          .withOpacity(0.18),
                              textColor: (deliveryMan.isActive == true ||
                                      deliveryMan.confirmed)
                                  ? ColorManager.success
                                  : ColorManager.defaultYellow,
                            ),
                            if (deliveryMan.isOnline != null)
                              _buildBadge(
                                label: deliveryMan.isOnline == true
                                    ? AppTranslation.online
                                    : AppTranslation.offline,
                                backgroundColor: deliveryMan.isOnline == true
                                    ? ColorManager.primary.withOpacity(0.1)
                                    : ColorManager.descriptionColor
                                        .withOpacity(0.2),
                                textColor: deliveryMan.isOnline == true
                                    ? ColorManager.primary
                                    : ColorManager.descriptionColor,
                              ),
                          ],
                        ),
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
    );
  }

  List<Widget> _buildDetailRows() {
    final widgets = <Widget>[];

    void add(Widget w) {
      widgets.add(w);
    }

    String? t(String? s) {
      final v = s?.trim();
      if (v == null || v.isEmpty) return null;
      return v;
    }

    add(
      _buildInfoRow(
        Icons.email_outlined,
        AppTranslation.email,
        deliveryMan.email,
      ),
    );

    add(
      _buildInfoRow(
        Icons.badge_outlined,
        AppTranslation.deliveryUserId,
        deliveryMan.id,
      ),
    );

    final fn = t(deliveryMan.firstName);
    if (fn != null) {
      add(
        _buildInfoRow(
          Icons.person_outline_rounded,
          AppTranslation.firstName,
          fn,
        ),
      );
    }

    final ln = t(deliveryMan.lastName);
    if (ln != null) {
      add(
        _buildInfoRow(
          Icons.person_outline_rounded,
          AppTranslation.lastName,
          ln,
        ),
      );
    }

    if (deliveryMan.phone.trim().isNotEmpty) {
      add(
        _buildInfoRow(
          Icons.phone,
          AppTranslation.phone,
          deliveryMan.phone.trim(),
        ),
      );
    }

    final addr = t(deliveryMan.address);
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

    final role = t(deliveryMan.role);
    if (role != null) {
      add(
        _buildInfoRow(
          Icons.manage_accounts_outlined,
          AppTranslation.merchantRole,
          role,
        ),
      );
    }

    final channel = t(deliveryMan.notificationChannel);
    if (channel != null) {
      add(
        _buildInfoRow(
          Icons.notifications_outlined,
          AppTranslation.notificationChannel,
          channel,
        ),
      );
    }

    final birthday = t(deliveryMan.birthday);
    if (birthday != null) {
      add(
        _buildInfoRow(
          Icons.cake_outlined,
          AppTranslation.merchantBirthday,
          birthday,
        ),
      );
    }

    if (deliveryMan.isOnline != null) {
      add(
        _buildInfoRow(
          Icons.wifi_tethering,
          AppTranslation.merchantOnlineStatus,
          deliveryMan.isOnline!
              ? AppTranslation.merchantOnlineYes
              : AppTranslation.merchantOnlineNo,
        ),
      );
    }

    add(
      _buildInfoRow(
        Icons.verified_user_outlined,
        AppTranslation.deliveryConfirmedStatus,
        deliveryMan.confirmed
            ? AppTranslation.merchantValueYes
            : AppTranslation.merchantValueNo,
      ),
    );

    if (deliveryMan.isActive != null) {
      add(
        _buildInfoRow(
          Icons.toggle_on_outlined,
          AppTranslation.deliveryAccountActive,
          deliveryMan.isActive!
              ? AppTranslation.merchantValueYes
              : AppTranslation.merchantValueNo,
        ),
      );
    }

    if (deliveryMan.countryId != null) {
      add(
        _buildInfoRow(
          Icons.flag_outlined,
          AppTranslation.deliveryCountryId,
          '${deliveryMan.countryId}',
        ),
      );
    }

    if (deliveryMan.cityId != null) {
      add(
        _buildInfoRow(
          Icons.location_city_outlined,
          AppTranslation.deliveryCityId,
          '${deliveryMan.cityId}',
        ),
      );
    }

    if (deliveryMan.officeOwnerId != null) {
      add(
        _buildInfoRow(
          Icons.business_outlined,
          AppTranslation.deliveryOfficeOwnerId,
          '${deliveryMan.officeOwnerId}',
        ),
      );
    }

    final verified = t(deliveryMan.verifiedAt);
    if (verified != null) {
      add(
        _buildInfoRow(
          Icons.verified_outlined,
          AppTranslation.merchantVerifiedAt,
          verified,
        ),
      );
    }

    final created = t(deliveryMan.createdAt);
    if (created != null) {
      add(
        _buildInfoRow(
          Icons.event_available_outlined,
          AppTranslation.merchantCreatedAt,
          created,
        ),
      );
    }

    final updated = t(deliveryMan.updatedAt);
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
    final city = deliveryMan.cityName?.trim();
    final country = deliveryMan.countryName?.trim();
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: CustomText(
        text: label,
        textStyle: getSemiBoldStyle(
          fontSize: AppFontSize.s10,
          color: textColor,
        ),
      ),
    );
  }
}

class _DeliveryAvatar extends StatelessWidget {
  final String? imageUrl;

  const _DeliveryAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return SizedBox(
        width: AppWidth.s100,
        height: AppHeight.s100,
        child: CustomCachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: AppWidth.s100,
          height: AppHeight.s100,
          borderRadius: BorderRadius.circular(AppRadius.r100),
          errorWidget: _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: AppWidth.s100,
      height: AppHeight.s100,
      decoration: BoxDecoration(
        color: ColorManager.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.delivery_dining,
        color: ColorManager.primary,
        size: AppSize.s40,
      ),
    );
  }
}
