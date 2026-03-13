import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_item_image_carousel.dart';

class ProductDetailsContent extends StatelessWidget {
  final ProductEntity product;
  final bool isAdmin;
  final VoidCallback onEdit;

  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.isAdmin,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final priceStr = (product.price / 100).toStringAsFixed(2);
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductItemImageCarousel(images: product.images),
          SizedBox(height: AppHeight.s16),
          CustomText(
            text: product.name,
            textStyle: getBoldStyle(
              fontSize: 24,
              color: ColorManager.defaultWhite,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: priceStr,
            textStyle: getBoldStyle(
              fontSize: 20,
              color: ColorManager.primary,
            ),
          ),
          SizedBox(height: AppHeight.s16),
          if (product.description != null)
            CustomText(
              text: product.description!,
              textStyle: getRegularStyle(color: ColorManager.textColor),
            ),
          if (product.servesCount != null) ...[
            SizedBox(height: AppHeight.s16),
            CustomText(
              text: '${AppTranslation.productServesCount}: ${product.servesCount}',
              textStyle: getRegularStyle(color: ColorManager.descriptionColor),
            ),
          ],
          if (product.hasStock == true && product.stockQuantity != null) ...[
            SizedBox(height: AppHeight.s16),
            CustomText(
              text: '${AppTranslation.productQuantity}: ${product.stockQuantity}',
              textStyle: getRegularStyle(color: ColorManager.descriptionColor),
            ),
          ],
          SizedBox(height: AppHeight.s24),
          if (!isAdmin)
            CustomButton(
              text: AppTranslation.editProduct,
              onPressed: onEdit,
              color: ColorManager.primary,
            ),
        ],
      ),
    );
  }
}
