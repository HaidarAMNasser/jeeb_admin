import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/update_category/presentation/bloc/update_category_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EditCategoryDialog extends StatefulWidget {
  final BuildContext pageContext;
  final CategoryEntity category;

  const EditCategoryDialog({
    super.key,
    required this.pageContext,
    required this.category,
  });

  static Future<void> show(BuildContext context, CategoryEntity category) {
    return showDialog(
      context: context,
      builder: (ctx) => EditCategoryDialog(
        pageContext: context,
        category: category,
      ),
    );
  }

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameController;
  String? _newImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null && mounted) {
      setState(() => _newImagePath = xFile.path);
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      customToast(msg: AppTranslation.pleaseEnterCategoryName);
      return;
    }
    Navigator.of(context).pop();
    widget.pageContext.read<UpdateCategoryBloc>().add(
          UpdateCategorySubmitted(
            id: widget.category.id,
            name: name,
            imagePath: _newImagePath,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(
                text: AppTranslation.editCategory,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.titlesColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppHeight.s24),
              CustomTextField(
                title: AppTranslation.categoryName,
                hintText: AppTranslation.categoryName,
                controller: _nameController,
              ),
              SizedBox(height: AppHeight.s16),
              _ImagePickerSection(
                imageUrl: widget.category.imageUrl,
                newImagePath: _newImagePath,
                onTap: _pickImage,
              ),
              SizedBox(height: AppHeight.s24),
              CustomButton(
                text: AppTranslation.cancel,
                onPressed: () => Navigator.of(context).pop(),
                isOutlined: true,
                color: ColorManager.primary,
              ),
              SizedBox(height: AppHeight.s16),
              CustomButton(
                text: AppTranslation.save,
                onPressed: _onSave,
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  final String? imageUrl;
  final String? newImagePath;
  final VoidCallback onTap;

  const _ImagePickerSection({
    this.imageUrl,
    this.newImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasNewImage = newImagePath != null && File(newImagePath!).existsSync();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: ColorManager.background,
          border: Border.all(color: ColorManager.borderColor),
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            if (hasNewImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                child: Image.file(
                  File(newImagePath!),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            else if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                child: CustomCachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(Icons.add_photo_alternate, color: ColorManager.primary, size: 32.sp),
            SizedBox(width: AppWidth.s12),
            Expanded(
              child: CustomText(
                text: AppTranslation.addImage,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.titlesColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
