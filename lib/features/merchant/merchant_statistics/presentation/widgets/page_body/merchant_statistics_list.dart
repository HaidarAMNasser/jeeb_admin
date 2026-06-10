import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/empty_state_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/bloc/merchant_statistics_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/card/merchant_statistics_card.dart';

class MerchantStatisticsList extends StatelessWidget {
  const MerchantStatisticsList({
    super.key,
    required this.scrollController,
    required this.onApplyFilters,
  });

  final ScrollController scrollController;
  final VoidCallback onApplyFilters;

  @override
  Widget build(BuildContext context) {
    return BlocStateHandler<MerchantStatisticsBloc, MerchantStatisticsState>(
      bloc: context.read<MerchantStatisticsBloc>(),
      isLoading: (state) => state is MerchantStatisticsLoading,
      isError: (state) => state is MerchantStatisticsError,
      getErrorMessage: (state) => (state as MerchantStatisticsError).message,
      isSuccess: (state) => state is MerchantStatisticsLoaded,
      getRetryCallback: (_) => onApplyFilters,
      successBuilder: (context, state) {
        final loaded = state as MerchantStatisticsLoaded;
        if (loaded.items.isEmpty) {
          return EmptyStateWidget(
            message: AppTranslation.noMerchantStatisticsFound,
            onPress: onApplyFilters,
          );
        }
        return RefreshIndicator(
          onRefresh: () async => onApplyFilters(),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
            itemCount: loaded.items.length + (loaded.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == loaded.items.length) {
                return Padding(
                  padding: EdgeInsets.all(AppPadding.p16),
                  child: const CustomCircleIndicator(),
                );
              }
              return MerchantStatisticsCard(item: loaded.items[index]);
            },
          ),
        );
      },
    );
  }
}
