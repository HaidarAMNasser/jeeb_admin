import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductImagesSection extends StatelessWidget {
  final CreateProductBloc bloc;

  const ProductImagesSection({super.key, required this.bloc});

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        for (var image in images) {
          // For now, we'll use the file path as the image URL
          // In production, you would upload the image and get the URL
          bloc.add(AddProductImage(imageUrl: image.path));
        }
      }
    } catch (e) {
      // Handle error - could show a snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
      builder: (context, state) {
        return Column(
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
            // Add Image Button
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: _pickImages,
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
            // Images List
            if (state.images.isNotEmpty) ...[
              SizedBox(height: AppHeight.s12),
              SizedBox(
                height: AppHeight.s100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.images.length,
                  itemBuilder: (context, index) {
                    return _ImageItem(
                      imagePath: state.images[index],
                      onRemove: () {
                        bloc.add(RemoveProductImage(index: index));
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ImageItem extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRemove;

  const _ImageItem({required this.imagePath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ? Image.network(
                    imagePath,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: ColorManager.background,
                        child: Icon(
                          Icons.image,
                          color: ColorManager.defaultWhite.withOpacity(0.3),
                          size: AppSize.s40,
                        ),
                      );
                    },
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: ColorManager.background,
                        child: Icon(
                          Icons.image,
                          color: ColorManager.defaultWhite.withOpacity(0.3),
                          size: AppSize.s40,
                        ),
                      );
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
}
