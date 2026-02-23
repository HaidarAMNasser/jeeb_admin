import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/extensions/permission_context_extension.dart';
import 'package:fatoorahapp/core/helpful_funcations/smart_scrollable_text.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/enums/permission_enum.dart';
import 'package:fatoorahapp/feature/authentication/profile/presentation/blocs/profile_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/sales_invoices/extract_pdf/presentation/widgets/pdf_extraction_service.dart';
import 'package:fatoorahapp/widgets/dialogs/confirmation_dialog.dart';
import 'package:fatoorahapp/widgets/divider_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:fatoorahapp/widgets/text_colored_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/more_options_widget.dart';
import '../../../../../widgets/single_more_item_widget.dart';

class OfferPriceTitleWidget extends StatelessWidget {
  final String title;
  final String id;
  final bool showOptions;
  final OfferPriceDataEntity offerPriceDataEntity;

  const OfferPriceTitleWidget({
    super.key,
    required this.title,
    required this.id,
    required this.offerPriceDataEntity,
    required this.showOptions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return Row(
          children: [
            SmartScrollableText(
              child: CustomText(
                text: title,
                textStyle: getBoldStyle(fontSize: AppFontSize.s12),
              ),
            ),
            horizontalSpace(width: 8.w),
            CustomText(
              text: id,
              textStyle: getRegularStyle(fontSize: 12.sp),
            ),
            Spacer(),
            if (showOptions) ...[
              Spacer(),
              Row(
                children: [
                  TextInColoredContainerWidget(
                    text: offerPriceDataEntity.isConverted.toString() == "true"
                        ? TranslationsController.instance
                              .getTranslations()
                              .invoiced
                        : offerPriceDataEntity.isConverted.toString() == "false"
                        ? TranslationsController.instance
                              .getTranslations()
                              .notInvoiced
                        : TranslationsController.instance
                              .getTranslations()
                              .notInvoiced,
                    color: offerPriceDataEntity.isConverted.toString() == "true"
                        ? ColorManager.lightRed2
                        : ColorManager.lightYellow,
                    textColor:
                        offerPriceDataEntity.isConverted.toString() == "true"
                        ? ColorManager.red2
                        : ColorManager.orange,
                  ),
                  SizedBox(width: 8.w),
                  moreOptionsWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (context.hasPermission(
                          PermissionName.offerprice_show,
                        ))
                          SingleMoreItemWidget(
                            context: context,
                            title: TranslationsController.instance
                                .getTranslations()
                                .preview,
                            icon: IconAssets.eye,
                            onTap: () {
                              Navigator.of(context).pop();
                              context.pushNamed(
                                Routes.offerPriceDetailsScreen,
                                arguments: {
                                  "offerPriceDataEntity": offerPriceDataEntity,
                                },
                              );
                            },
                          ),
                        if (context.hasPermission(
                          PermissionName.offerprice_show,
                        )) ...[
                          const CustomDivider(),
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
                                arguments: {"uuid": offerPriceDataEntity.uuid},
                              );
                            },
                          ),
                        ],

                        if (context.hasPermission(
                          PermissionName.offerprice_show,
                        ))
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
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomText(
                                        text: TranslationsController.instance
                                            .getTranslations()
                                            .extractPdf,
                                        textStyle: getMediumStyle(
                                          color: ColorManager.optionColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : context.hasPermission(
                                PermissionName.offerprice_show,
                              )
                            ? SingleMoreItemWidget(
                                context: context,
                                title: TranslationsController.instance
                                    .getTranslations()
                                    .extractPdf,
                                icon: IconAssets.addFloating,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _handlePdfExtraction(context, profileState);
                                },
                              )
                            : const SizedBox.shrink(),
                        if (offerPriceDataEntity.isConverted.toString() !=
                                "true" &&
                            context.hasPermission(
                              PermissionName.offerprice_edit,
                            )) ...[
                          const CustomDivider(),
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
                                  "offerPriceEntity": this.offerPriceDataEntity,
                                },
                              );
                            },
                          ),
                        ],

                        /*  */
                        if (offerPriceDataEntity.isConverted.toString() !=
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
                                  "offerPriceDataEntity": offerPriceDataEntity,
                                },
                              );
                            },
                          ),
                        ],
                        if (offerPriceDataEntity.isConverted.toString() !=
                                "true" &&
                            context.hasPermission(
                              PermissionName.offerprice_delete,
                            )) ...[
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
                                message: TranslationsController.instance
                                    .getTranslations()
                                    .cannotUndoIfYes,
                                onConfirm: () {
                                  BlocProvider.of<DeleteOfferPriceBloc>(
                                    context,
                                  ).add(
                                    DeleteOfferPriceSubmitted(
                                      id: offerPriceDataEntity.uuid,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                    context: context,
                    onPreviewTap: () {},
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  void _handlePdfExtraction(BuildContext context, ProfileState profileState) {
    if (profileState is ProfileSuccessState) {
      print("aaa");
      // Profile is loaded successfully, proceed with PDF extraction
      PdfExtractionService.extractInvoicePdf(
        myInfo: profileState.profileEntity,
        context: context,
        invoiceId: offerPriceDataEntity.uuid,
        invoiceNumber: offerPriceDataEntity.identificationNumber,
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
