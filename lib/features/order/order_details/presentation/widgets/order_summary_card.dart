import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final hasAny = order.paymentMethod != null ||
        order.deliveryAddress != null ||
        order.priceBeforeDiscount != null ||
        order.discountAmount != null ||
        order.totalAmount != null ||
        order.deliveryFee != null ||
        order.platformCommission != null ||
        order.ownerRevenue != null ||
        order.tipAmount != null ||
        order.couponCode != null;
    if (!hasAny) return const SizedBox.shrink();

    return Card(
      color: ColorManager.defaultWhite,
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: ColorManager.primary, size: AppSize.s20),
                SizedBox(width: AppWidth.s12),
                CustomText(
                  text: AppTranslation.orderSummary,
                  textStyle: getBoldStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.productNameColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s12),
            if (order.paymentMethod != null && order.paymentMethod!.isNotEmpty)
              _row('Payment', order.paymentMethod!),
            if (order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row('Delivery address', order.deliveryAddress!),
            ],
            if (order.couponCode != null && order.couponCode!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row('Coupon', order.couponCode!),
            ],
            if (order.priceBeforeDiscount != null) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Subtotal', order.priceBeforeDiscount!, order.currencyCode),
            ],
            if (order.discountAmount != null && order.discountAmount! > 0) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Discount', -order.discountAmount!, order.currencyCode),
            ],
            if (order.deliveryFee != null && order.deliveryFee! > 0) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Delivery fee', order.deliveryFee!, order.currencyCode),
            ],
            if (order.tipAmount != null && order.tipAmount! > 0) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Tip', order.tipAmount!, order.currencyCode),
            ],
            if (order.platformCommission != null) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Platform commission', order.platformCommission!, order.currencyCode),
            ],
            if (order.ownerRevenue != null) ...[
              SizedBox(height: AppHeight.s8),
              _rowMoney('Owner revenue', order.ownerRevenue!, order.currencyCode),
            ],
            if (order.totalAmount != null) ...[
              SizedBox(height: AppHeight.s12),
              Divider(color: ColorManager.borderColor),
              SizedBox(height: AppHeight.s8),
              _rowMoney('Total', order.totalAmount!, order.currencyCode, bold: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: CustomText(
            text: '$label:',
            textStyle: getSemiBoldStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.descriptionColor,
            ),
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.productNameColor,
            ),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _rowMoney(String label, int amount, String? currencyCode, {bool bold = false}) {
    final currency = currencyCode ?? '';
    final value = currency.isNotEmpty ? '$amount $currency' : amount.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: '$label:',
          textStyle: (bold ? getBoldStyle : getSemiBoldStyle)(
            fontSize: AppFontSize.s14,
            color: ColorManager.descriptionColor,
          ),
        ),
        CustomText(
          text: value,
          textStyle: (bold ? getBoldStyle : getRegularStyle)(
            fontSize: AppFontSize.s14,
            color: ColorManager.productNameColor,
          ),
        ),
      ],
    );
  }
}
