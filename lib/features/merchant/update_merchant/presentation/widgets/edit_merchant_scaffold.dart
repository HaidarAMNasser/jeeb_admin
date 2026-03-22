import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditMerchantScaffold extends StatelessWidget {
  final bool isLoading;
  final String merchantId;
  final void Function(MerchantDetailsLoaded state) onInitialize;
  final Widget formContent;

  const EditMerchantScaffold({
    super.key,
    required this.isLoading,
    required this.merchantId,
    required this.onInitialize,
    required this.formContent,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CustomCircleIndicator(),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(title: AppTranslation.editMerchant),
        body: BlocStateHandler<MerchantDetailsBloc, MerchantDetailsState>(
          bloc: context.read<MerchantDetailsBloc>(),
          isLoading: (state) => state is MerchantDetailsLoading,
          isError: (state) => state is MerchantDetailsError,
          getErrorMessage: (state) => (state as MerchantDetailsError).message,
          isSuccess: (state) => state is MerchantDetailsLoaded,
          getRetryCallback: (_) => () {
            context.read<MerchantDetailsBloc>().add(
              GetMerchantDetailsEvent(id: merchantId),
            );
          },
          successBuilder: (context, detailsState) {
            onInitialize(detailsState as MerchantDetailsLoaded);
            return formContent;
          },
        ),
      ),
    );
  }
}
