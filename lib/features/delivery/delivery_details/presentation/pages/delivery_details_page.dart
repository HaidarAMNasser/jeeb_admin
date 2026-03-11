import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/widgets.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/delivery/confirm_delivery/presentation/bloc/confirm_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/presentation/bloc/delivery_details_bloc.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/presentation/widgets/delivery_details_options_dialog.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/presentation/widgets/delivery_details_content.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// Delivery tab index in admin bottom nav (Merchants=0, Orders=1, Delivery=2, Profile=3).
const int _kDeliveryTabIndex = 2;

void _goToMainWithDeliveryTab(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    Routes.mainNavigation,
    (_) => false,
    arguments: {'tabIndex': _kDeliveryTabIndex},
  );
}

class DeliveryDetailsPage extends StatefulWidget {
  final String deliveryManId;

  const DeliveryDetailsPage({super.key, required this.deliveryManId});

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteDeliveryBloc, DeleteDeliveryState>(
          listener: (context, state) {
            if (state is DeleteDeliverySuccess) {
              customToast(msg: AppTranslation.deliveryManDeletedSuccessfully);
              _goToMainWithDeliveryTab(context);
            }
            if (state is DeleteDeliveryError) {
              customToast(msg: state.message);
            }
          },
        ),
        BlocListener<ConfirmDeliveryBloc, ConfirmDeliveryState>(
          listener: (context, state) {
            if (state is ConfirmDeliverySuccess) {
              customToast(msg: AppTranslation.deliveryManConfirmedSuccessfully);
              _goToMainWithDeliveryTab(context);
            }
            if (state is ConfirmDeliveryError) {
              customToast(msg: state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<ConfirmDeliveryBloc, ConfirmDeliveryState>(
        builder: (context, confirmState) {
          return BlocBuilder<DeleteDeliveryBloc, DeleteDeliveryState>(
            builder: (context, deleteState) {
              return ModalProgressHUD(
                progressIndicator: const CustomCircleIndicator(),
                inAsyncCall:
                    confirmState is ConfirmDeliveryLoading ||
                    deleteState is DeleteDeliveryLoading,
                child: Scaffold(
                  backgroundColor: ColorManager.background,
                  appBar: CustomAppBar(
                    title: AppTranslation.deliveryManDetails,
                    onBackPressed: () => _goToMainWithDeliveryTab(context),
                    actions: [_buildOptionsButton(context)],
                  ),
                  body: BlocStateHandler<DeliveryDetailsBloc, DeliveryDetailsState>(
                    bloc: context.read<DeliveryDetailsBloc>(),
                    isLoading: (state) => state is DeliveryDetailsLoading,
                    isError: (state) => state is DeliveryDetailsError,
                    getErrorMessage: (state) =>
                        (state as DeliveryDetailsError).message,
                    isSuccess: (state) => state is DeliveryDetailsLoaded,
                    getRetryCallback: (_) => () => context
                        .read<DeliveryDetailsBloc>()
                        .add(GetDeliveryManDetailsEvent(id: widget.deliveryManId)),
                    successBuilder: (context, detailsState) {
                      final loadedState = detailsState as DeliveryDetailsLoaded;
                      return SingleChildScrollView(
                        child: DeliveryDetailsContent(
                          deliveryMan: loadedState.deliveryMan,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOptionsButton(BuildContext context) {
    return BlocBuilder<DeliveryDetailsBloc, DeliveryDetailsState>(
      builder: (context, state) {
        if (state is! DeliveryDetailsLoaded) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: Icon(Icons.more_vert, color: ColorManager.titlesColor),
          onPressed: () => DeliveryDetailsOptionsDialog.show(
            context: context,
            showConfirm: !state.deliveryMan.confirmed,
            onEdit: () {
              AppRouter.navigateTo(
                context,
                Routes.addDelivery,
                arguments: {'deliveryMan': state.deliveryMan},
              );
            },
            onDelete: () => _showDeleteConfirmation(context),
            onConfirm: () => context.read<ConfirmDeliveryBloc>().add(
              ConfirmDeliverySubmitted(deliveryManId: widget.deliveryManId),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteDeliveryMan,
      confirmText: AppTranslation.delete,
      cancelText: AppTranslation.cancel,
      confirmColor: ColorManager.primary,
      onConfirm: () {
        context.read<DeleteDeliveryBloc>().add(
          DeleteDeliverySubmitted(deliveryManId: widget.deliveryManId),
        );
      },
    );
  }
}
