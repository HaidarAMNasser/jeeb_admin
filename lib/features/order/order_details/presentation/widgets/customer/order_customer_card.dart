import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_customer_entity.dart';

class OrderCustomerCard extends StatelessWidget {
  final OrderCustomerEntity customer;

  const OrderCustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.defaultWhite,
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: ColorManager.primary, size: AppSize.s20),
                SizedBox(width: AppWidth.s12),
                CustomText(
                  text: AppTranslation.customer,
                  textStyle: getBoldStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.productNameColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s12),
            if (customer.displayName.isNotEmpty)
              _row('Name', customer.displayName),
            if (customer.email != null && customer.email!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row(AppTranslation.email, customer.email!),
            ],
            if (customer.phone != null && customer.phone!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row(AppTranslation.phone, customer.phone!),
            ],
            if (customer.address != null && customer.address!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row(AppTranslation.address, customer.address!),
            ],
            if (customer.role != null && customer.role!.isNotEmpty) ...[
              SizedBox(height: AppHeight.s8),
              _row('Role', customer.role!),
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
          width: 100,
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
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
