import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/category_options_dialog.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Row(
        
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            SizedBox(width: AppWidth.s12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: category.name,
                    textStyle: getMediumStyle(
                      fontSize: AppFontSize.s16,
                      color: ColorManager.productNameColor,
                    ),
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, ),
              onPressed: () => CategoryOptionsDialog.show(
                context: context,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: SizedBox(
          width: AppWidth.s56,
          height: AppHeight.s56,
          child: CustomCachedNetworkImage(
            imageUrl: category.imageUrl!,
            fit: BoxFit.cover,
            width: AppWidth.s56,
            height: AppHeight.s56,
            errorWidget: _placeholderIcon(),
          ),
        ),
      );
    }
    return Container(
      width: AppWidth.s56,
      height: AppHeight.s56,
      decoration: BoxDecoration(
        color: ColorManager.background,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: _placeholderIcon(),
    );
  }

  Widget _placeholderIcon() {
    return Icon(Icons.category, color: ColorManager.primary, size: AppSize.s28);
  }
}
