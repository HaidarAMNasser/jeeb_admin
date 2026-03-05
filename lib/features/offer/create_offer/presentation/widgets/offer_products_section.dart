import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_dropdown_widget.dart';

class OfferProductsSection extends StatelessWidget {
  final List<ProductEntity> selectedProducts;
  final void Function(ProductEntity?) onSelectProduct;
  final void Function(ProductEntity) onRemoveProduct;

  const OfferProductsSection({
    super.key,
    required this.selectedProducts,
    required this.onSelectProduct,
    required this.onRemoveProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProductDropdownWidget(
          selectedProduct: null,
          onSelectProduct: onSelectProduct,
        ),
        if (selectedProducts.isNotEmpty) ...[
          SizedBox(height: AppHeight.s12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedProducts.map((p) {
              return Chip(
                label: CustomText(
                  text: p.name,
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s14,
                    color: ColorManager.productNameColor,
                  ),
                ),
                onDeleted: () => onRemoveProduct(p),
                backgroundColor: ColorManager.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
