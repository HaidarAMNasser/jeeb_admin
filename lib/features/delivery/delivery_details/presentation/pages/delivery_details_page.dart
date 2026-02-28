import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/presentation/widgets/delivery_details_content.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final String deliveryManId;

  const DeliveryDetailsPage({super.key, required this.deliveryManId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteDeliveryBloc, DeleteDeliveryState>(
          listener: (context, state) {
            if (state is DeleteDeliverySuccess) {
              customToast(msg: 'Delivery man deleted successfully');
              Navigator.of(context).pop();
            }
            if (state is DeleteDeliveryError) {
              customToast(msg: state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          title: CustomText(
            text: 'Delivery Man Details',
            textStyle: getBoldStyle(
              fontSize: AppFontSize.s24,
              color: ColorManager.titlesColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                AppRouter.navigateTo(
                  context,
                  Routes.addDelivery,
                  arguments: {'deliveryMan': _getFakeDeliveryMan()},
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            final fakeDeliveryMan = _getFakeDeliveryMan();
            return SingleChildScrollView(
              child: DeliveryDetailsContent(deliveryMan: fakeDeliveryMan),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: 'Are you sure you want to delete this delivery man?',
      confirmText: AppTranslation.delete,
      cancelText: AppTranslation.cancel,
      confirmColor: Colors.red,
      onConfirm: () {
        context
            .read<DeleteDeliveryBloc>()
            .add(DeleteDeliverySubmitted(deliveryManId: deliveryManId));
      },
    );
  }

  DeliveryManEntity _getFakeDeliveryMan() {
    return DeliveryManEntity(
      id: deliveryManId,
      name: 'Ahmad Hassan',
      phone: '+961 3 1234567',
      email: 'ahmad_hassan@delivery.com',
      cityName: 'Beirut',
      countryName: 'Lebanon',
      isOnline: true,
    );
  }
}
