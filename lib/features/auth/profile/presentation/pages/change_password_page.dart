import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_password_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import '../bloc/change_password/change_password_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordBloc>().add(
        ChangePasswordSubmitted(
          currentPassword: _currentController.text.trim(),
          newPassword: _newController.text.trim(),
          confirmPassword: _confirmController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is ChangePasswordSuccess || s is ChangePasswordError,
      ),
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          customToast(msg: AppTranslation.changePasswordSuccess);
          Navigator.of(context).pop();
        } else if (state is ChangePasswordError) {
          customToast(msg: state.message);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: state is ChangePasswordLoading,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: CustomAppBar(title: AppTranslation.changePasswordTitle),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppPadding.p24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomPasswordField(
                        title: AppTranslation.oldPassword,
                        hintText: AppTranslation.enterPassword,
                        controller: _currentController,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.forgotPassword);
                          },
                          child: CustomText(
                            text: AppTranslation.forgotPassword,
                            textStyle: getMediumStyle(
                              fontSize: AppFontSize.s14,
                              color: ColorManager.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppHeight.s16),
                      CustomPasswordField(
                        title: AppTranslation.newPassword,
                        hintText: AppTranslation.enterPassword,
                        controller: _newController,
                      ),
                      SizedBox(height: AppHeight.s24),
                      CustomPasswordField(
                        title: AppTranslation.confirmPassword,
                        hintText: AppTranslation.enterPassword,
                        controller: _confirmController,
                      ),
                      SizedBox(height: AppHeight.s32),
                      CustomButton(
                        text: AppTranslation.save,
                        onPressed: _submit,
                        color: ColorManager.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
