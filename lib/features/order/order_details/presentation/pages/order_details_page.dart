import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/bloc/order_details_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_details_content.dart';
import 'package:jeeb_admin/features/order/order_complete/presentation/bloc/order_complete_bloc.dart';
import 'package:jeeb_admin/features/order/order_cancel/presentation/bloc/order_cancel_bloc.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCompleteBloc, OrderCompleteState>(
      listener: (context, completeState) {
        if (completeState is OrderCompleteSuccess) {
          customToast(msg: AppTranslation.orderCompletedSuccessfully);
        } else if (completeState is OrderCompleteError) {
          customToast(msg: completeState.message);
        }
      },
      builder: (context, completeState) {
        return BlocConsumer<OrderCancelBloc, OrderCancelState>(
          listener: (context, cancelState) {
            if (cancelState is OrderCancelSuccess) {
              customToast(msg: AppTranslation.orderCancelledSuccessfully);
            } else if (cancelState is OrderCancelError) {
              customToast(msg: cancelState.message);
            }
          },
          builder: (context, cancelState) {
            final isLoading =
                completeState is OrderCompleteLoading ||
                cancelState is OrderCancelLoading;

            return ModalProgressHUD(
              progressIndicator: const CustomCircleIndicator(),
              inAsyncCall: isLoading,
              child: Scaffold(
                backgroundColor: ColorManager.background,
                appBar: CustomAppBar(
                  title: AppTranslation.orderDetails,

                  actions: [
                    BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
                      builder: (context, detailsState) {
                        if (detailsState is! OrderDetailsLoaded) {
                          return const SizedBox.shrink();
                        }
                        final order = detailsState.order;
                        if (!order.statusEnum.canCompleteOrCancel) {
                          return const SizedBox.shrink();
                        }
                        return FutureBuilder<String?>(
                          future: di.sl<StorageService>().getUserRole(),
                          builder: (context, snapshot) {
                            final userRole = snapshot.data;
                            if (userRole?.toLowerCase() != UserRole.merchant.name) {
                              return const SizedBox.shrink();
                            }
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      _showCompleteConfirmation(context),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () =>
                                      _showCancelConfirmation(context),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                body: BlocStateHandler<OrderDetailsBloc, OrderDetailsState>(
                  bloc: context.read<OrderDetailsBloc>(),
                  isLoading: (state) => state is OrderDetailsLoading,
                  isError: (state) => state is OrderDetailsError,
                  getErrorMessage: (state) =>
                      (state as OrderDetailsError).message,
                  getRetryCallback: (state) => () {
                    context.read<OrderDetailsBloc>().add(
                          GetOrderDetailsEvent(widget.orderId),
                        );
                  },
                  successBuilder: (context, detailsState) {
                    final loadedState = detailsState as OrderDetailsLoaded;
                    return OrderDetailsContent(order: loadedState.order);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCompleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: AppTranslation.areYouSureCompleteOrder,
        onConfirm: () {
          Navigator.of(context).pop();
          context.read<OrderCompleteBloc>().add(
            CompleteOrderEvent(widget.orderId),
          );
        },
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: AppTranslation.areYouSureCancelOrder,
        onConfirm: () {
          Navigator.of(context).pop();
          context.read<OrderCancelBloc>().add(CancelOrderEvent(widget.orderId));
        },
      ),
    );
  }
}
