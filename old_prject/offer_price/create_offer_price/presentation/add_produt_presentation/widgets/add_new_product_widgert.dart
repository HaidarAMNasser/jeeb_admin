import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/add_product_bloc/add_product_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/widgets/add_product_sheet.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/payment/presentation/widgets/increase_and_decrease_button.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/taxs/presentation/blocs/tax_bloc.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/dialogs/dialogs_and_popups.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget addNewProductWidget(BuildContext context) {
  final exchangeBondsCreateBloc =
      BlocProvider.of<OfferPriceCreateBloc>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
          text: TranslationsController.instance.getTranslations().addProduct,
          textStyle: getBoldStyle()),
      verticalSpace(height: 8.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IncreaseAndDecreaseButtonWidget(
              icon: IconAssets.addIcon,
              containerColor: ColorManager.green50,
              iconColor: ColorManager.sendOtpColor,
              onTap: () {
                initTaxsDIModule();
                initTaxReasonBlocDIModule();
                initDiscountReasonBlocDIModule();
                DialogsAndPopUp.customBottomSheet(
                    context: context,
                    child: MultiBlocProvider(
                      child: AddProductSheet(),
                      providers: [
                        BlocProvider.value(
                          value: exchangeBondsCreateBloc,
                        ),
                        BlocProvider(
                          create: (dialogContext) => AddProductBloc(
                            null,
                            dialogContext.read<OfferPriceCreateBloc>(),
                            null,
                            null,
                            null,
                            null,
                          ),
                        ),
                        // Use global ProductsBloc instead of creating new one
                        BlocProvider.value(value: context.read<ProductsBloc>()),
                        BlocProvider(
                            create: (dialogContext) =>
                                inject<TaxesBloc>()..add(FetchTaxesEvent())),
                        BlocProvider(
                            create: (dialogContext) =>
                                inject<TaxReasonsBloc>()),
                        BlocProvider(
                            create: (dialogContext) =>
                                inject<DiscountReasonsBloc>()),
                      ],
                    ));
              },
            ),
            horizontalSpace(width: 8.w),
            CustomText(
              text:
                  TranslationsController.instance.getTranslations().addProduct,
              textStyle: getRegularStyle(),
            ),
          ],
        ),
      ),
    ],
  );
}
