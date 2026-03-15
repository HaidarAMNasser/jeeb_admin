import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';

class ProductItemInfo extends StatelessWidget {
  final ProductEntity product;
  final bool enableSmallDesign;
  const ProductItemInfo({
    super.key,
    required this.product,
    this.enableSmallDesign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enableSmallDesign
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: product.name,
                    textStyle: getBoldStyle(
                      fontSize: AppFontSize.s18,
                      color: ColorManager.productNameColor,
                    ),
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  CustomText(
                    text: '\$${(product.price / 100).toStringAsFixed(2)}',
                    textStyle: getBoldStyle(
                      fontSize: AppFontSize.s20,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              )
            : CustomText(
                text: product.name,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.productNameColor,
                ),
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
        if (product.description != null) ...[
          SizedBox(height: AppHeight.s4),
          CustomText(
            text: product.description!,
            textStyle: getRegularStyle(),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
