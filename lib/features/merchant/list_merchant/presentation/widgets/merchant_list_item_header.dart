import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/domain/entities/merchant_entity.dart';

/// Avatar + restaurant name. Name uses a capped fixed width (max [maxRestaurantNameWidth]).
class MerchantListItemHeader extends StatelessWidget {
  final MerchantEntity merchant;

  /// Max width for the restaurant name column (responsive).
  static double get maxRestaurantNameWidth => 200.w;

  const MerchantListItemHeader({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final raw = constraints.maxWidth - AppWidth.s50 - AppWidth.s12;
        final nameW = raw.clamp(0.0, maxRestaurantNameWidth);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (merchant.image != null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.r100)),
                child: SizedBox(
                  width: AppWidth.s50,
                  height: AppHeight.s50,
                  child: CustomCachedNetworkImage(
                    imageUrl: merchant.image!,
                    fit: BoxFit.cover,
                    width: AppWidth.s50,
                    height: AppHeight.s50,
                    borderRadius: BorderRadius.circular(AppRadius.r100),
                    errorWidget: Container(
                      color: ColorManager.background,
                      child: Icon(
                        Icons.store,
                        color: ColorManager.primary,
                        size: AppSize.s28,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: AppWidth.s50,
                height: AppHeight.s50,
                decoration: BoxDecoration(
                  color: ColorManager.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.store,
                  color: ColorManager.primary,
                  size: AppSize.s28,
                ),
              ),
            SizedBox(width: AppWidth.s12),
            SizedBox(
              width: nameW,
              child: CustomText(
                text: merchant.restaurantName,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.productNameColor,
                ),
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
