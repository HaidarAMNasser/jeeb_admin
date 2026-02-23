import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/extensions/permission_context_extension.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/enums/permission_enum.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/dialogs/confirmation_dialog.dart';
import 'package:fatoorahapp/widgets/divider_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../widgets/more_options_widget.dart';
import '../../../../../widgets/single_more_item_widget.dart';

class OfferPriceDetailsTitleWidget extends StatelessWidget {
  final String title;
  final String id;
  final bool showOptions;
  final BuildContext context;
  final OfferPriceSingleEntity offerPriceDataEntity;
  const OfferPriceDetailsTitleWidget({
    required this.context,
    super.key,
    required this.title,
    required this.id,
    required this.offerPriceDataEntity,
    required this.showOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: CustomText(
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            text: title,
            textStyle: getBoldStyle(fontSize: AppFontSize.s12),
          ),
        ),
        horizontalSpace(width: 8.w),
        CustomText(
          text: id,
          textStyle: getRegularStyle(fontSize: 12.sp),
        ),
        if (showOptions) ...[
          Spacer(),
          moreOptionsWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (context.hasPermission(PermissionName.offerprice_show))
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
                if (context.hasPermission(PermissionName.offerprice_show))
                  const CustomDivider(),
                if (context.hasPermission(PermissionName.offerprice_edit))
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
                if (context.hasPermission(PermissionName.offerprice_edit))
                  const CustomDivider(),
                if (context.hasPermission(PermissionName.offerprice_delete))
                  SingleMoreItemWidget(
                    context: context,
                    title: TranslationsController.instance
                        .getTranslations()
                        .delete,
                    icon: IconAssets.delete,
                    onTap: () {
                      Navigator.of(this.context).pop();

                      showDeleteConfirmationDialog(
                        context: this.context,
                        title: TranslationsController.instance
                            .getTranslations()
                            .areYouSureToDelete,
                        message: TranslationsController.instance
                            .getTranslations()
                            .cannotUndoIfYes,
                        onConfirm: () {
                          BlocProvider.of<DeleteOfferPriceBloc>(context).add(
                            DeleteOfferPriceSubmitted(
                              id: offerPriceDataEntity.uuid,
                            ),
                          );
                        },
                      );
                      // Navigator.of(context).pop();
                      // BlocProvider.of<DeleteOfferPriceBloc>(context).add(
                      //   DeleteOfferPriceSubmitted(id: offerPriceDataEntity.uuid),
                      // );
                    },
                  ),
              ],
            ),
            context: context,
            onPreviewTap: () {},
          ),
        ],
      ],
    );
  }
}
