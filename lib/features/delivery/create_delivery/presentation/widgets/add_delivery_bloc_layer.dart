import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';

/// Delivery tab index in admin bottom nav (Merchants=0, Orders=1, Delivery=2, Profile=3).
const int _kDeliveryTabIndex = 2;

void _goToMainWithDeliveryTab(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    Routes.mainNavigation,
    (_) => false,
    arguments: {'tabIndex': _kDeliveryTabIndex},
  );
}

/// Wraps [child] with listeners for Create/Update/Delete delivery blocs and
/// provides [isLoading] to the builder so the parent can show a loading overlay.
class AddDeliveryBlocLayer extends StatelessWidget {
  final Widget Function(BuildContext context, bool isLoading) builder;

  const AddDeliveryBlocLayer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDeliveryBloc, CreateDeliveryState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is CreateDeliverySuccess || s is CreateDeliveryError,
      ),
      listener: (context, state) {
        if (state is CreateDeliverySuccess) {
          customToast(msg: AppTranslation.deliveryManCreatedSuccessfully);
          _goToMainWithDeliveryTab(context);
        } else if (state is CreateDeliveryError) {
          customToast(msg: state.message);
        }
      },
      child: BlocListener<UpdateDeliveryBloc, UpdateDeliveryState>(
        listenWhen: (previous, current) => listenWhenEnteringTerminal(
          previous,
          current,
          (s) => s is UpdateDeliverySuccess || s is UpdateDeliveryError,
        ),
        listener: (context, state) {
          if (state is UpdateDeliverySuccess) {
            customToast(msg: AppTranslation.deliveryManUpdatedSuccessfully);
            _goToMainWithDeliveryTab(context);
          } else if (state is UpdateDeliveryError) {
            customToast(msg: state.message);
          }
        },
        child: BlocListener<DeleteDeliveryBloc, DeleteDeliveryState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is DeleteDeliverySuccess || s is DeleteDeliveryError,
          ),
          listener: (context, state) {
            if (state is DeleteDeliverySuccess) {
              customToast(msg: AppTranslation.deliveryManDeletedSuccessfully);
              _goToMainWithDeliveryTab(context);
            } else if (state is DeleteDeliveryError) {
              customToast(msg: state.message);
            }
          },
          child: BlocBuilder<CreateDeliveryBloc, CreateDeliveryState>(
            buildWhen: (a, b) => a is CreateDeliveryLoading || b is CreateDeliveryLoading,
            builder: (context, createState) {
              return BlocBuilder<UpdateDeliveryBloc, UpdateDeliveryState>(
                buildWhen: (a, b) => a is UpdateDeliveryLoading || b is UpdateDeliveryLoading,
                builder: (context, updateState) {
                  return BlocBuilder<DeleteDeliveryBloc, DeleteDeliveryState>(
                    buildWhen: (a, b) => a is DeleteDeliveryLoading || b is DeleteDeliveryLoading,
                    builder: (context, deleteState) {
                      final isLoading = createState is CreateDeliveryLoading ||
                          updateState is UpdateDeliveryLoading ||
                          deleteState is DeleteDeliveryLoading;
                      return builder(context, isLoading);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
