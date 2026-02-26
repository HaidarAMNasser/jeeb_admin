import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/widgets/merchant_details_content.dart';

class MerchantDetailsPage extends StatefulWidget {
  final String merchantId;

  const MerchantDetailsPage({super.key, required this.merchantId});

  @override
  State<MerchantDetailsPage> createState() => _MerchantDetailsPageState();
}

class _MerchantDetailsPageState extends State<MerchantDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load merchant details
    context.read<MerchantDetailsBloc>().add(
          GetMerchantDetailsEvent(id: widget.merchantId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: AppTranslation.merchantDetails,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
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
          return MerchantDetailsContent(merchant: loadedState.merchant);
        },
      ),
    );
  }
}
