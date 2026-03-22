import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class ProductItemActions extends StatelessWidget {
  final String productId;
  final bool enableSmallDesign;
  final int price;
  final bool showConfirmProduct;
  final int? stockQuantity;
  final bool? hasStock;

  const ProductItemActions({
    super.key,
    required this.productId,
    this.enableSmallDesign = false,
    required this.price,
    this.showConfirmProduct = false,
    this.stockQuantity,
    this.hasStock,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (!enableSmallDesign)
              Expanded(
                child: CustomText(
                  text: '\$${(price / 100).toStringAsFixed(2)}',
                  textStyle: getBoldStyle(
                    fontSize: AppFontSize.s20,
                    color: ColorManager.primary,
                  ),
                ),
              ),
          ],
        ),
        if (stockQuantity != null && hasStock == true) ...[
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: '${AppTranslation.productQuantity}: $stockQuantity',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.descriptionColor,
            ),
          ),
        ],
      ],
    );
  }
}

  // Future<void> _onConfirmProduct(BuildContext context) async {
  //   final currentPrice = (price / 100).toStringAsFixed(2);

  //   final result = await CustomInputDialog.show(
  //     context: context,
  //     title: AppTranslation.confirmProduct,
  //     label: AppTranslation.newPrice,
  //     hintText: AppTranslation.enterNewPrice,
  //     initialValue: currentPrice,
  //     keyboardType:
  //         const TextInputType.numberWithOptions(decimal: true, signed: false),
  //     validator: (value) {
  //       if (value == null || value.trim().isEmpty) {
  //         return AppTranslation.pleaseEnterProductPrice;
  //       }
  //       final parsed = double.tryParse(value.replaceAll(',', ''));
  //       if (parsed == null || parsed <= 0) {
  //         return AppTranslation.invalidProductPrice;
  //       }
  //       return null;
  //     },
  //   );

  //   if (result == null || result.isEmpty) return;

  //   final newPrice = double.parse(result.replaceAll(',', ''));

  //   context.read<ConfirmProductBloc>().add(
  //         ConfirmProductSubmitted(
  //           productId: productId,
  //           newPrice: newPrice,
  //         ),
  //       );
  // }