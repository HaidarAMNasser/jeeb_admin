import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/settings/get_settings/domain/entities/settings_entity.dart';
import 'package:jeeb_admin/features/settings/get_settings/presentation/bloc/get_settings_bloc.dart';
import 'package:jeeb_admin/features/settings/edit_settings/presentation/bloc/edit_settings_bloc.dart';
import 'package:jeeb_admin/features/settings/presentation/widgets/settings_page_body.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _supportPhoneController;
  late TextEditingController _whatsappNumberController;
  late TextEditingController _commissionRateController;
  late TextEditingController _deliveryTipPerKmController;

  @override
  void initState() {
    super.initState();
    _supportPhoneController = TextEditingController();
    _whatsappNumberController = TextEditingController();
    _commissionRateController = TextEditingController();
    _deliveryTipPerKmController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted)
        context.read<GetSettingsBloc>().add(const GetSettingsRequested());
    });
  }

  @override
  void dispose() {
    _supportPhoneController.dispose();
    _whatsappNumberController.dispose();
    _commissionRateController.dispose();
    _deliveryTipPerKmController.dispose();
    super.dispose();
  }

  void _syncFormFromSettings(SettingsEntity settings) {
    _supportPhoneController.text = settings.supportPhone;
    _whatsappNumberController.text = settings.whatsappNumber;
    _commissionRateController.text = settings.defaultProductCommissionRate
        .toString();
    _deliveryTipPerKmController.text =
        settings.deliveryTipPerKilometer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditSettingsBloc, EditSettingsState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is EditSettingsSuccess || s is EditSettingsError,
      ),
      listener: (context, editState) {
        if (editState is EditSettingsSuccess) {
          customToast(msg: AppTranslation.settingsUpdatedSuccessfully);
          context.read<GetSettingsBloc>().add(const GetSettingsRequested());
        } else if (editState is EditSettingsError) {
          customToast(msg: editState.message);
        }
      },
      builder: (context, editState) {
        final isEditLoading = editState is EditSettingsLoading;
        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: isEditLoading,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: CustomAppBar(title: AppTranslation.settings),
            body: SettingsPageBody(
              formKey: _formKey,
              supportPhoneController: _supportPhoneController,
              whatsappNumberController: _whatsappNumberController,
              commissionRateController: _commissionRateController,
              deliveryTipPerKmController: _deliveryTipPerKmController,
              onSyncFormFromSettings: _syncFormFromSettings,
              onSave: () => _onSave(context),
            ),
          ),
        );
      },
    );
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final rate = num.tryParse(_commissionRateController.text.trim());
    if (rate == null || rate < 0) {
      customToast(msg: AppTranslation.pleaseEnterValidCommissionRate);
      return;
    }
    final tipKm = num.tryParse(_deliveryTipPerKmController.text.trim());
    if (tipKm == null || tipKm < 0) {
      customToast(msg: AppTranslation.pleaseEnterValidCommissionRate);
      return;
    }
    context.read<EditSettingsBloc>().add(
      EditSettingsSubmitted(
        supportPhone: _supportPhoneController.text.trim(),
        whatsappNumber: _whatsappNumberController.text.trim(),
        defaultProductCommissionRate: rate,
        deliveryTipPerKilometer: tipKm,
      ),
    );
  }
}
