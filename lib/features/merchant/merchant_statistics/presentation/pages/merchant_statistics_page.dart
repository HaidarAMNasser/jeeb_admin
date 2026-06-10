import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/bloc/merchant_statistics_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/page_body/merchant_statistics_page_body.dart';

class MerchantStatisticsPage extends StatefulWidget {
  const MerchantStatisticsPage({super.key});

  @override
  State<MerchantStatisticsPage> createState() => _MerchantStatisticsPageState();
}

class _MerchantStatisticsPageState extends State<MerchantStatisticsPage> {
  final _searchController = TextEditingController();
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

  ({String? search, int? merchantId}) _parseSearchQuery(String raw) {
    final query = raw.trim();
    if (query.isEmpty) {
      return (search: null, merchantId: null);
    }
    if (RegExp(r'^\d+$').hasMatch(query)) {
      return (search: null, merchantId: int.tryParse(query));
    }
    return (search: query, merchantId: null);
  }

  void _applyFilters() {
    final parsed = _parseSearchQuery(_searchController.text);
    context.read<MerchantStatisticsBloc>().add(
          GetMerchantStatisticsEvent(
            search: parsed.search,
            from: _isoDate(_from),
            to: _isoDate(_to),
            merchantId: parsed.merchantId,
          ),
        );
  }

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _searchController.clear();
    });
    context.read<MerchantStatisticsBloc>().add(
          const GetMerchantStatisticsEvent(),
        );
  }

  void _onFromChanged(DateTime? date) {
    setState(() => _from = date);
    _applyFilters();
  }

  void _onToChanged(DateTime? date) {
    setState(() => _to = date);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.merchantStatistics),
      body: MerchantStatisticsPageBody(
        searchController: _searchController,
        scrollController: _scrollController,
        from: _from,
        to: _to,
        onApplyFilters: _applyFilters,
        onClearFilters: _clearFilters,
        onFromChanged: _onFromChanged,
        onToChanged: _onToChanged,
      ),
    );
  }
}
