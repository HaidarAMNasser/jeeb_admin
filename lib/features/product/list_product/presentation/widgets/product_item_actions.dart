import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_input_dialog.dart';
import 'package:jeeb_admin/features/product/confirm_product/presentation/bloc/confirm_product_bloc.dart';

class ProductItemActions extends StatelessWidget {
  final String productId;
  final int price;
  final bool showConfirmProduct;
  final int? stockQuantity;
  final bool? hasStock;

  const ProductItemActions({
    super.key,
    required this.productId,
    required this.price,
    this.showConfirmProduct = false,
    this.stockQuantity,
    this.hasStock,
  });

  Future<void> _onConfirmProduct(BuildContext context) async {
    final currentPrice = (price / 100).toStringAsFixed(2);

    final result = await CustomInputDialog.show(
      context: context,
      title: AppTranslation.confirmProduct,
      label: AppTranslation.newPrice,
      hintText: AppTranslation.enterNewPrice,
      initialValue: currentPrice,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppTranslation.pleaseEnterProductPrice;
        }
        final parsed = double.tryParse(value.replaceAll(',', ''));
        if (parsed == null || parsed <= 0) {
          return AppTranslation.invalidProductPrice;
        }
        return null;
      },
    );

    if (result == null || result.isEmpty) return;

    final newPrice = double.parse(result.replaceAll(',', ''));

    context.read<ConfirmProductBloc>().add(
          ConfirmProductSubmitted(
            productId: productId,
            newPrice: newPrice,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                text: '\$${(price / 100).toStringAsFixed(2)}',
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s20,
                  color: ColorManager.primary,
                ),
              ),
            ),
            if (showConfirmProduct) ...[
              SizedBox(width: AppWidth.s8),
              OutlinedButton.icon(
                onPressed: () => _onConfirmProduct(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ColorManager.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p12,
                    vertical: AppHeight.s8,
                  ),
                ),
                icon: Icon(
                  Icons.check_circle_outline,
                  size: AppSize.s16,
                  color: ColorManager.primary,
                ),
                label: CustomText(
                  text: AppTranslation.confirmProduct,
                  textStyle: getSemiBoldStyle(
                    fontSize: AppFontSize.s12,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (stockQuantity != null && hasStock == true) ...[
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: '${AppTranslation.productQuantity}: $stockQuantity',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s12,
              color: ColorManager.descriptionColor,
            ),
          ),
        ],
      ],
    );
  }
}
