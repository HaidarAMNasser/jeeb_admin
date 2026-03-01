import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/widgets/create_delivery_form.dart';

class AddDeliveryPage extends StatefulWidget {
  final DeliveryManEntity? deliveryMan;

  const AddDeliveryPage({super.key, this.deliveryMan});

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isEditMode => widget.deliveryMan != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Split name into firstName and lastName
      final nameParts = widget.deliveryMan!.name.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      _phoneController.text = widget.deliveryMan!.phone;
      _emailController.text = widget.deliveryMan!.email;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteDeliveryBloc, DeleteDeliveryState>(
      listener: (context, deleteState) {
        if (deleteState is DeleteDeliverySuccess) {
          customToast(msg: AppTranslation.deliveryManDeletedSuccessfully);
          context.pushNamed(Routes.delivery);
        } else if (deleteState is DeleteDeliveryError) {
          customToast(msg: deleteState.message);
        }
      },
      builder: (context, deleteState) {
        return BlocConsumer<UpdateDeliveryBloc, UpdateDeliveryState>(
          listener: (context, updateState) {
            if (updateState is UpdateDeliverySuccess) {
              customToast(msg: AppTranslation.deliveryManUpdatedSuccessfully);
              context.pushNamed(Routes.delivery);
            } else if (updateState is UpdateDeliveryError) {
              customToast(msg: updateState.message);
            }
          },
          builder: (context, updateState) {
            return BlocConsumer<CreateDeliveryBloc, CreateDeliveryState>(
              listener: (context, createState) {
                if (createState is CreateDeliverySuccess) {
                  customToast(
                    msg: AppTranslation.deliveryManCreatedSuccessfully,
                  );
                  context.pushNamed(Routes.delivery);
                } else if (createState is CreateDeliveryError) {
                  customToast(msg: createState.message);
                }
              },
              builder: (context, createState) {
                return BlocBuilder<DeleteDeliveryBloc, DeleteDeliveryState>(
                  builder: (context, deleteStateBuilder) {
                    return ModalProgressHUD(
                      progressIndicator: const CustomCircleIndicator(),
                      inAsyncCall:
                          createState is CreateDeliveryLoading ||
                          updateState is UpdateDeliveryLoading ||
                          deleteStateBuilder is DeleteDeliveryLoading,
                      child: Scaffold(
                        backgroundColor: ColorManager.background,
                        appBar: CustomAppBar(
                          title: _isEditMode
                              ? AppTranslation.editDeliveryMan
                              : AppTranslation.addDeliveryMan,
                          actions: _isEditMode
                              ? [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: ColorManager.error,
                                    ),
                                    onPressed: () =>
                                        _showDeleteConfirmation(context),
                                  ),
                                ]
                              : null,
                        ),

                        body: CreateDeliveryForm(
                          isEdit: _isEditMode,
                          deliveryManId: widget.deliveryMan?.id,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          phoneController: _phoneController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          formKey: _formKey,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteDeliveryMan,
      onConfirm: () {
        if (widget.deliveryMan != null) {
          context.read<DeleteDeliveryBloc>().add(
            DeleteDeliverySubmitted(deliveryManId: widget.deliveryMan!.id),
          );
        }
      },
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.error,
    );
  }
}
