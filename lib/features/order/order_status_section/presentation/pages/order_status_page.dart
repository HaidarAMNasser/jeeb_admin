import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/live_tracking_map_card.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:jeeb_admin/features/order/order_status_section/presentation/bloc/order_status_bloc.dart';
// import 'package:jeeb_admin/features/order/order_status_section/presentation/widgets/order_status_hero_image.dart';

/// Live order tracking (Firebase RTDB + optional map).
class OrderStatusPage extends StatelessWidget {
  const OrderStatusPage({super.key});

  static const Color _bg = Color(0xFF3A3836);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          BlocBuilder<OrderStatusBloc, OrderStatusState>(
            builder: (context, state) {
              final dLat = state.deliveryLatitude;
              final dLng = state.deliveryLongitude;
              final drvLat = state.driverLatitude;
              final drvLng = state.driverLongitude;
              final hasTrail = state.routeHistoryPoints.isNotEmpty;
              final showLiveMap = state.routeStatus == OrderStatus.onTheWay &&
                  ((dLat != null && dLng != null) ||
                      (drvLat != null && drvLng != null) ||
                      hasTrail);

              return CustomScrollView(
                slivers: [
                  // SliverToBoxAdapter(
                  //   child: OrderStatusHeroImage(
                  //     timelineStepIndex: state.displayIndex,
                  //   ),
                  // ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (state.showProblemBanner) ...[
                          //   const OrderStatusProblemBanner(),
                          //   SizedBox(height: AppHeight.s16),
                          // ],
                          // OrderStatusHorizontalTimeline(
                          //   labels: OrderStatusStepLabels.asList(),
                          //   activeIndex: state.displayIndex,
                          //   routeStatus: state.routeStatus,
                          //   demoRunning: state.demoRunning,
                          // ),
                          if (showLiveMap) ...[
                            SizedBox(height: AppHeight.s16),
                            LiveTrackingMapCard(
                              orderId: state.orderId,
                              title: AppTranslation.orderDeliveryMapBadge,
                              routeHistory: state.routeHistoryPoints,
                              deliveryLatitude: dLat,
                              deliveryLongitude: dLng,
                              driverLatitude: drvLat,
                              driverLongitude: drvLng,
                              statusLabel:
                                  AppTranslation.orderStatusLabelOnTheWay,
                              statusOnline: state.driverOnline,
                            ),
                          ],
                          // SizedBox(height: AppHeight.s16),
                          // OrderBadgeWidget(
                          //   normalDesign: true,
                          //   enableSmallBadge: true,
                          //   caption: AppTranslation.orderStatusViewDetails,
                          //   accentColor: ColorManager.primary,
                          //   leadingAssetPath: ImageAsset.timelineStepImagePath(
                          //     state.displayIndex,
                          //   ),
                          //   icon: state.routeStatus.iconData,
                          //   onTap: () {
                          //     AppRouter.navigateTo(
                          //       context,
                          //       Routes.orderDetails,
                          //       arguments: {'orderId': state.orderId},
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
