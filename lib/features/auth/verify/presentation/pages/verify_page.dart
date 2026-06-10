import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import '../bloc/verify_bloc.dart';
import '../widgets/verify_header.dart';
import '../widgets/verify_form.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class VerifyPage extends StatefulWidget {
  final String email;
  final String? password;

  const VerifyPage({super.key, required this.email, this.password});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Send OTP automatically when opening the verify screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.email.isNotEmpty) {
        context.read<VerifyBloc>().add(ResendOtpSubmitted(email: widget.email));
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      if (otp.isEmpty) {
        customToast(msg: AppTranslation.pleaseEnterOtp);
        return;
      }

      context.read<VerifyBloc>().add(
        VerifySubmitted(
          email: widget.email,
          otp: otp,
          password: widget.password,
        ),
      );
    }
  }

  void _handleResendOtp() {
    context.read<VerifyBloc>().add(ResendOtpSubmitted(email: widget.email));
  }

  void _handleBackToLogin() {
    context.pushNamedAndRemoveUntil(
      Routes.login,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyBloc, VerifyState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) =>
            s is VerifySuccess ||
            s is VerifyOtpResent ||
            s is VerifyError,
      ),
      listener: (context, state) {
        if (state is VerifySuccess) {
          if (state.goToPending) {
            customToast(msg: AppTranslation.merchantWaitingSubtitle);
            context.pushNamedAndRemoveUntil(
              Routes.merchantWaiting,
              predicate: (route) => false,
              arguments: {
                'email': state.email,
                'password': state.password,
              },
            );
          } else if (state.goToMain) {
            customToast(msg: AppTranslation.accountVerifiedSuccess);
            context.pushNamedAndRemoveUntil(
              Routes.mainNavigation,
              predicate: (route) => false,
            );
          } else {
            customToast(msg: AppTranslation.registerSuccess);
            context.pushNamedAndRemoveUntil(
              Routes.login,
              predicate: (route) => false,
            );
          }
        } else if (state is VerifyOtpResent) {
          customToast(msg: AppTranslation.otpSentSuccess);
        } else if (state is VerifyError) {
          customToast(msg: state.message);
        }
      },
      child: BlocBuilder<VerifyBloc, VerifyState>(
        builder: (context, state) {
          return ModalProgressHUD(
            progressIndicator: const CustomCircleIndicator(),
            inAsyncCall: state is VerifyLoading || state is VerifyLoggingIn,
            child: Scaffold(
              backgroundColor: ColorManager.background,
              appBar: CustomAppBar(title: AppTranslation.verifyAccount,
              onBackPressed: ()
              {
                _handleBackToLogin();
              },),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppPadding.p24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VerifyHeader(email: widget.email),
                      VerifyForm(
                        formKey: _formKey,
                        otpController: _otpController,
                        onVerify: _handleVerify,
                        onResendOtp: _handleResendOtp,
                        onBackToLogin: _handleBackToLogin,
                        isLoading: state is VerifyLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}





