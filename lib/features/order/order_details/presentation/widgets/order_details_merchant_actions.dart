import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/order_list_item_title.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

/// Bottom merchant actions on order details — mirrors the listing card actions.
class OrderDetailsMerchantActions extends StatelessWidget {
  const OrderDetailsMerchantActions({
    super.key,
    required this.order,
    required this.isConfirming,
    required this.isKitchenLoading,
    this.onConfirm,
    this.onCancel,
    this.onPreparing,
    this.onReadyForPickup,
  });

  final OrderEntity order;
  final bool isConfirming;
  final bool isKitchenLoading;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onPreparing;
  final VoidCallback? onReadyForPickup;

  bool get _showConfirm =>
      order.statusEnum == OrderStatus.pending && onConfirm != null;

  bool get _showCancel =>
      order.statusEnum == OrderStatus.pending && onCancel != null;

  bool get _showPreparing =>
      (order.statusEnum == OrderStatus.searching ||
          order.statusEnum == OrderStatus.assigned) &&
      onPreparing != null;

  bool get _showReady =>
      order.statusEnum == OrderStatus.preparing && onReadyForPickup != null;

  @override
  Widget build(BuildContext context) {
    if (!_showConfirm && !_showCancel && !_showPreparing && !_showReady) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16,
        AppPadding.p12,
        AppPadding.p16,
        AppPadding.p16,
      ),
      decoration: BoxDecoration(
        color: ColorManager.background,
        border: Border(
          top: BorderSide(color: ColorManager.borderColor.withValues(alpha: 0.6)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showConfirm)
              OrderListItemMerchantAction(
                label: AppTranslation.confirmOrderAction,
                isLoading: isConfirming,
                onPressed: onConfirm,
              ),
            if (_showCancel) ...[
              if (_showConfirm) SizedBox(height: AppHeight.s8),
              OrderListItemMerchantAction(
                label: AppTranslation.cancelOrder,
                isLoading: false,
                onPressed: onCancel,
              ),
            ],
            if (_showPreparing)
              OrderListItemMerchantAction(
                label: AppTranslation.merchantSetPreparing,
                isLoading: isKitchenLoading,
                onPressed: onPreparing,
              ),
            if (_showReady)
              OrderListItemMerchantAction(
                label: AppTranslation.merchantSetReadyPickup,
                isLoading: isKitchenLoading,
                onPressed: onReadyForPickup,
              ),
          ],
        ),
      ),
    );
  }
}
