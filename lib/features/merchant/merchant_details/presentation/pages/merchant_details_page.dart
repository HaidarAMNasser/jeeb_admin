import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/classes/user_roles.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/widgets/merchant_details_content.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/bloc/list_product_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/presentation/bloc/list_offer_bloc.dart';
import 'package:jeeb_admin/features/merchant/delete_merchant/presentation/bloc/delete_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/widgets/merchant_details_options_dialog.dart';

class MerchantDetailsPage extends StatefulWidget {
  final String merchantId;

  const MerchantDetailsPage({super.key, required this.merchantId});

  @override
  State<MerchantDetailsPage> createState() => _MerchantDetailsPageState();
}

class _MerchantDetailsPageState extends State<MerchantDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    // Load merchant details
    context.read<MerchantDetailsBloc>().add(
      GetMerchantDetailsEvent(id: widget.merchantId),
    );
    // Load products for this merchant (preview: first page only, section shows 3 + "Show all")
    context.read<ListProductBloc>().add(
      GetProductsEvent(merchantId: widget.merchantId),
    );
    // Load offers for this merchant (preview: first page only, section shows 3 + "Show all")
    context.read<ListOfferBloc>().add(
      GetOffersEvent(merchantId: widget.merchantId),
    );
  }

  Future<void> _loadUserRole() async {
    final role = await di.sl<StorageService>().getUserRole();
    if (!mounted) return;
    setState(() => _isAdmin = role == UserRoles.admin.name);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteMerchantBloc, DeleteMerchantState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is DeleteMerchantSuccess || s is DeleteMerchantError,
          ),
          listener: (context, deleteState) {
            if (deleteState is DeleteMerchantSuccess) {
              customToast(msg: AppTranslation.merchantDeletedSuccessfully);
              AppRouter.navigateAndRemoveUntil(
                context,
                Routes.mainNavigation,
                arguments: {'tabIndex': 0},
              );
            } else if (deleteState is DeleteMerchantError) {
              customToast(msg: deleteState.message);
            }
          },
        ),
        BlocListener<UpdateMerchantBloc, UpdateMerchantState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is UpdateMerchantSuccess || s is UpdateMerchantError,
          ),
          listener: (context, updateState) {
            if (updateState is UpdateMerchantSuccess) {
              customToast(msg: AppTranslation.merchantUpdatedSuccessfully);
              context.read<MerchantDetailsBloc>().add(
                    GetMerchantDetailsEvent(id: widget.merchantId),
                  );
            } else if (updateState is UpdateMerchantError) {
              customToast(msg: updateState.message);
            }
          },
        ),
      ],
      child: BlocBuilder<DeleteMerchantBloc, DeleteMerchantState>(
        builder: (context, deleteState) {
          return BlocBuilder<UpdateMerchantBloc, UpdateMerchantState>(
            builder: (context, updateState) {
              return ModalProgressHUD(
                progressIndicator: const CustomCircleIndicator(),
                inAsyncCall: deleteState is DeleteMerchantLoading ||
                    updateState is UpdateMerchantLoading,
                child: Scaffold(
                  backgroundColor: ColorManager.background,
                  appBar: CustomAppBar(
                    title: AppTranslation.merchantDetails,
                    actions: [
                      if (_isAdmin) _buildOptionsButton(context),
                    ],
                  ),
                  body: BlocStateHandler<MerchantDetailsBloc, MerchantDetailsState>(
                    bloc: context.read<MerchantDetailsBloc>(),
                    isLoading: (state) => state is MerchantDetailsLoading,
                    isError: (state) => state is MerchantDetailsError,
                    getErrorMessage: (state) =>
                        (state as MerchantDetailsError).message,
                    isSuccess: (state) => state is MerchantDetailsLoaded,
                    getRetryCallback: (state) => () {
                      context.read<MerchantDetailsBloc>().add(
                            GetMerchantDetailsEvent(id: widget.merchantId),
                          );
                    },
                    successBuilder: (context, detailsState) {
                      final loadedState = detailsState as MerchantDetailsLoaded;
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: MerchantDetailsContent(
                          merchant: loadedState.merchant,
                          merchantId: widget.merchantId,
                          scrollController: _scrollController,
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
    return BlocBuilder<MerchantDetailsBloc, MerchantDetailsState>(
      builder: (context, state) {
        if (state is! MerchantDetailsLoaded) return const SizedBox.shrink();
        final hidePhoneNumber = state.merchant.hidePhoneNumber ?? false;
        final isActive = state.merchant.isActive;

        return IconButton(
          icon: Icon(Icons.more_vert, color: ColorManager.titlesColor),
          onPressed: () => MerchantDetailsOptionsDialog.show(
            context: context,
            hidePhoneNumber: hidePhoneNumber,
            merchantIsActive: isActive,
            onEdit: () {
              AppRouter.navigateTo(
                context,
                Routes.editMerchant,
                arguments: {'merchantId': widget.merchantId},
              );
            },
            onDelete: () => _showDeleteConfirmation(context),
            onTogglePhoneVisibility: () {
              context.read<UpdateMerchantBloc>().add(
                    UpdateMerchantSubmitted(
                      id: widget.merchantId,
                      hidePhoneNumber: !hidePhoneNumber,
                    ),
                  );
            },
            onToggleMerchantActive: () {
              if (isActive == null) return;
              context.read<UpdateMerchantBloc>().add(
                    UpdateMerchantSubmitted(
                      id: widget.merchantId,
                      isActive: !isActive,
                    ),
                  );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteMerchant,
      onConfirm: () {
        context.read<DeleteMerchantBloc>().add(
          DeleteMerchantSubmitted(merchantId: widget.merchantId),
        );
      },
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.primary,
    );
  }
}
