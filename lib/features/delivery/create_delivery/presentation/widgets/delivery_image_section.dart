import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class DeliveryImageSection extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;
  final VoidCallback onClearImage;

  const DeliveryImageSection({
    super.key,
    this.imagePath,
    required this.onPickImage,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: AppTranslation.productImages,
            textStyle: getSemiBoldStyle(
              fontSize: AppFontSize.s16,
              color: ColorManager.defaultWhite,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: AppTranslation.pleaseAddAtLeastOneImage,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s12,
              color: ColorManager.descriptionColor,
            ),
          ),
          SizedBox(height: AppHeight.s12),
        Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onPickImage,
              icon: Icon(
                Icons.add_photo_alternate,
                color: ColorManager.primary,
                size: AppSize.s20,
              ),
              label: CustomText(
                text: AppTranslation.addImage,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p12,
                  vertical: AppPadding.p8,
                ),
              ),
            ),
          ),
          if (imagePath != null && imagePath!.isNotEmpty) ...[
            SizedBox(height: AppHeight.s12),
            SizedBox(
              height: AppHeight.s100,
              child: _DeliveryImageItem(
                imagePath: imagePath!,
                onRemove: onClearImage,
              ),
            ),
          ],
          SizedBox(height: AppHeight.s8),
        ],
      ),
    );
  }
}

class _DeliveryImageItem extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRemove;

  const _DeliveryImageItem({
    required this.imagePath,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppHeight.s100,
      margin: EdgeInsets.only(right: AppMargin.m12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: ColorManager.borderColor),
        color: ColorManager.defaultWhite,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: imagePath.startsWith('http')
                ? CustomCachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: _buildPlaceholder(),
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  ),
          ),
          Positioned(
            top: AppSize.s5,
            right: AppSize.s5,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(AppSize.s5),
                decoration: BoxDecoration(
                  color: ColorManager.defaultYellow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: AppSize.s16,
                  color: ColorManager.defaultWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ColorManager.background,
      child: Icon(
        Icons.image,
        color: ColorManager.defaultWhite.withOpacity(0.3),
        size: AppSize.s40,
      ),
    );
  }
}
