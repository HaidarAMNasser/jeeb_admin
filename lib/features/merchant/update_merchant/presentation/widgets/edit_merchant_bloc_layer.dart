import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';

class EditMerchantBlocLayer extends StatelessWidget {
  final Widget Function(BuildContext context, bool isLoading) builder;

  const EditMerchantBlocLayer({super.key, required this.builder});

  void _goToMerchantsTab(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.mainNavigation,
      (_) => false,
      arguments: {'tabIndex': 0},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateMerchantBloc, UpdateMerchantState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is UpdateMerchantSuccess || s is UpdateMerchantError,
      ),
      listener: (context, state) {
        if (state is UpdateMerchantSuccess) {
          customToast(msg: AppTranslation.merchantUpdatedSuccessfully);
          _goToMerchantsTab(context);
        } else if (state is UpdateMerchantError) {
          customToast(msg: state.message);
        }
      },
      child: BlocBuilder<UpdateMerchantBloc, UpdateMerchantState>(
        buildWhen: (previous, current) =>
            previous is UpdateMerchantLoading || current is UpdateMerchantLoading,
        builder: (context, state) {
          return builder(context, state is UpdateMerchantLoading);
        },
      ),
    );
  }
}
