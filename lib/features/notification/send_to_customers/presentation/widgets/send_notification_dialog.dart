import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/notification/send_to_customers/presentation/bloc/send_to_customers_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SendNotificationDialog extends StatelessWidget {
  final BuildContext pageContext;

  const SendNotificationDialog({super.key, required this.pageContext});

  static Future<void> show(BuildContext context) {
    context.read<SendToCustomersBloc>().add(const ResetSendNotificationForm());
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SendNotificationDialog(pageContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = pageContext.read<SendToCustomersBloc>();

    return BlocConsumer<SendToCustomersBloc, SendToCustomersState>(
      bloc: bloc,
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is SendToCustomersSuccess || s is SendToCustomersError,
      ),
      listener: (context, state) {
        if (state is SendToCustomersSuccess) {
          Navigator.of(context).pop();
          customToast(msg: AppTranslation.notificationSentSuccessfully);
          bloc.add(const ResetSendNotificationForm());
        } else if (state is SendToCustomersError) {
          customToast(msg: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is SendToCustomersLoading;

        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: isLoading,
          child: Dialog(
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
                child: Form(
                  key: bloc.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomText(
                        text: AppTranslation.sendNotification,
                        textStyle: getBoldStyle(
                          fontSize: AppFontSize.s18,
                          color: ColorManager.titlesColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppHeight.s24),
                      CustomTextField(
                        title: AppTranslation.notificationTitle,
                        hintText: AppTranslation.enterNotificationTitle,
                        controller: bloc.titleController,
                        onChanged: (value) {
                          bloc.add(UpdateNotificationTitle(title: value));
                        },
                      ),
                      SizedBox(height: AppHeight.s16),
                      CustomTextField(
                        title: AppTranslation.notificationBody,
                        hintText: AppTranslation.enterNotificationBody,
                        controller: bloc.bodyController,
                        onChanged: (value) {
                          bloc.add(UpdateNotificationBody(body: value));
                        },
                      ),
                      SizedBox(height: AppHeight.s24),
                      CustomButton(
                        text: AppTranslation.cancel,
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        isOutlined: true,
                        color: ColorManager.primary,
                      ),
                      SizedBox(height: AppHeight.s16),
                      BlocBuilder<SendToCustomersBloc, SendToCustomersState>(
                        bloc: bloc,
                        builder: (context, blocState) {
                          final isValid = blocState.isValid;
                          return CustomButton(
                            text: AppTranslation.sendNotificationAction,
                            onPressed: isLoading || !isValid
                                ? null
                                : () {
                                    if (!bloc.formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (!isValid) {
                                      customToast(
                                        msg: AppTranslation
                                            .pleaseEnterNotificationTitleAndBody,
                                      );
                                      return;
                                    }
                                    bloc.add(const SendToCustomersSubmitted());
                                  },
                            color: isValid
                                ? ColorManager.primary
                                : ColorManager.closeDialogColor,
                          );
                        },
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
