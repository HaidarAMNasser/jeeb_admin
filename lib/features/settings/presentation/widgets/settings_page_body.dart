import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/settings/get_settings/domain/entities/settings_entity.dart';
import 'package:jeeb_admin/features/settings/get_settings/presentation/bloc/get_settings_bloc.dart';
import 'package:jeeb_admin/features/settings/presentation/widgets/settings_form.dart';

class SettingsPageBody extends StatelessWidget {
  const SettingsPageBody({
    super.key,
    required this.formKey,
    required this.supportPhoneController,
    required this.whatsappNumberController,
    required this.commissionRateController,
    required this.deliveryTipPerKmController,
    required this.maxIncompleteOrdersController,
    required this.onSyncFormFromSettings,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController supportPhoneController;
  final TextEditingController whatsappNumberController;
  final TextEditingController commissionRateController;
  final TextEditingController deliveryTipPerKmController;
  final TextEditingController maxIncompleteOrdersController;
  final void Function(SettingsEntity) onSyncFormFromSettings;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSettingsBloc, GetSettingsState>(
      listener: (context, getState) {
        if (getState is GetSettingsLoaded) {
          onSyncFormFromSettings(getState.settings);
        }
      },
      builder: (context, getState) {
        return BlocStateHandler<GetSettingsBloc, GetSettingsState>(
          bloc: context.read<GetSettingsBloc>(),
          isLoading: (s) => s is GetSettingsLoading,
          isError: (s) => s is GetSettingsError,
          getErrorMessage: (s) => (s as GetSettingsError).message,
          isSuccess: (s) => s is GetSettingsLoaded,
          getRetryCallback: (_) => () => context
              .read<GetSettingsBloc>()
              .add(const GetSettingsRequested()),
          successBuilder: (context, state) {
            return SettingsForm(
              formKey: formKey,
              supportPhoneController: supportPhoneController,
              whatsappNumberController: whatsappNumberController,
              commissionRateController: commissionRateController,
              deliveryTipPerKmController: deliveryTipPerKmController,
              maxIncompleteOrdersController: maxIncompleteOrdersController,
              onSave: onSave,
            );
          },
        );
      },
    );
  }
}
