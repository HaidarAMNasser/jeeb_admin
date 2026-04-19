import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_header_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_date_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_customer_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_location_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_people_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_delivery_man_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_products_section.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_items_section.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_summary_card.dart';
import 'package:jeeb_admin/features/order/order_details/presentation/widgets/order_paid_receipts_admin_section.dart';

class OrderDetailsContent extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsContent({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderHeaderCard(order: order),
          SizedBox(height: AppHeight.s16),

          if (order.date != null) ...[
            OrderDateCard(date: order.date!),
            SizedBox(height: AppHeight.s16),
          ],

          if (order.customer != null) ...[
            OrderCustomerCard(customer: order.customer!),
            SizedBox(height: AppHeight.s16),
          ],

          if (order.numberOfPeople != null) ...[
            OrderPeopleCard(numberOfPeople: order.numberOfPeople!),
            SizedBox(height: AppHeight.s16),
          ],

          if (order.orderItems.isNotEmpty)
            OrderItemsSection(
              items: order.orderItems,
              currencyCode: order.currencyCode,
            )
          else
            OrderProductsSection(products: order.products),
          SizedBox(height: AppHeight.s16),

          OrderSummaryCard(order: order),
          SizedBox(height: AppHeight.s16),

          OrderPaidReceiptsAdminSection(order: order),

          if (order.deliveryMan != null) ...[
            OrderDeliveryManCard(deliveryMan: order.deliveryMan!),
            SizedBox(height: AppHeight.s16),
          ],

          if (order.latitude != null && order.longitude != null) ...[
            OrderLocationCard(
              latitude: order.latitude!,
              longitude: order.longitude!,
            ),
          ],
        ],
      ),
    );
  }
}
