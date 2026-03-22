import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_item_image_carousel.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_item_info.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_item_actions.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;
  final bool enableSmallDesign;
  final bool showConfirmProduct;

  const ProductListItem({
    super.key,
    required this.product,
    this.enableSmallDesign = false,
    this.showConfirmProduct = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppRouter.navigateTo(
          context,
          Routes.productDetails,
          arguments: {'productId': product.id, 'tabIndexOnBack': 0},
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductItemImageCarousel( 
            key: ValueKey('${product.id}_${product.images.length}'),
            images: product.images,
            enableSmallDesign: enableSmallDesign,
          ),
          Container(
            margin: EdgeInsets.only(bottom: AppMargin.m16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: ColorManager.defaultWhite,

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r16),
                bottomRight: Radius.circular(AppRadius.r16),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductItemInfo(
                    enableSmallDesign: enableSmallDesign,
                    product: product,
                  ),
                  ProductItemActions(
                    enableSmallDesign: enableSmallDesign,
                    productId: product.id,
                    price: product.price,
                    showConfirmProduct: showConfirmProduct,
                    stockQuantity: product.stockQuantity,
                    hasStock: product.hasStock,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
