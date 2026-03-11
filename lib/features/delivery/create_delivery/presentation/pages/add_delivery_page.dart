import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/models/delivery_form_controllers.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/models/delivery_form_values.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/widgets/add_delivery_bloc_layer.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/widgets/create_delivery_form.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/widgets/delivery_image_section.dart';

class AddDeliveryPage extends StatefulWidget {
  final DeliveryManEntity? deliveryMan;

  const AddDeliveryPage({super.key, this.deliveryMan});

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = DeliveryFormControllers();
  String? _imagePath;
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;

  bool get _isEditMode => widget.deliveryMan != null;

  /// Image to display: newly picked file path, or existing URL in edit mode.
  String? get _displayImage =>
      _imagePath ?? (widget.deliveryMan?.image?.isNotEmpty == true
          ? widget.deliveryMan!.image
          : null);

  Future<void> _pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null && mounted) setState(() => _imagePath = xFile.path);
  }

  @override
  void initState() {
    super.initState();
    if (_isEditMode && widget.deliveryMan != null) {
      _controllers.fillFrom(
        name: widget.deliveryMan!.name,
        phone: widget.deliveryMan!.phone,
        email: widget.deliveryMan!.email,
      );
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _handleSubmit(DeliveryFormValues values) {
    if (_isEditMode && widget.deliveryMan != null) {
      context.read<UpdateDeliveryBloc>().add(
            UpdateDeliverySubmitted(
              id: widget.deliveryMan!.id,
              firstName: values.firstName,
              lastName: values.lastName,
              phone: values.phone,
              email: values.email,
              address: values.address,
              birthday: values.birthday,
              imagePath: values.imagePath,
              countryId: values.countryId,
              cityId: values.cityId,
            ),
          );
    } else {
      context.read<CreateDeliveryBloc>().add(
            CreateDeliverySubmitted(
              firstName: values.firstName,
              lastName: values.lastName,
              phone: values.phone,
              email: values.email,
              password: values.password,
              notificationChannel: 'WHATSAPP',
              address: values.address,
              birthday: values.birthday,
              imagePath: values.imagePath,
              countryId: values.countryId,
              cityId: values.cityId,
            ),
          );
    }
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

  @override
  Widget build(BuildContext context) {
    return AddDeliveryBlocLayer(
      builder: (context, isLoading) => ModalProgressHUD(
        progressIndicator: const CustomCircleIndicator(),
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(
            title: _isEditMode
                ? AppTranslation.editDeliveryMan
                : AppTranslation.addDeliveryMan,
            actions: _isEditMode
                ? [
                    IconButton(
                      icon: Icon(Icons.delete, color: ColorManager.error),
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  ]
                : null,
          ),
          body: Column(
            children: [
              DeliveryImageSection(
                imagePath: _displayImage,
                onPickImage: _pickImage,
                onClearImage: () => setState(() => _imagePath = null),
              ),
              Expanded(
                child: CreateDeliveryForm(
                  isEdit: _isEditMode,
                  deliveryManId: widget.deliveryMan?.id,
                  controllers: _controllers,
                  imagePath: _imagePath,
                  selectedCountry: _selectedCountry,
                  selectedCity: _selectedCity,
                  onCountryChanged: (c) => setState(() => _selectedCountry = c),
                  onCityChanged: (c) => setState(() => _selectedCity = c),
                  formKey: _formKey,
                  onSubmit: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
