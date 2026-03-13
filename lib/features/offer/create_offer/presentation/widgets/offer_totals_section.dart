import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';

/// Shows sum of selected product prices (total before discount) and total after discount.
class OfferTotalsSection extends StatelessWidget {
  final List<ProductEntity> selectedProducts;
  final CreateOfferState state;

  const OfferTotalsSection({
    super.key,
    required this.selectedProducts,
    required this.state,
  });

  /// Price is stored in smallest unit (e.g. 13900 = 139.00). Factor 100.
  static const int _priceFactor = 100;

  int get _totalBeforeDiscount =>
      selectedProducts.fold<int>(0, (sum, p) => sum + p.price);

  int get _totalAfterDiscount {
    final before = _totalBeforeDiscount;
    if (before == 0) return 0;
    final value = num.tryParse(state.discountValue) ?? 0;
    if (state.discountType == 'PERCENTAGE') {
      return (before * (1 - value / 100)).round();
    }
    // FIXED: value from form may be in main unit (e.g. 20 for 20.00)
    final fixedValueInSmallest = (value * _priceFactor).round();
    return (before - fixedValueInSmallest).clamp(0, before);
  }

  String _formatPrice(int amountInSmallestUnit) =>
      (amountInSmallestUnit / _priceFactor).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final before = _totalBeforeDiscount;
    final after = _totalAfterDiscount;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.r18),
        border: Border.all(color: ColorManager.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppTranslation.offerTotalBeforeDiscount,
                textStyle: getMediumStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.defaultWhite,
                ),
              ),
              CustomText(
                text: _formatPrice(before),
                textStyle: getMediumStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.defaultWhite,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppTranslation.offerTotalAfterDiscount,
                textStyle: getMediumStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.defaultWhite,
                ),
              ),
              CustomText(
                text: _formatPrice(after),
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s15,
                  color: ColorManager.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
