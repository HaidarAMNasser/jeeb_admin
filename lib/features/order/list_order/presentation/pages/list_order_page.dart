import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/realtime/order_status_rtdb_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/domain/merchant_orders_tab.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/admin_confirm_paid_order_sheet.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/list_order_content.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant/merchant_order_list_rtdb_listener.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant/merchant_orders_tab_bar.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant_confirm_order/merchant_confirm_order_dialog.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant_confirm_order/merchant_post_confirm_education_dialog.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant/merchant_searching_preparing_sheet.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({super.key, this.isMerchant = false});

  final bool isMerchant;

  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.isMerchant) {
      _tabController = TabController(length: 3, vsync: this);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent * 0.9) return;

    final state = context.read<ListOrderBloc>().state;
    if (state is! ListOrderLoaded) return;
    if (!state.hasMore || state.isLoadingMore) return;

    context.read<ListOrderBloc>().add(
          GetOrdersEvent(
            loadMore: true,
            search: state.search,
            merchantId: state.merchantId,
            merchantTab: state.merchantTab,
            statusFilter: state.statusFilter,
          ),
        );
  }

  Future<void> _onConfirmOrder(OrderEntity order) async {
    final result = await showMerchantConfirmOrderDialog(context);
    if (!mounted || result == null) return;

    context.read<ListOrderBloc>().add(
          ConfirmOrderEvent(
            orderId: order.id,
            mealPreparationMinutes: result.mealPreparationMinutes,
          ),
        );
  }

  void _onMerchantPreparing(OrderEntity order) {
    if (order.statusEnum == OrderStatus.searching) {
      showMerchantSearchingPreparingSheet(context);
      return;
    }
    if (order.statusEnum == OrderStatus.assigned) {
      context.read<ListOrderBloc>().add(MerchantSetPreparingEvent(order.id));
    }
  }

  void _onMerchantReadyForPickup(OrderEntity order) {
    context.read<ListOrderBloc>().add(MerchantSetReadyForPickupEvent(order.id));
  }

  Widget _ordersBody(String? currentSearch) {
    return BlocStateHandler<ListOrderBloc, ListOrderState>(
      bloc: context.read<ListOrderBloc>(),
      isLoading: (s) => s is ListOrderLoading,
      isError: (s) => s is ListOrderError,
      getErrorMessage: (s) => (s as ListOrderError).message,
      isSuccess: (s) => s is ListOrderLoaded,
      isEmpty: (s) =>
          s is ListOrderLoaded && s.orders.isEmpty && !s.isLoadingMore,
      emptyMessage: AppTranslation.noOrdersFound,
      getRetryCallback: (s) => () {
        final loaded = s is ListOrderLoaded ? s : null;
        context.read<ListOrderBloc>().add(
              GetOrdersEvent(
                search: currentSearch,
                merchantId: loaded?.merchantId,
                merchantTab: loaded?.merchantTab,
                statusFilter: loaded?.statusFilter,
              ),
            );
      },
      getEmptyRetryCallback: (s) => () {
        final loaded = s is ListOrderLoaded ? s : null;
        context.read<ListOrderBloc>().add(
              GetOrdersEvent(
                merchantId: loaded?.merchantId,
                merchantTab: loaded?.merchantTab,
                statusFilter: loaded?.statusFilter,
                search: loaded?.search,
              ),
            );
      },
      successBuilder: (context, orderState) {
        final s = orderState as ListOrderLoaded;
        return ListOrderContent(
          orders: s.orders,
          isLoadingMore: s.isLoadingMore,
          scrollController: _scrollController,
          showSearchTrailingRefetch: widget.isMerchant,
          showInlineFilterSlot: !widget.isMerchant,
          onRefresh: () => context.read<ListOrderBloc>().add(
                GetOrdersEvent(
                  search: currentSearch,
                  merchantId: s.merchantId,
                  merchantTab: s.merchantTab,
                  statusFilter: s.statusFilter,
                ),
              ),
          currentSearch: currentSearch,
          merchantId: s.merchantId,
          confirmingOrderId: s.confirmingOrderId,
          showMerchantConfirm: widget.isMerchant &&
              s.merchantTab == MerchantOrdersTab.pending,
          onConfirmOrder: _onConfirmOrder,
          showMerchantKitchen: widget.isMerchant,
          kitchenActionLoadingOrderId: s.kitchenActionLoadingOrderId,
          onMerchantPreparing: widget.isMerchant ? _onMerchantPreparing : null,
          onMerchantReadyForPickup:
              widget.isMerchant ? _onMerchantReadyForPickup : null,
          useAdminPaymentLabels: !widget.isMerchant,
          showAdminPaidMenu: !widget.isMerchant,
          onAdminOpenPaidDetails: widget.isMerchant
              ? null
              : (order) => showAdminConfirmPaidOrderSheet(context, order),
        );
      },
    );
  }

  Widget _wrapAdminConfirmPaidHud({required Widget child}) {
    if (widget.isMerchant) return child;
    return BlocListener<ConfirmPaidOrderBloc, ConfirmPaidOrderState>(
      listenWhen: (prev, curr) =>
          (curr is ConfirmPaidOrderSuccess || curr is ConfirmPaidOrderError) &&
          prev is ConfirmPaidOrderLoading,
      listener: (context, state) {
        if (state is ConfirmPaidOrderSuccess) {
          customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
          final listState = context.read<ListOrderBloc>().state;
          if (listState is ListOrderLoaded) {
            context.read<ListOrderBloc>().add(
                  GetOrdersEvent(
                    search: listState.search,
                    merchantId: listState.merchantId,
                    merchantTab: listState.merchantTab,
                    statusFilter: listState.statusFilter,
                  ),
                );
          } else {
            context.read<ListOrderBloc>().add(const GetOrdersEvent());
          }
        } else if (state is ConfirmPaidOrderError) {
          customToast(msg: state.message);
        }
      },
      child: BlocBuilder<ConfirmPaidOrderBloc, ConfirmPaidOrderState>(
        builder: (context, confirmState) {
          return ModalProgressHUD(
            progressIndicator: const CustomCircleIndicator(),
            inAsyncCall: confirmState is ConfirmPaidOrderLoading,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListOrderBloc, ListOrderState>(
      listenWhen: (prev, curr) {
        if (!widget.isMerchant) return false;
        final p =
            prev is ListOrderLoaded ? prev.merchantEducationPendingOrderId : null;
        final c = curr is ListOrderLoaded
            ? curr.merchantEducationPendingOrderId
            : null;
        return c != null && c != p;
      },
      listener: (context, state) async {
        if (state is! ListOrderLoaded) return;
        final id = state.merchantEducationPendingOrderId;
        if (id == null) return;
        final hide =
            await di.sl<StorageService>().getMerchantHidePostConfirmEducation();
        if (!context.mounted) return;
        if (hide) {
          context.read<ListOrderBloc>().add(
                const ClearMerchantEducationDialogEvent(),
              );
          return;
        }
        await showMerchantPostConfirmEducationDialog(context);
        if (!context.mounted) return;
        context.read<ListOrderBloc>().add(
              const ClearMerchantEducationDialogEvent(),
            );
      },
      child: _wrapAdminConfirmPaidHud(
        child: Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(title: AppTranslation.orders),
          body: BlocBuilder<ListOrderBloc, ListOrderState>(
            builder: (context, state) {
              final currentSearch =
                  state is ListOrderLoaded ? state.search : null;
              final body = _ordersBody(currentSearch);

              if (!widget.isMerchant) {
                return body;
              }

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MerchantOrdersTabBar(controller: _tabController!),
                      Expanded(child: body),
                    ],
                  ),
                  if (state is ListOrderLoaded)
                    MerchantOrderListRtdbListener(
                      orderIds: state.orders.map((e) => e.id).toList(),
                      rtdb: di.sl<OrderStatusRtdbService>(),
                      onRemoteStatusChange: () {
                        if (!context.mounted) return;
                        final s = context.read<ListOrderBloc>().state;
                        if (s is! ListOrderLoaded) return;
                        context.read<ListOrderBloc>().add(
                              GetOrdersEvent(
                                search: s.search,
                                merchantId: s.merchantId,
                                merchantTab: s.merchantTab,
                                statusFilter: s.statusFilter,
                              ),
                            );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
