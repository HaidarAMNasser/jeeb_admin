import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/order_list_item_title.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    super.key,
    required this.order,
    this.showMerchantConfirm = false,
    this.isConfirming = false,
    this.onConfirm,
    this.showMerchantKitchen = false,
    this.kitchenActionLoadingOrderId,
    this.onMerchantPreparing,
    this.onMerchantReadyForPickup,
    this.useAdminPaymentLabels = false,
    this.showAdminPaidMenu = false,
    this.onAdminOpenPaidDetails,
  });

  final OrderEntity order;
  final bool showMerchantConfirm;
  final bool isConfirming;
  final VoidCallback? onConfirm;

  final bool showMerchantKitchen;
  final String? kitchenActionLoadingOrderId;
  final VoidCallback? onMerchantPreparing;
  final VoidCallback? onMerchantReadyForPickup;

  final bool useAdminPaymentLabels;
  final bool showAdminPaidMenu;
  final void Function(OrderEntity order)? onAdminOpenPaidDetails;

  bool get _showConfirmBar =>
      showMerchantConfirm &&
      order.statusEnum == OrderStatus.pending &&
      onConfirm != null;

  bool get _showKitchenPreparing =>
      showMerchantKitchen &&
      (order.statusEnum == OrderStatus.searching ||
          order.statusEnum == OrderStatus.assigned) &&
      onMerchantPreparing != null;

  bool get _showKitchenReady =>
      showMerchantKitchen &&
      order.statusEnum == OrderStatus.preparing &&
      onMerchantReadyForPickup != null;

  bool get _showKitchenBar => _showKitchenPreparing || _showKitchenReady;

  @override
  Widget build(BuildContext context) {
    final kitchenLoading =
        kitchenActionLoadingOrderId != null &&
            kitchenActionLoadingOrderId == order.id;

    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _openOrderListItem(context, order),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.r16),
              bottom: Radius.circular(
                (_showConfirmBar || _showKitchenBar) ? 0 : AppRadius.r16,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p16),
              child: OrderListItemTitle(
                order: order,
                useAdminPaymentLabels: useAdminPaymentLabels,
                showAdminPaidMenu:
                    showAdminPaidMenu && order.statusEnum == OrderStatus.paid,
                onAdminOpenPaidDetails: onAdminOpenPaidDetails != null
                    ? () => onAdminOpenPaidDetails!(order)
                    : null,
              ),
            ),
          ),
          if (_showConfirmBar)
            OrderListItemMerchantAction(
              label: AppTranslation.confirmOrderAction,
              isLoading: isConfirming,
              onPressed: onConfirm,
            ),
          if (_showKitchenPreparing)
            OrderListItemMerchantAction(
              label: AppTranslation.merchantSetPreparing,
              isLoading: kitchenLoading,
              onPressed: onMerchantPreparing,
            ),
          if (_showKitchenReady)
            OrderListItemMerchantAction(
              label: AppTranslation.merchantSetReadyPickup,
              isLoading: kitchenLoading,
              onPressed: onMerchantReadyForPickup,
            ),
        ],
      ),
    );
  }
}

void _openOrderListItem(BuildContext context, OrderEntity order) {
  Navigator.of(context)
      .pushNamed(
        Routes.orderDetails,
        arguments: {'orderId': order.id},
      )
      .then((result) {
        if (!context.mounted) return;
        if (result == true) {
          context.read<ListOrderBloc>().add(const GetOrdersEvent());
        }
      });
}
