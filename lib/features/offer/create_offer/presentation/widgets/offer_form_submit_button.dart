import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/update_offer/presentation/bloc/update_offer_bloc.dart';

class OfferFormSubmitButton extends StatelessWidget {
  final CreateOfferState state;
  final bool isEdit;
  final VoidCallback onSubmit;

  const OfferFormSubmitButton({
    super.key,
    required this.state,
    required this.isEdit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateOfferBloc, UpdateOfferState>(
      builder: (context, updateState) {
        return CustomButton(
          text: isEdit ? AppTranslation.save : AppTranslation.addOffer,
          onPressed: state.isValid ? onSubmit : null,
          isLoading: false,
          color: state.isValid
              ? ColorManager.primary
              : ColorManager.closeDialogColor,
        );
      },
    );
  }
}
