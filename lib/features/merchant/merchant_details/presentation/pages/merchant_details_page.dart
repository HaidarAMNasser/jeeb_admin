import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
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

class MerchantDetailsPage extends StatefulWidget {
  final String merchantId;

  const MerchantDetailsPage({super.key, required this.merchantId});

  @override
  State<MerchantDetailsPage> createState() => _MerchantDetailsPageState();
}

class _MerchantDetailsPageState extends State<MerchantDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteMerchantBloc, DeleteMerchantState>(
      listener: (context, deleteState) {
        if (deleteState is DeleteMerchantSuccess) {
          customToast(msg: AppTranslation.merchantDeletedSuccessfully);
          AppRouter.navigateTo(context, Routes.merchants);
        } else if (deleteState is DeleteMerchantError) {
          customToast(msg: deleteState.message);
        }
      },
      builder: (context, deleteState) {
        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: deleteState is DeleteMerchantLoading,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: CustomAppBar(
              title: AppTranslation.merchantDetails,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, color: ColorManager.primary),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
              ],
            ),
            body: BlocStateHandler<MerchantDetailsBloc, MerchantDetailsState>(
              bloc: context.read<MerchantDetailsBloc>(),
              isLoading: (state) => state is MerchantDetailsLoading,
              isError: (state) => state is MerchantDetailsError,
              getErrorMessage: (state) => (state as MerchantDetailsError).message,
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
