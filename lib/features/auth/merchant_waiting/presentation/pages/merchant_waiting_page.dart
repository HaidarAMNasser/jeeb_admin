import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/notification_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/auth/login/data/repositories/login_repository.dart';

class MerchantWaitingPage extends StatefulWidget {
  final String email;
  final String password;

  const MerchantWaitingPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<MerchantWaitingPage> createState() => _MerchantWaitingPageState();
}

class _MerchantWaitingPageState extends State<MerchantWaitingPage> {
  bool _isRefreshing = false;

  Future<void> _refreshStatus() async {
    if (widget.email.isEmpty || widget.password.isEmpty) {
      customToast(msg: AppTranslation.errorOccurred);
      return;
    }

    setState(() => _isRefreshing = true);

    final loginRepository = di.sl<LoginRepository>();
    final storageService = di.sl<StorageService>();
    final result = await loginRepository.login(
      email: widget.email,
      password: widget.password,
    );

    await result.fold(
      (failure) async {
        customToast(msg: AppTranslation.merchantAccountNotConfirmedYet);
      },
      (tokenEntity) async {
        if (tokenEntity.user.isActive != true) {
          customToast(msg: AppTranslation.merchantAccountNotConfirmedYet);
          return;
        }

        await storageService.setUserToken(tokenEntity.accessToken);
        await storageService.setUserId(tokenEntity.user.id);
        await storageService.setUserRole(tokenEntity.user.role.name);
        await storageService.setLoggedIn(true);
        await storageService.setVerified(tokenEntity.user.isVerified);
        await storageService.setPendingVerifyEmail(null);
        di.sl<NotificationService>().requestSyncAfterLogin();

        if (!mounted) return;
        context.pushNamedAndRemoveUntil(
          Routes.mainNavigation,
          predicate: (route) => false,
        );
      },
    );

    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  void _backToLogin() {
    context.pushNamedAndRemoveUntil(Routes.login, predicate: (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.merchantWaitingTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppHeight.s40),
              Icon(
                Icons.hourglass_top_rounded,
                color: ColorManager.primary,
                size: AppSize.s70,
              ),
              SizedBox(height: AppHeight.s16),
              CustomText(
                text: AppTranslation.merchantWaitingTitle,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s22,
                  color: ColorManager.titlesColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppHeight.s12),
              CustomText(
                text: AppTranslation.merchantWaitingSubtitle,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppHeight.s40),
              CustomButton(
                text: AppTranslation.refreshPage,
                onPressed: _isRefreshing ? null : _refreshStatus,
                isLoading: _isRefreshing,
                color: ColorManager.primary,
              ),
              SizedBox(height: AppHeight.s16),
              CustomButton(
                text: AppTranslation.backToLogin,
                onPressed: _backToLogin,
                isOutlined: true,
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
