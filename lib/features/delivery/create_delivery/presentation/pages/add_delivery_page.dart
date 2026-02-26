import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';

class AddDeliveryPage extends StatefulWidget {
  final DeliveryManEntity? deliveryMan;

  const AddDeliveryPage({super.key, this.deliveryMan});

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _statusController = TextEditingController();

  bool get _isEditMode => widget.deliveryMan != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.deliveryMan!.name;
      _phoneController.text = widget.deliveryMan!.phone;
      _emailController.text = widget.deliveryMan!.email;
      _vehicleController.text = widget.deliveryMan!.vehicleType ?? '';
      _statusController.text = widget.deliveryMan!.status ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: _isEditMode ? 'Edit Delivery Man' : 'Add Delivery Man',
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: BlocListener<CreateDeliveryBloc, CreateDeliveryState>(
        listener: (context, state) {
          if (state is CreateDeliverySuccess) {
            customToast(msg: 'Delivery man added successfully');
            Navigator.of(context).pop();
          }
          if (state is CreateDeliveryError) {
            customToast(msg: state.message);
          }
        },
        child: BlocListener<UpdateDeliveryBloc, UpdateDeliveryState>(
          listener: (context, state) {
            if (state is UpdateDeliverySuccess) {
              customToast(msg: 'Delivery man updated successfully');
              Navigator.of(context).pop();
            }
            if (state is UpdateDeliveryError) {
              customToast(msg: state.message);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppPadding.p16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    title: 'Name',
                    hintText: 'Enter name',
                  ),
                  SizedBox(height: AppHeight.s16),
                  CustomTextField(
                    controller: _phoneController,
                    title: 'Phone',
                    hintText: 'Enter phone',
                  ),
                  SizedBox(height: AppHeight.s16),
                  CustomTextField(
                    controller: _emailController,
                    title: 'Email',
                    hintText: 'Enter email',
                  ),
                  SizedBox(height: AppHeight.s16),
                  CustomTextField(
                    controller: _vehicleController,
                    title: 'Vehicle Type',
                    hintText: 'e.g. Motorcycle, Bicycle, Car',
                  ),
                  SizedBox(height: AppHeight.s16),
                  CustomTextField(
                    controller: _statusController,
                    title: 'Status',
                    hintText: 'e.g. active, inactive',
                  ),
                  SizedBox(height: AppHeight.s24),
                  BlocBuilder<CreateDeliveryBloc, CreateDeliveryState>(
                    builder: (context, createState) {
                      return BlocBuilder<UpdateDeliveryBloc,
                          UpdateDeliveryState>(
                        builder: (context, updateState) {
                          final isLoading = createState is CreateDeliveryLoading ||
                              updateState is UpdateDeliveryLoading;
                          return CustomButton(
                            text: _isEditMode ? 'Update' : 'Add',
                            onPressed: isLoading ? null : _submit,
                            isLoading: isLoading,
                          );
                        },
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
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      customToast(msg: 'Please enter name');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      customToast(msg: 'Please enter phone');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      customToast(msg: 'Please enter email');
      return;
    }

    if (_isEditMode) {
      context.read<UpdateDeliveryBloc>().add(
            UpdateDeliverySubmitted(
              id: widget.deliveryMan!.id,
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              vehicleType: _vehicleController.text.trim().isEmpty
                  ? null
                  : _vehicleController.text.trim(),
              status: _statusController.text.trim().isEmpty
                  ? null
                  : _statusController.text.trim(),
            ),
          );
    } else {
      context.read<CreateDeliveryBloc>().add(
            CreateDeliverySubmitted(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              vehicleType: _vehicleController.text.trim().isEmpty
                  ? null
                  : _vehicleController.text.trim(),
              status: _statusController.text.trim().isEmpty
                  ? null
                  : _statusController.text.trim(),
            ),
          );
    }
  }
}
