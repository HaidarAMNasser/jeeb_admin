import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/bloc/order_details_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_details_content.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_details_merchant_actions.dart';
import 'package:jeeb_admin/features/order/order_cancel/presentation/bloc/order_cancel_bloc.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant_confirm_order/merchant_confirm_order_dialog.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant_confirm_order/merchant_post_confirm_education_dialog.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant/merchant_searching_preparing_sheet.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/order_status_rtdb_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_details_rtdb_listener.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  /// Pops until the orders list route is on top, or stops at the root route.
  void _popToOrdersListing({bool refreshList = false}) {
    if (!mounted) return;
    if (refreshList && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
      return;
    }
    Navigator.of(context).popUntil(
      (route) => route.settings.name == Routes.orders || route.isFirst,
    );
  }

  Future<void> _onMerchantConfirm() async {
    final result = await showMerchantConfirmOrderDialog(context);
    if (!mounted || result == null) return;

    context.read<OrderDetailsBloc>().add(
          ConfirmMerchantOrderEvent(
            mealPreparationMinutes: result.mealPreparationMinutes,
          ),
        );
  }

  void _onMerchantPreparing(OrderStatus status) {
    if (status == OrderStatus.searching) {
      showMerchantSearchingPreparingSheet(context);
      return;
    }
    if (status == OrderStatus.assigned) {
      context.read<OrderDetailsBloc>().add(const MerchantSetPreparingEvent());
    }
  }

  void _onMerchantReadyForPickup() {
    context
        .read<OrderDetailsBloc>()
        .add(const MerchantSetReadyForPickupEvent());
  }

  void _showCancelConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureCancelOrder,
      confirmText: AppTranslation.cancelOrder,
      confirmColor: ColorManager.primary,
      onConfirm: () {
        context.read<OrderCancelBloc>().add(CancelOrderEvent(widget.orderId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) _popToOrdersListing();
      },
      child: BlocListener<OrderDetailsBloc, OrderDetailsState>(
        listenWhen: (prev, curr) {
          final p =
              prev is OrderDetailsLoaded ? prev.merchantEducationPending : false;
          final c =
              curr is OrderDetailsLoaded ? curr.merchantEducationPending : false;
          return c && !p;
        },
        listener: (context, state) async {
          if (state is! OrderDetailsLoaded) return;
          if (!state.merchantEducationPending) return;

          final hide =
              await di.sl<StorageService>().getMerchantHidePostConfirmEducation();
          if (!context.mounted) return;
          if (hide) {
            context.read<OrderDetailsBloc>().add(
                  const ClearMerchantEducationDialogEvent(),
                );
            return;
          }
          await showMerchantPostConfirmEducationDialog(context);
          if (!context.mounted) return;
          context.read<OrderDetailsBloc>().add(
                const ClearMerchantEducationDialogEvent(),
              );
        },
        child: BlocListener<ConfirmPaidOrderBloc, ConfirmPaidOrderState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is ConfirmPaidOrderSuccess || s is ConfirmPaidOrderError,
          ),
          listener: (context, state) {
            if (state is ConfirmPaidOrderSuccess) {
              customToast(msg: AppTranslation.orderStatusUpdatedSuccess);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                _popToOrdersListing(refreshList: true);
              });
            } else if (state is ConfirmPaidOrderError) {
              customToast(msg: state.message);
            }
          },
          child: BlocConsumer<OrderCancelBloc, OrderCancelState>(
            listenWhen: (previous, current) => listenWhenEnteringTerminal(
              previous,
              current,
              (s) => s is OrderCancelSuccess || s is OrderCancelError,
            ),
            listener: (context, cancelState) async {
              if (cancelState is OrderCancelSuccess) {
                customToast(msg: AppTranslation.orderCancelledSuccessfully);
                final role =
                    (await di.sl<StorageService>().getUserRole())?.toLowerCase();
                if (!context.mounted) return;
                if (role == UserRole.merchant.name) {
                  _popToOrdersListing(refreshList: true);
                  return;
                }
                context.read<OrderDetailsBloc>().add(
                      GetOrderDetailsEvent(widget.orderId),
                    );
              } else if (cancelState is OrderCancelError) {
                customToast(msg: cancelState.message);
              }
            },
            builder: (context, cancelState) {
              return BlocBuilder<ConfirmPaidOrderBloc, ConfirmPaidOrderState>(
                builder: (context, confirmPaidState) {
                  return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
                    builder: (context, detailsState) {
                      final loaded = detailsState is OrderDetailsLoaded
                          ? detailsState
                          : null;
                      final isLoading = cancelState is OrderCancelLoading ||
                          confirmPaidState is ConfirmPaidOrderLoading ||
                          (loaded?.isConfirming ?? false) ||
                          (loaded?.isKitchenLoading ?? false);

                      return ModalProgressHUD(
                        progressIndicator: const CustomCircleIndicator(),
                        inAsyncCall: isLoading,
                        child: Scaffold(
                          backgroundColor: ColorManager.background,
                          appBar: CustomAppBar(
                            title: AppTranslation.orderDetails,
                            onBackPressed: _popToOrdersListing,
                            actions: [
                              if (loaded != null)
                                FutureBuilder<String?>(
                                  future: di.sl<StorageService>().getUserRole(),
                                  builder: (context, snapshot) {
                                    final userRole =
                                        snapshot.data?.toLowerCase();
                                    final isAdmin =
                                        userRole == UserRole.admin.name;

                                    if (isAdmin &&
                                        loaded.order.statusEnum.canAdminCancel) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: ColorManager.primary,
                                        ),
                                        tooltip: AppTranslation.cancelOrder,
                                        onPressed: () =>
                                            _showCancelConfirmation(context),
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                            ],
                          ),
                          body: FutureBuilder<String?>(
                            future: di.sl<StorageService>().getUserRole(),
                            builder: (context, roleSnapshot) {
                              final isMerchant =
                                  roleSnapshot.data?.toLowerCase() ==
                                      UserRole.merchant.name;

                              return Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        BlocStateHandler<OrderDetailsBloc,
                                            OrderDetailsState>(
                                          bloc: context.read<OrderDetailsBloc>(),
                                          isLoading: (state) =>
                                              state is OrderDetailsLoading,
                                          isError: (state) =>
                                              state is OrderDetailsError,
                                          isSuccess: (state) =>
                                              state is OrderDetailsLoaded,
                                          getErrorMessage: (state) =>
                                              (state as OrderDetailsError)
                                                  .message,
                                          getRetryCallback: (state) => () {
                                            context.read<OrderDetailsBloc>().add(
                                                  GetOrderDetailsEvent(
                                                      widget.orderId),
                                                );
                                          },
                                          successBuilder:
                                              (context, detailsState) {
                                            final loadedState =
                                                detailsState as OrderDetailsLoaded;
                                            return OrderDetailsContent(
                                              order: loadedState.order,
                                            );
                                          },
                                        ),
                                        OrderDetailsRtdbListener(
                                          orderId: widget.orderId,
                                          rtdb: di.sl<OrderStatusRtdbService>(),
                                          onRemoteStatusChange: () {
                                            if (!context.mounted) return;
                                            context.read<OrderDetailsBloc>().add(
                                                  GetOrderDetailsEvent(
                                                      widget.orderId),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isMerchant && loaded != null)
                                    OrderDetailsMerchantActions(
                                      order: loaded.order,
                                      isConfirming: loaded.isConfirming,
                                      isKitchenLoading: loaded.isKitchenLoading,
                                      onConfirm: loaded.order.statusEnum
                                              .canCompleteOrCancel
                                          ? _onMerchantConfirm
                                          : null,
                                      onCancel: loaded.order.statusEnum
                                              .canCompleteOrCancel
                                          ? () => _showCancelConfirmation(context)
                                          : null,
                                      onPreparing: (loaded.order.statusEnum ==
                                                  OrderStatus.searching ||
                                              loaded.order.statusEnum ==
                                                  OrderStatus.assigned)
                                          ? () => _onMerchantPreparing(
                                                loaded.order.statusEnum,
                                              )
                                          : null,
                                      onReadyForPickup:
                                          loaded.order.statusEnum ==
                                                  OrderStatus.preparing
                                              ? _onMerchantReadyForPickup
                                              : null,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
