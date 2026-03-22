import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart'
    show AppHeight, AppPadding, AppRadius, AppWidth;
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_dropdown_widget.dart';

class OfferProductsSection extends StatelessWidget {
  final List<ProductEntity> selectedProducts;
  final void Function(ProductEntity?) onSelectProduct;
  final void Function(ProductEntity) onRemoveProduct;
  final void Function(ProductEntity product, int quantity) onQuantityChanged;

  const OfferProductsSection({
    super.key,
    required this.selectedProducts,
    required this.onSelectProduct,
    required this.onRemoveProduct,
    required this.onQuantityChanged,
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
          ...selectedProducts.map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s8),
              child: _OfferProductLine(
                product: p,
                onRemove: () => onRemoveProduct(p),
                onQuantityChanged: (q) => onQuantityChanged(p, q),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OfferProductLine extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _OfferProductLine({
    required this.product,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  State<_OfferProductLine> createState() => _OfferProductLineState();
}

class _OfferProductLineState extends State<_OfferProductLine> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: '${widget.product.offerQuantity ?? 1}',
    );
  }

  @override
  void didUpdateWidget(_OfferProductLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldQ = oldWidget.product.offerQuantity ?? 1;
    final newQ = widget.product.offerQuantity ?? 1;
    if (oldQ != newQ && _quantityController.text != '$newQ') {
      _quantityController.text = '$newQ';
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _emitQuantity() {
    final q = int.tryParse(_quantityController.text.trim());
    widget.onQuantityChanged(q != null && q >= 1 ? q : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p10,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: ColorManager.primary.withOpacity(0.35)),
            ),
            child: CustomText(
              text: widget.product.name,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s14,
                color: ColorManager.textColor,
              ),
            ),
          ),
        ),
        SizedBox(width: AppWidth.s8),
        SizedBox(
          width: AppWidth.s75,
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: getMediumStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.defaultWhite,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppPadding.p8,
                vertical: AppPadding.p10,
              ),
              hintText: AppTranslation.offerQuantityHint,
              hintStyle: getRegularStyle(
                fontSize: AppFontSize.s12,
                color: ColorManager.descriptionColor,
              ),
              filled: true,
              fillColor: ColorManager.primary.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.4)),
              ),
            ),
            onChanged: (_) => _emitQuantity(),
            onEditingComplete: _emitQuantity,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          color: ColorManager.primary,
          onPressed: widget.onRemove,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ],
    );
  }
}
