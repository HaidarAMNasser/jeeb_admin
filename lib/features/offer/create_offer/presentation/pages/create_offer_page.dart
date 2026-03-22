import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/create_offer_form.dart';
import 'package:jeeb_admin/features/offer/update_offer/presentation/bloc/update_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/delete_offer/presentation/bloc/delete_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_entity.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateOfferPage extends StatefulWidget {
  final OfferEntity? offer;

  const CreateOfferPage({super.key, this.offer});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CreateOfferBloc>().add(
                InitializeOfferForm(offer: widget.offer),
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.offer != null;

    return BlocConsumer<DeleteOfferBloc, DeleteOfferState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is DeleteOfferSuccess || s is DeleteOfferError,
      ),
      listener: (context, deleteState) {
        if (deleteState is DeleteOfferSuccess) {
          customToast(msg: AppTranslation.offerDeletedSuccessfully);
          _goToMainWithOffersTab(context);
        } else if (deleteState is DeleteOfferError) {
          customToast(msg: deleteState.message);
        }
      },
      builder: (context, deleteState) {
        return BlocConsumer<UpdateOfferBloc, UpdateOfferState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is UpdateOfferSuccess || s is UpdateOfferError,
          ),
          listener: (context, updateState) {
            if (updateState is UpdateOfferSuccess) {
              customToast(msg: AppTranslation.offerUpdatedSuccessfully);
              _goToMainWithOffersTab(context);
            } else if (updateState is UpdateOfferError) {
              customToast(msg: updateState.message);
            }
          },
          builder: (context, updateState) {
            return BlocConsumer<CreateOfferBloc, CreateOfferState>(
              listenWhen: (previous, current) => listenWhenEnteringTerminal(
                previous,
                current,
                (s) => s is CreateOfferSuccess || s is CreateOfferError,
              ),
              listener: (context, createState) {
                if (createState is CreateOfferSuccess) {
                  customToast(msg: AppTranslation.offerCreatedSuccessfully);
                  _goToMainWithOffersTab(context);
                } else if (createState is CreateOfferError) {
                  customToast(msg: createState.message);
                }
              },
              builder: (context, createState) {
                return BlocBuilder<DeleteOfferBloc, DeleteOfferState>(
                  builder: (context, deleteBuilderState) {
                    return ModalProgressHUD(
                      progressIndicator: const CustomCircleIndicator(),
                      inAsyncCall:
                          createState is CreateOfferLoading ||
                          updateState is UpdateOfferLoading ||
                          deleteBuilderState is DeleteOfferLoading,
                      child: Scaffold(
                        backgroundColor: ColorManager.background,
                        appBar: CustomAppBar(
                          title: isEdit
                              ? AppTranslation.editOffer
                              : AppTranslation.addOffer,
                          actions: isEdit
                              ? [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: ColorManager.primary,
                                    onPressed: () =>
                                        _showDeleteConfirmation(context),
                                  ),
                                ]
                              : null,
                        ),
                        body: isEdit
                            ? _buildEditForm(createState)
                            : _buildCreateForm(createState),
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

  Widget _buildEditForm(CreateOfferState createState) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      builder: (context, state) {
        return CreateOfferForm(
          bloc: context.read<CreateOfferBloc>(),
          state: state,
          isEdit: true,
          offer: widget.offer,
        );
      },
    );
  }

  Widget _buildCreateForm(CreateOfferState createState) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      builder: (context, state) {
        return CreateOfferForm(
          bloc: context.read<CreateOfferBloc>(),
          state: state,
          isEdit: false,
          offer: null,
        );
      },
    );
  }

  void _goToMainWithOffersTab(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.mainNavigation,
      (_) => false,
      arguments: {'tabIndex': 1},
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteOffer,
      onConfirm: () {
        if (widget.offer != null) {
          context.read<DeleteOfferBloc>().add(
                DeleteOfferSubmitted(offerId: widget.offer!.id),
              );
        }
      },
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.primary,
    );
  }
}
