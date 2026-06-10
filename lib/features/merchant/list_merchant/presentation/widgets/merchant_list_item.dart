import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/domain/entities/merchant_entity.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_header.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_location_section.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_owner_row.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_phone_badge.dart';
import 'package:jeeb_admin/features/merchant/presentation/widgets/merchant_list_options_dialog.dart';

class MerchantListItem extends StatelessWidget {
  final MerchantEntity merchant;
  final VoidCallback? onConfirmMerchant;

  const MerchantListItem({
    super.key,
    required this.merchant,
    this.onConfirmMerchant,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhone =
        merchant.phoneNumber != null && merchant.phoneNumber!.isNotEmpty;
    final isPending = merchant.isActive == false;

    void goToDetails() {
      AppRouter.navigateTo(
        context,
        Routes.merchantDetails,
        arguments: {'merchantId': merchant.id},
      );
    }

    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: goToDetails,
        borderRadius: BorderRadius.circular(AppRadius.r16),
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
                        end: MerchantListItemPhoneBadge.reserveEndPadding(
                          hasPhone || isPending,
                        ),
                      ),
                      child: MerchantListItemHeader(merchant: merchant),
                    ),
                  ),
                  if (hasPhone)
                    PositionedDirectional(
                      top: 0,
                      end: isPending ? AppWidth.s35 : 0,
                      child: MerchantListItemPhoneBadge(
                        phoneNumber: merchant.phoneNumber!,
                      ),
                    ),
                  if (isPending && onConfirmMerchant != null)
                    PositionedDirectional(
                      top: -AppPadding.p4,
                      end: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: ColorManager.primary,
                          size: AppSize.s22,
                        ),
                        onPressed: () {
                          MerchantListOptionsDialog.show(
                            context: context,
                            onConfirm: onConfirmMerchant!,
                          );
                        },
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
              MerchantListItemLocationSection(
                cityName: merchant.cityName,
                countryName: merchant.countryName,
                address: merchant.address,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
