import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/widgets/products/product_details_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsSection extends StatelessWidget {
  final List<OfferPriceDetailEntity>? products;

  const ProductDetailsSection({this.products});

  @override
  Widget build(BuildContext context) {
    if (products == null || products!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: CustomText(
            text: TranslationsController.instance.getTranslations().products,
            textStyle: getBoldStyle(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products!.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSize.s10.h),
            itemBuilder: (context, index) {
              return ProductDetailsWidget(productEntity: products![index]);
            },
          ),
        ),
      ],
    );
  }
}
