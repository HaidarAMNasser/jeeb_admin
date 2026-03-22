import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/delete_category/presentation/bloc/delete_category_bloc.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/category_list_item.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/edit_category_dialog.dart';

class CategoriesListBody extends StatelessWidget {
  final BuildContext pageContext;
  final List<CategoryEntity> categories;

  const CategoriesListBody({
    super.key,
    required this.pageContext,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _EmptyCategoriesState();
    }
    return ListView.separated(
      padding: EdgeInsets.all(AppPadding.p24),
      itemCount: categories.length,
      separatorBuilder: (_, __) => SizedBox(height: AppHeight.s12),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListItem(
          category: category,
          onEdit: () => EditCategoryDialog.show(pageContext, category),
          onDelete: () => _showDeleteConfirmation(category),
        );
      },
    );
  }

  void _showDeleteConfirmation(CategoryEntity category) {
    ConfirmationDialog.show(
      context: pageContext,
      title: AppTranslation.areYouSureDeleteCategory,
      confirmText: AppTranslation.delete,
      cancelText: AppTranslation.cancel,
      confirmColor: ColorManager.primary,
      onConfirm: () {
        pageContext.read<DeleteCategoryBloc>().add(
              DeleteCategorySubmitted(categoryId: category.id),
            );
      },
    );
  }
}

class _EmptyCategoriesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p24),
        child: CustomText(
          text: AppTranslation.noCategoriesFound,
          textStyle: getRegularStyle(
            color: ColorManager.defaultWhite,
            fontSize: AppFontSize.s16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
