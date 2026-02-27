import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
// import 'package:jeeb_admin/features/order/order_details/presentation/bloc/order_details_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_details_content.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_image_entity.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/order/order_complete/presentation/bloc/order_complete_bloc.dart';
import 'package:jeeb_admin/features/order/order_cancel/presentation/bloc/order_cancel_bloc.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  @override
  void initState() {
    super.initState();
    // Load order details
    // context.read<OrderDetailsBloc>().add(
    //       GetOrderDetailsEvent(widget.orderId),
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCompleteBloc, OrderCompleteState>(
        listener: (context, completeState) {
          if (completeState is OrderCompleteSuccess) {
            customToast(msg: AppTranslation.orderCompletedSuccessfully);
            // Refresh order details
            // context.read<OrderDetailsBloc>().add(
            //       GetOrderDetailsEvent(widget.orderId),
            //     );
          } else if (completeState is OrderCompleteError) {
            customToast(msg: completeState.message);
          }
        },
        builder: (context, completeState) {
          return BlocConsumer<OrderCancelBloc, OrderCancelState>(
            listener: (context, cancelState) {
              if (cancelState is OrderCancelSuccess) {
                customToast(msg: AppTranslation.orderCancelledSuccessfully);
                // Refresh order details
                // context.read<OrderDetailsBloc>().add(
                //       GetOrderDetailsEvent(widget.orderId),
                //     );
              } else if (cancelState is OrderCancelError) {
                customToast(msg: cancelState.message);
              }
            },
            builder: (context, cancelState) {
              final isLoading = completeState is OrderCompleteLoading ||
                  cancelState is OrderCancelLoading;

              return ModalProgressHUD(
                progressIndicator: const CustomCircleIndicator(),
                inAsyncCall: isLoading,
                child: Scaffold(
                  backgroundColor: ColorManager.background,
                  appBar: AppBar(
                    backgroundColor: ColorManager.background,
                    title: CustomText(
                      text: AppTranslation.orderDetails,
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s24,
                        color: ColorManager.titlesColor,
                      ),
                    ),
                    actions: [
                      // Show complete/cancel buttons only for merchants
                      FutureBuilder<String?>(
                        future: di.sl<StorageService>().getUserRole(),
                        builder: (context, snapshot) {
                          final userRole = snapshot.data;
                          if (userRole?.toLowerCase() == 'merchant') {
                            final fakeOrder = _generateFakeOrder();
                            // Only show buttons if order is not completed or cancelled
                            if (fakeOrder.status?.toLowerCase() != 'completed' &&
                                fakeOrder.status?.toLowerCase() != 'cancelled') {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      _showCompleteConfirmation(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showCancelConfirmation(context);
                                    },
                                  ),
                                ],
                              );
                            }
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  body: Builder(
                    builder: (context) {
                      // return BlocStateHandler<OrderDetailsBloc, OrderDetailsState>(
                      //   bloc: context.read<OrderDetailsBloc>(),
                      //   isLoading: (state) => state is OrderDetailsLoading,
                      //   isError: (state) => state is OrderDetailsError,
                      //   getErrorMessage: (state) => (state as OrderDetailsError).message,
                      //   getRetryCallback: (state) => () {
                      //     context.read<OrderDetailsBloc>().add(
                      //           GetOrderDetailsEvent(widget.orderId),
                      //         );
                      //   },
                      //   successBuilder: (context, detailsState) {
                      //     final loadedState = detailsState as OrderDetailsLoaded;
                      //     return OrderDetailsContent(order: loadedState.order);
                      //   },
                      // );

                      // Fake data for UI testing
                      final fakeOrder = _generateFakeOrder();
                      return OrderDetailsContent(order: fakeOrder);
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
          context.read<OrderCancelBloc>().add(
                CancelOrderEvent(widget.orderId),
              );
        },
      ),
    );
  }

  // Fake data generation for UI testing
  OrderEntity _generateFakeOrder() {
    return OrderEntity(
      id: widget.orderId,
      products: _generateFakeProducts(),
      deliveryMan: _generateFakeDeliveryMan(),
      date: DateTime.now().subtract(const Duration(hours: 2)),
      longitude: 35.5018,
      latitude: 33.8938,
      numberOfPeople: 3,
      status: 'pending',
      merchantId: 'merchant_1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );
  }

  List<ProductEntity> _generateFakeProducts() {
    return [
      ProductEntity(
        id: '1',
        name: 'Burger',
        description: 'Delicious burger with cheese',
        price: 1500,
        categoryId: 'cat1',
        categoryName: 'Fast Food',
        images: [
          ProductImageEntity(
            id: 1,
            url: 'https://picsum.photos/seed/product1/200/200',
            mobileUrl: 'https://picsum.photos/seed/product1/200/200',
            thumbnailUrl: 'https://picsum.photos/seed/product1/200/200',
            isMain: true,
            displayOrder: 1,
          ),
        ],
      ),
      ProductEntity(
        id: '2',
        name: 'Pizza',
        description: 'Margherita pizza',
        price: 2500,
        categoryId: 'cat1',
        categoryName: 'Fast Food',
        images: [
          ProductImageEntity(
            id: 2,
            url: 'https://picsum.photos/seed/product2/200/200',
            mobileUrl: 'https://picsum.photos/seed/product2/200/200',
            thumbnailUrl: 'https://picsum.photos/seed/product2/200/200',
            isMain: true,
            displayOrder: 1,
          ),
        ],
      ),
    ];
  }

  DeliveryManEntity _generateFakeDeliveryMan() {
    return DeliveryManEntity(
      id: '1',
      name: 'Ahmed Ali',
      phone: '+961 3 1234567',
      email: 'ahmed.ali@example.com',
      vehicleType: 'Motorcycle',
      status: 'active',
      image: 'https://picsum.photos/seed/delivery1/200/200',
    );
  }
}

