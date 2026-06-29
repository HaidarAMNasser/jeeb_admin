import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class AdminResetPasswordDialog extends StatefulWidget {
  final void Function(String password) onSubmit;

  const AdminResetPasswordDialog({super.key, required this.onSubmit});

  static Future<void> show({
    required BuildContext context,
    required void Function(String password) onSubmit,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AdminResetPasswordDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<AdminResetPasswordDialog> createState() =>
      _AdminResetPasswordDialogState();
}

class _AdminResetPasswordDialogState extends State<AdminResetPasswordDialog> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      customToast(msg: AppTranslation.pleaseEnterPassword);
      return;
    }
    if (password.length < 6) {
      customToast(msg: AppTranslation.passwordMustBeAtLeast6Characters);
      return;
    }
    Navigator.of(context).pop();
    widget.onSubmit(password);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: AppTranslation.editPassword,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppHeight.s24),
            CustomTextField(
              controller: _passwordController,
              title: AppTranslation.password,
              hintText: AppTranslation.enterPassword,
              obscureText: true,
            ),
            SizedBox(height: AppHeight.s24),
            CustomButton(
              text: AppTranslation.save,
              onPressed: _submit,
              isLoading: false,
            ),
            SizedBox(height: AppHeight.s12),
            CustomButton(
              text: AppTranslation.cancel,
              onPressed: () => Navigator.of(context).pop(),
              isOutlined: true,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}
