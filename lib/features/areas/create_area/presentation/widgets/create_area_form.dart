import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/features/areas/create_area/helpful_functions/area_validation.dart';
import 'package:jeeb_admin/features/areas/create_area/presentation/bloc/create_area_bloc.dart';
import 'package:jeeb_admin/features/areas/update_area/presentation/bloc/update_area_bloc.dart';

class CreateAreaForm extends StatelessWidget {
  final CreateAreaBloc bloc;
  final CreateAreaState state;
  final bool isEdit;

  const CreateAreaForm({
    super.key,
    required this.bloc,
    required this.state,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: bloc.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              title: AppTranslation.areaName,
              hintText: AppTranslation.areaName,
              controller: bloc.nameController,
              onChanged: (value) {
                bloc.add(UpdateAreaName(name: value));
              },
            ),
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              title: AppTranslation.areaPrice,
              hintText: AppTranslation.areaPrice,
              controller: bloc.priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                bloc.add(UpdateAreaPrice(price: value));
              },
            ),
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              title: AppTranslation.areaDescription,
              hintText: AppTranslation.areaDescription,
              controller: bloc.descriptionController,
              onChanged: (value) {
                bloc.add(UpdateAreaDescription(description: value));
              },
            ),
            SizedBox(height: AppHeight.s32),
            BlocBuilder<UpdateAreaBloc, UpdateAreaState>(
              builder: (context, updateState) {
                final isValid = state.isValid;
                return CustomButton(
                  text: isEdit ? AppTranslation.save : AppTranslation.addArea,
                  onPressed: () {
                    areaValidationToast(
                      name: bloc.nameController.text.trim(),
                      price: bloc.priceController.text.trim(),
                    );

                    if (!isValid) {
                      return;
                    }

                    if (isEdit) {
                      context.read<UpdateAreaBloc>().add(
                            UpdateAreaSubmitted(
                              id: state.areaId!,
                              name: bloc.nameController.text.trim(),
                              description:
                                  bloc.descriptionController.text.trim().isEmpty
                                      ? null
                                      : bloc.descriptionController.text.trim(),
                              price: double.tryParse(
                                    bloc.priceController.text.trim(),
                                  ) ??
                                  0.0,
                            ),
                          );
                    } else {
                      bloc.add(const CreateAreaSubmitted());
                    }
                  },
                  isLoading: false,
                  color: isValid
                      ? ColorManager.primary
                      : ColorManager.closeDialogColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
