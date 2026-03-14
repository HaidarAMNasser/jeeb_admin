import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/offer/list_offer/presentation/bloc/list_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/presentation/widgets/offer_list_item.dart';
import 'package:jeeb_admin/features/offer/list_offer/presentation/widgets/search_offer_widget.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_entity.dart';

class ListOfferPage extends StatefulWidget {
  const ListOfferPage({super.key});

  @override
  State<ListOfferPage> createState() => _ListOfferPageState();
}

class _ListOfferPageState extends State<ListOfferPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load is triggered by route when bloc is created
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<OfferEntity> _filterOffers(List<OfferEntity> offers, String query) {
    if (query.trim().isEmpty) return offers;
    final lower = query.trim().toLowerCase();
    return offers.where((o) => (o.name ?? '').toLowerCase().contains(lower)).toList();
  }

  void _onScroll() {
    final state = context.read<ListOfferBloc>().state;
    if (state is ListOfferLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (state is ListOfferLoaded && state.hasMore) {
        context.read<ListOfferBloc>().add(GetOffersEvent(loadMore: true, merchantId: state.merchantId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.offers),
      body: BlocBuilder<ListOfferBloc, ListOfferState>(
        builder: (context, state) {
          return BlocStateHandler<ListOfferBloc, ListOfferState>(
            bloc: context.read<ListOfferBloc>(),
            isLoading: (s) => s is ListOfferLoading,
            isError: (s) => s is ListOfferError,
            getErrorMessage: (s) => (s as ListOfferError).message,
            isSuccess: (s) =>
                s is ListOfferLoaded || s is ListOfferLoadingMore,
            isEmpty: (s) {
              if (s is ListOfferLoaded) return s.offers.isEmpty;
              if (s is ListOfferLoadingMore) return s.offers.isEmpty;
              return false;
            },
            emptyMessage: AppTranslation.noOffersFound,
            getRetryCallback: (_) => () {
              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
              final merchantId = args?['merchantId'] as String?;
              context.read<ListOfferBloc>().add(GetOffersEvent(merchantId: merchantId));
            },
            getEmptyRetryCallback: (_) => () {
              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
              final merchantId = args?['merchantId'] as String?;
              context.read<ListOfferBloc>().add(GetOffersEvent(merchantId: merchantId));
            },
            successBuilder: (context, offerState) {
              final offers = offerState is ListOfferLoaded
                  ? offerState.offers
                  : (offerState as ListOfferLoadingMore).offers;
              final hasMore = offerState is ListOfferLoaded
                  ? offerState.hasMore
                  : false;
              final filteredOffers = _filterOffers(offers, _searchQuery);

              return Column(
                children: [
                  SearchOfferWidget(
                    controller: _searchController,
                    onSearchChanged: (query) => setState(() => _searchQuery = query),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                        final merchantId = args?['merchantId'] as String?;
                        context.read<ListOfferBloc>().add(GetOffersEvent(merchantId: merchantId));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(AppPadding.p16),
                        itemCount: filteredOffers.length + (hasMore && _searchQuery.isEmpty ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredOffers.length) {
                            return Padding(
                              padding: EdgeInsets.all(AppPadding.p16),
                              child: const CustomCircleIndicator(),
                            );
                          }
                          return OfferListItem(offer: filteredOffers[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: di.sl<StorageService>().getUserRole(),
        builder: (context, snapshot) {
          final isAdmin = snapshot.data?.toLowerCase() == UserRole.admin.name;
          if (isAdmin) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: ColorManager.primary,
            onPressed: () {
              Navigator.pushNamed(context, Routes.addOffer);
            },
            child: Icon(Icons.add, color: ColorManager.surface),
          );
        },
      ),
    );
  }
}
