import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_discount_type_entity.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';

class OfferDiscountSection extends StatelessWidget {
  final CreateOfferState state;
  final TextEditingController discountValueController;
  final void Function(String) onDiscountTypeChanged;
  final void Function(String) onDiscountValueChanged;

  const OfferDiscountSection({
    super.key,
    required this.state,
    required this.discountValueController,
    required this.onDiscountTypeChanged,
    required this.onDiscountValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isPercentage =
        (OfferDiscountTypeEntity.fromCode(state.discountType)?.id ?? 0) == 0;
    final hintText = isPercentage ? '0-100' : '0';

    return Column(
      spacing: AppSize.s10.h,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          text: AppTranslation.offerDiscountType,
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s15,
            color: ColorManager.defaultWhite,
          ),
        ),
        DropdownButtonFormField<OfferDiscountTypeEntity>(
          value:
              OfferDiscountTypeEntity.fromCode(state.discountType) ??
              OfferDiscountTypeEntity.percentage,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorManager.defaultWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.borderColor),
            ),
          ),
          items: OfferDiscountTypeEntity.values
              .map(
                (type) => DropdownMenuItem<OfferDiscountTypeEntity>(
                  value: type,
                  child: CustomText(
                    text: type.id == 0
                        ? AppTranslation.offerDiscountPercentage
                        : AppTranslation.offerDiscountValueType,
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.productNameColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onDiscountTypeChanged(v.code);
          },
        ),
        CustomTextField(
          keyboardType: TextInputType.number,
          title: AppTranslation.offerDiscountValue,
          hintText: hintText,
          controller: discountValueController,
          onChanged: onDiscountValueChanged,
        ),
      ],
    );
  }
}
