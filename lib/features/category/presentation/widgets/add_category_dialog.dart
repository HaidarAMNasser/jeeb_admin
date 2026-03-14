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
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/category/add_category/presentation/bloc/add_category_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AddCategoryDialog extends StatefulWidget {
  final BuildContext pageContext;

  const AddCategoryDialog({super.key, required this.pageContext});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AddCategoryDialog(pageContext: context),
    );
  }

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null && mounted) {
      setState(() => _imagePath = xFile.path);
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      customToast(msg: AppTranslation.pleaseEnterCategoryName);
      return;
    }
    Navigator.of(context).pop();
    widget.pageContext.read<AddCategoryBloc>().add(
      AddCategorySubmitted(name: name, imagePath: _imagePath),
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
                text: AppTranslation.addCategory,
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
              _ImagePickerSection(imagePath: _imagePath, onTap: _pickImage),
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
  final String? imagePath;
  final VoidCallback onTap;

  const _ImagePickerSection({this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
            if (imagePath != null && File(imagePath!).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                child: Image.file(
                  File(imagePath!),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(
                Icons.add_photo_alternate,
                color: ColorManager.primary,
                size: 32.sp ,
              ),
            SizedBox(width: AppWidth.s12),
            Expanded(
              child: CustomText(
                text: imagePath != null
                    ? AppTranslation.addImage
                    : AppTranslation.addImage,
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
