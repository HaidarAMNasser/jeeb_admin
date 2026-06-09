import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/order_list_item.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/search_order_widget.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
      
class ListOrderContent extends StatelessWidget {
  final List<OrderEntity> orders;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final String? currentSearch;
  final String? merchantId;
  final String? confirmingOrderId;
  final bool showMerchantConfirm;
  final void Function(OrderEntity order) onConfirmOrder;

  /// Merchant: Preparing / Ready for pickup on in-progress orders.
  final bool showMerchantKitchen;
  final String? kitchenActionLoadingOrderId;
  final void Function(OrderEntity order)? onMerchantPreparing;
  final void Function(OrderEntity order)? onMerchantReadyForPickup;

  /// Merchant: orange restart beside search.
  final bool showSearchTrailingRefetch;

  /// Admin: filter/reset container beside search (same row).
  final bool showInlineFilterSlot;

  /// Admin orders list: delivery payment labels + paid-order actions.
  final bool useAdminPaymentLabels;
  final bool showAdminPaidMenu;
  final void Function(OrderEntity order)? onAdminOpenPaidDetails;

  const ListOrderContent({
    super.key,
    required this.orders,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
    this.currentSearch,
    this.merchantId,
    this.confirmingOrderId,
    this.showMerchantConfirm = false,
    this.showMerchantKitchen = false,
    this.kitchenActionLoadingOrderId,
    this.onMerchantPreparing,
    this.onMerchantReadyForPickup,
    this.showSearchTrailingRefetch = true,
    this.showInlineFilterSlot = false,
    this.useAdminPaymentLabels = false,
    this.showAdminPaidMenu = false,
    this.onAdminOpenPaidDetails,
    required this.onConfirmOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchOrderWidget(
          showTrailingRefetch: showSearchTrailingRefetch,
          showInlineFilterSlot: showInlineFilterSlot,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p16,
              ),
              itemCount: orders.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == orders.length) {
                  return Padding(
                    padding: EdgeInsets.all(AppPadding.p16),
                    child: const CustomCircleIndicator(),
                  );
                }
                final order = orders[index];
                return OrderListItem(
                  order: order,
                  showMerchantConfirm: showMerchantConfirm,
                  isConfirming: confirmingOrderId == order.id,
                  onConfirm: () => onConfirmOrder(order),
                  showMerchantKitchen: showMerchantKitchen,
                  kitchenActionLoadingOrderId: kitchenActionLoadingOrderId,
                  onMerchantPreparing: onMerchantPreparing != null
                      ? () => onMerchantPreparing!(order)
                      : null,
                  onMerchantReadyForPickup: onMerchantReadyForPickup != null
                      ? () => onMerchantReadyForPickup!(order)
                      : null,
                  useAdminPaymentLabels: useAdminPaymentLabels,
                  showAdminPaidMenu: showAdminPaidMenu,
                  onAdminOpenPaidDetails: onAdminOpenPaidDetails,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
