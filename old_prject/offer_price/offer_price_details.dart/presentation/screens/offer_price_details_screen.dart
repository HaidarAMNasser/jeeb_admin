import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/blocs/offer_price_details_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/widgets/offer_price_details_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/widgets/products/product_details_section.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_details/presentation/widgets/payment_method_preview_widget.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/app_bar_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_data_state.dart';
import 'package:fatoorahapp/widgets/ui_states/not_found_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// تفاصيل عرض السعر
class OfferPriceDetailsScreen extends StatefulWidget {
  final OfferPriceDataEntity offerPriceDataEntity;
  const OfferPriceDetailsScreen({
    super.key,
    required this.offerPriceDataEntity,
  });

  @override
  State<OfferPriceDetailsScreen> createState() =>
      _OfferPriceDetailsScreenState();
}

class _OfferPriceDetailsScreenState extends State<OfferPriceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OfferPriceDetailsBloc>().add(
      GetOfferPriceDetailsEvent(offerPriceId: widget.offerPriceDataEntity.uuid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferPriceDetailsBloc, OfferPriceDetailsState>(
      builder: (context, state) {
        if (state is OfferPriceDetailsSuccess) {
          return BlocConsumer<DeleteOfferPriceBloc, DeleteOfferPriceState>(
            listener: (context, state) {
              if (state is DeleteOfferPriceSuccessState) {
                customToast(
                  msg: TranslationsController.instance
                      .getTranslations()
                      .operationSuccessful,
                );
                context.pushNamed(Routes.offerPriceRoute);
              } else if (state is DeleteOfferPriceErrorState) {
                customToast(msg: state.message);
              }
            },
            builder: (context, deleteOfferPriceState) {
              return ModalProgressHUD(
                progressIndicator: CustomCircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
                inAsyncCall:
                    deleteOfferPriceState is DeleteOfferPriceLoadingState,
                child: Scaffold(
                  backgroundColor: ColorManager.scaffoldColor,
                  appBar: CustomAppBar(
                    title:
                        '# ${state.offerPriceDetails.identificationNumber} ${TranslationsController.instance.getTranslations().quotationDetails}',
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OfferPriceDetailsWidget(
                            offerPriceEntity: widget.offerPriceDataEntity,
                            showIcon: true,
                            offerPriceDataEntity: state.offerPriceDetails,
                          ),
                          ProductDetailsSection(
                            products: state.offerPriceDetails.offerPriceDetails,
                          ),
                          verticalSpace(height: 16.h),
                          if (state.offerPriceDetails.payments.isNotEmpty)
                            CustomText(
                              text: TranslationsController.instance
                                  .getTranslations()
                                  .paymentMethods,
                              textStyle: getBoldStyle(),
                            ),
                            verticalSpace(height: 16.h),

                          ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                PaymentMethodPreviewWidget(
                                  method:
                                      state.offerPriceDetails.payments[index],
                                  index: index,
                                ),
                            separatorBuilder: (context, index) =>
                                verticalSpace(height: 16.h),
                            itemCount: state.offerPriceDetails.payments.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is OfferPriceDetailsLoading) {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: const CustomCircularProgressIndicator(),
          );
        } else if (state is OfferPriceDetailsNotFoundState) {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: NotFoundState(
              onPressed: () {
                context.read<OfferPriceDetailsBloc>().add(
                  GetOfferPriceDetailsEvent(
                    offerPriceId: widget.offerPriceDataEntity.uuid,
                  ),
                );
              },
            ),
          );
        } else if (state is OfferPriceDetailsNoInternetState) {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: NoInternetState(
              onPressed: () {
                context.read<OfferPriceDetailsBloc>().add(
                  GetOfferPriceDetailsEvent(
                    offerPriceId: widget.offerPriceDataEntity.uuid,
                  ),
                );
              },
            ),
          );
        } else if (state is OfferPriceDetailsNoDataState) {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: NoDataState(
              onPressed: () {
                context.read<OfferPriceDetailsBloc>().add(
                  GetOfferPriceDetailsEvent(
                    offerPriceId: widget.offerPriceDataEntity.uuid,
                  ),
                );
              },
            ),
          );
        } else if (state is OfferPriceDetailsError) {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: ErrorState(
              onPressed: () {
                context.read<OfferPriceDetailsBloc>().add(
                  GetOfferPriceDetailsEvent(
                    offerPriceId: widget.offerPriceDataEntity.uuid,
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: ColorManager.scaffoldColor,
            body: const CustomCircularProgressIndicator(),
          );
        }
      },
    );
  }
}
