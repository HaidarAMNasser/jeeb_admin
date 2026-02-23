import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/extensions/permission_context_extension.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/enums/permission_enum.dart';
import 'package:fatoorahapp/feature/authentication/profile/presentation/blocs/profile_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/widgets/offer_price_details_title_widget.dart';
import 'package:fatoorahapp/feature/sales_invoices/extract_pdf/presentation/widgets/pdf_extraction_service.dart';
import 'package:fatoorahapp/feature/shif_indicators/presentation/widgets/number_of_invoices_widget.dart';
import 'package:fatoorahapp/widgets/dialogs/confirmation_dialog.dart';
import 'package:fatoorahapp/widgets/divider_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_images_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/more_options_widget.dart';
import 'package:fatoorahapp/widgets/single_more_item_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/text_colored_container_widget.dart';

class OfferPriceDetailsWidget extends StatelessWidget {
  final bool showIcon;
  final OfferPriceDataEntity offerPriceEntity;

  final OfferPriceSingleEntity? offerPriceDataEntity;
  const OfferPriceDetailsWidget({
    super.key,
    required this.showIcon,
    this.offerPriceDataEntity,
    required this.offerPriceEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showIcon) ...[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          height: 36.w,
                          width: 36.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorManager.green50,
                            shape: BoxShape.circle,
                          ),
                          child: CustomSvgAssetImage(image: IconAssets.receipt),
                        ),
                        SizedBox(width: 20.w),
                        TextInColoredContainerWidget(
                          text:
                              offerPriceEntity.isConverted.toString() == "true"
                              ? TranslationsController.instance
                                    .getTranslations()
                                    .invoiced
                              : offerPriceEntity.isConverted.toString() ==
                                    "false"
                              ? TranslationsController.instance
                                    .getTranslations()
                                    .notInvoiced
                              : TranslationsController.instance
                                    .getTranslations()
                                    .notInvoiced,
                          color:
                              offerPriceEntity.isConverted.toString() == "true"
                              ? ColorManager.lightRed2
                              : ColorManager.lightYellow,
                          textColor:
                              offerPriceEntity.isConverted.toString() == "true"
                              ? ColorManager.red2
                              : ColorManager.orange,
                        ),
                        Spacer(),
                        Builder(
                          builder: (innerContextForAction) {
                            return moreOptionsWidget(
                              context: innerContextForAction,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (offerPriceDataEntity?.isConverted
                                              .toString() !=
                                          "true" &&
                                      context.hasPermission(
                                        PermissionName.offerprice_show,
                                      )) ...[
                                    SingleMoreItemWidget(
                                      context: context,
                                      title: TranslationsController.instance
                                          .getTranslations()
                                          .print,
                                      icon: IconAssets.printer,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        context.pushNamed(
                                          Routes.printOfferPriceRoute,
                                          arguments: {
                                            "uuid": offerPriceDataEntity?.uuid,
                                          },
                                        );
                                      },
                                    ),
                                    const CustomDivider(),
                                  ],
                                  if (offerPriceDataEntity?.isConverted
                                              .toString() !=
                                          "true" &&
                                      context.hasPermission(
                                        PermissionName.offerprice_edit,
                                      )) ...[
                                    SingleMoreItemWidget(
                                      context: context,
                                      title: TranslationsController.instance
                                          .getTranslations()
                                          .edit,
                                      icon: IconAssets.edit,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        context.pushNamed(
                                          Routes.createOfferPriceRoute,
                                          arguments: {
                                            "fromEdit": true,
                                            "offerPriceEntity":
                                                this.offerPriceEntity,
                                          },
                                        );
                                      },
                                    ),
                                  ],

                                  if (offerPriceDataEntity?.isConverted
                                              .toString() !=
                                          "true" &&
                                      context.hasPermission(
                                        PermissionName.offerprice_updateStatus,
                                      )) ...[
                                    const CustomDivider(),
                                    SingleMoreItemWidget(
                                      context: context,
                                      title: TranslationsController.instance
                                          .getTranslations()
                                          .convertToInvoice,
                                      // TranslationsController.instance
                                      //     .getTranslations()
                                      //     .convertToInvoiceTitle,
                                      icon: IconAssets.addIcon,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        context.pushNamed(
                                          Routes.offerPriceToInvoiceScreen,
                                          arguments: {
                                            "offerPriceDataEntity":
                                                offerPriceEntity,
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  const CustomDivider(),
                                  profileState is ProfileLoadingState
                                      ? Container(
                                          height: 40,
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: CustomText(
                                                  text: TranslationsController
                                                      .instance
                                                      .getTranslations()
                                                      .extractPdf,
                                                  textStyle: getMediumStyle(
                                                    color: ColorManager
                                                        .optionColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SingleMoreItemWidget(
                                          context: context,
                                          title: TranslationsController.instance
                                              .getTranslations()
                                              .extractPdf,
                                          icon: IconAssets.addFloating,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _handlePdfExtraction(
                                              context,
                                              profileState,
                                            );
                                          },
                                        ),
                                  if (offerPriceDataEntity?.isConverted
                                          .toString() !=
                                      "true") ...[
                                    const CustomDivider(),
                                    SingleMoreItemWidget(
                                      context: context,
                                      title: TranslationsController.instance
                                          .getTranslations()
                                          .delete,
                                      icon: IconAssets.delete,
                                      onTap: () {
                                        Navigator.of(context).pop();

                                        showDeleteConfirmationDialog(
                                          context: context,
                                          title: TranslationsController.instance
                                              .getTranslations()
                                              .areYouSureToDelete,
                                          message: TranslationsController
                                              .instance
                                              .getTranslations()
                                              .cannotUndoIfYes,
                                          onConfirm: () {
                                            BlocProvider.of<
                                                  DeleteOfferPriceBloc
                                                >(context)
                                                .add(
                                                  DeleteOfferPriceSubmitted(
                                                    id:
                                                        offerPriceDataEntity
                                                            ?.uuid ??
                                                        '',
                                                  ),
                                                );
                                          },
                                        );
                                        // Navigator.of(context).pop();
                                        // BlocProvider.of<DeleteOfferPriceBloc>(
                                        //   context,
                                        // ).add(
                                        //   DeleteOfferPriceSubmitted(
                                        //     id:
                                        //         offerPriceDataEntity?.uuid ??
                                        //         '',
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                              onPreviewTap: () {},
                            );
                          },
                        ),
                      ],
                    ),
                    verticalSpace(height: 12.h),
                  ],
                  OfferPriceDetailsTitleWidget(
                    context: context,
                    showOptions: false,
                    offerPriceDataEntity: this.offerPriceDataEntity!,
                    title: this.offerPriceDataEntity!.user.name,
                    id: this.offerPriceDataEntity!.user.identificationNumber
                        .toString(),
                  ),
                  verticalSpace(height: 12.h),
                  Row(
                    children: [
                      TextInColoredContainerWidget(
                        text:
                            "${TranslationsController.instance.getTranslations().invoiceNumber} ${this.offerPriceDataEntity!.id.toString()}",
                        color: ColorManager.green50,
                      ),
                      horizontalSpace(width: 8.w),
                      TextInColoredContainerWidget(
                        text: this.offerPriceDataEntity!.date.replaceAll(
                          "-",
                          "/",
                        ),
                        color: ColorManager.green50,
                      ),
                    ],
                  ),
                  verticalSpace(height: 12.h),
                  NumberOfInvoicesTextWidget(
                    numberColor: ColorManager.hintColor,
                    numberFontSize: AppFontSize.s14,
                    fontWeight: FontWeight.w700,
                    title: TranslationsController.instance
                        .getTranslations()
                        .expirationDate,
                    number: this.offerPriceDataEntity!.expirationDate
                        .toString(),
                    hasDot: false,
                    titleFontSize: 12.sp,
                  ),
                  verticalSpace(height: 8.h),
                  NumberOfInvoicesTextWidget(
                    numberFontSize: AppFontSize.s14,
                    fontWeight: FontWeight.w700,
                    title: "قيمة عرض السعر",
                    number: this.offerPriceDataEntity!.totalPrice.toString(),
                    hasDot: false,
                    titleFontSize: 12.sp,
                  ),
                  if (this.offerPriceDataEntity!.payments
                          .map((e) => e.method.name)
                          .join(' - ') !=
                      "") ...[
                    verticalSpace(height: 8.h),
                    NumberOfInvoicesTextWidget(
                      title: TranslationsController.instance
                          .getTranslations()
                          .paymentType,
                      number: this.offerPriceDataEntity!.payments
                          .map((e) => e.method.name)
                          .join(' - '),
                      hasDot: false,
                      titleFontSize: 12.sp,
                      numberFontSize: 12.sp,
                      numberColor: ColorManager.textColor,
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePdfExtraction(BuildContext context, ProfileState profileState) {
    if (profileState is ProfileSuccessState) {
      print("aaa");
      // Profile is loaded successfully, proceed with PDF extraction
      PdfExtractionService.extractInvoicePdf(
        myInfo: profileState.profileEntity,
        context: context,
        invoiceId: offerPriceDataEntity?.uuid ?? '',
        invoiceNumber: offerPriceDataEntity?.identificationNumber ?? '',
        isReturn: false, // Offer prices are never returns
        invoiceType: 'priceOffer',
        fromOfferPrice: true, // This is the key parameter
      );
    } else if (profileState is ProfileErrorState) {
      // Profile is in error state, retry fetching profile
      context.read<ProfileBloc>().add(
        const ProfileSubmitted(withLoading: true),
      );
    } else if (profileState is ProfileInitialState) {
      // Profile hasn't been loaded yet, fetch it
      context.read<ProfileBloc>().add(
        const ProfileSubmitted(withLoading: true),
      );
    }
  }
}
