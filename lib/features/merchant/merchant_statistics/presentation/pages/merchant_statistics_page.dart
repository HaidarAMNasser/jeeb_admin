import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/empty_state_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/bloc/merchant_statistics_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/merchant_statistics_card.dart';

class MerchantStatisticsPage extends StatefulWidget {
  const MerchantStatisticsPage({super.key});

  @override
  State<MerchantStatisticsPage> createState() => _MerchantStatisticsPageState();
}

class _MerchantStatisticsPageState extends State<MerchantStatisticsPage> {
  final _searchController = TextEditingController();
  final _merchantIdController = TextEditingController();
  final _scrollController = ScrollController();
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<MerchantStatisticsBloc>().add(
          const GetMerchantStatisticsEvent(),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _merchantIdController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent * 0.9) return;
    final state = context.read<MerchantStatisticsBloc>().state;
    if (state is MerchantStatisticsLoaded && state.pagination.hasNextPage) {
      context.read<MerchantStatisticsBloc>().add(
            GetMerchantStatisticsEvent(
              loadMore: true,
              search: state.search,
              from: state.from,
              to: state.to,
              merchantId: state.merchantId,
            ),
          );
    }
  }

  String? _isoDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _applyFilters() {
    final query = _searchController.text.trim();
    final merchantId = int.tryParse(_merchantIdController.text.trim());
    context.read<MerchantStatisticsBloc>().add(
          GetMerchantStatisticsEvent(
            search: query.isEmpty ? null : query,
            from: _isoDate(_from),
            to: _isoDate(_to),
            merchantId: merchantId,
          ),
        );
  }

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _searchController.clear();
      _merchantIdController.clear();
    });
    context.read<MerchantStatisticsBloc>().add(
          const GetMerchantStatisticsEvent(),
        );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final current = isFrom ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.merchantStatistics),
      body: Column(
        children: [
          CustomSearchField(
            hintText: AppTranslation.searchMerchantsHint,
            controller: _searchController,
            onSubmitted: (_) => _applyFilters(),
            onRefetch: _clearFilters,
          ),
          _DateFilterBar(
            from: _from,
            to: _to,
            onPickFrom: () => _pickDate(isFrom: true),
            onPickTo: () => _pickDate(isFrom: false),
            onClear: _clearFilters,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppPadding.p16,
              0,
              AppPadding.p16,
              AppPadding.p12,
            ),
            child: CustomTextField(
              hintText: AppTranslation.merchantUserId,
              controller: _merchantIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              prefixIcon: Icon(Icons.badge_outlined, color: ColorManager.primary),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),
          Expanded(
            child: BlocStateHandler<MerchantStatisticsBloc,
                MerchantStatisticsState>(
              bloc: context.read<MerchantStatisticsBloc>(),
              isLoading: (state) => state is MerchantStatisticsLoading,
              isError: (state) => state is MerchantStatisticsError,
              getErrorMessage: (state) =>
                  (state as MerchantStatisticsError).message,
              isSuccess: (state) => state is MerchantStatisticsLoaded,
              getRetryCallback: (_) => _applyFilters,
              successBuilder: (context, state) {
                final loaded = state as MerchantStatisticsLoaded;
                if (loaded.items.isEmpty) {
                  return EmptyStateWidget(
                    message: AppTranslation.noMerchantStatisticsFound,
                    onPress: _applyFilters,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => _applyFilters(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                    itemCount:
                        loaded.items.length + (loaded.isLoadingMore ? 1 : 0),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onClear;

  const _DateFilterBar({
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd');
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16,
        0,
        AppPadding.p16,
        AppPadding.p12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateChip(
              label: from == null
                  ? AppTranslation.fromDate
                  : format.format(from!),
              onTap: onPickFrom,
            ),
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            child: _DateChip(
              label: to == null ? AppTranslation.toDate : format.format(to!),
              onTap: onPickTo,
            ),
          ),
          SizedBox(width: AppWidth.s8),
          IconButton(
            onPressed: onClear,
            icon: Icon(Icons.close, color: ColorManager.defaultWhite),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p10,
          vertical: AppHeight.s12,
        ),
        decoration: BoxDecoration(
          color: ColorManager.defaultWhite,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: ColorManager.primary),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: CustomText(
                text: label,
                textStyle: getMediumStyle(
                  fontSize: AppFontSize.s12,
                  color: ColorManager.productNameColor,
                ),
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
