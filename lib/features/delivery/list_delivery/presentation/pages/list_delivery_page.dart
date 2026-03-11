import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/delivery_list_item.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/search_delivery_widget.dart';

class ListDeliveryPage extends StatefulWidget {
  const ListDeliveryPage({super.key});

  @override
  State<ListDeliveryPage> createState() => _ListDeliveryPageState();
}

class _ListDeliveryPageState extends State<ListDeliveryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ListDeliveryBloc>().add(const GetDeliveryMenEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<ListDeliveryBloc>().state;
      if (state is ListDeliveryLoaded && state.hasMore) {
        setState(() => _isLoadingMore = true);
        context.read<ListDeliveryBloc>().add(
          GetDeliveryMenEvent(loadMore: true, search: state.search),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.deliveryMen),

      body: Column(
        children: [
          const SearchDeliveryWidget(),
          Expanded(
            child: BlocConsumer<ListDeliveryBloc, ListDeliveryState>(
              listener: (context, state) {
                if (state is ListDeliveryLoaded || state is ListDeliveryError) {
                  setState(() => _isLoadingMore = false);
                }
              },
              builder: (context, state) {
                return BlocStateHandler<ListDeliveryBloc, ListDeliveryState>(
                  bloc: context.read<ListDeliveryBloc>(),
                  isLoading: (s) => s is ListDeliveryLoading,
                  isError: (s) => s is ListDeliveryError,
                  getErrorMessage: (s) => (s as ListDeliveryError).message,
                  isSuccess: (s) =>
                      s is ListDeliveryLoaded || s is ListDeliveryLoadingMore,
                  isEmpty: (s) {
                    if (s is ListDeliveryLoaded) return s.deliveryMen.isEmpty;
                    if (s is ListDeliveryLoadingMore) return s.deliveryMen.isEmpty;
                    return false;
                  },
                  emptyMessage: AppTranslation.noDeliveryMenFound,
                  getRetryCallback: (_) => () => context
                      .read<ListDeliveryBloc>()
                      .add(const GetDeliveryMenEvent()),
                  getEmptyRetryCallback: (_) => () => context
                      .read<ListDeliveryBloc>()
                      .add(const GetDeliveryMenEvent()),
                  successBuilder: (context, deliveryState) {
                    final deliveryMen = deliveryState is ListDeliveryLoaded
                        ? deliveryState.deliveryMen
                        : (deliveryState as ListDeliveryLoadingMore).deliveryMen;
                    final hasMore = deliveryState is ListDeliveryLoaded
                        ? deliveryState.hasMore
                        : false;
                    final search = deliveryState is ListDeliveryLoaded
                        ? deliveryState.search
                        : (deliveryState as ListDeliveryLoadingMore).search;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ListDeliveryBloc>().add(
                              GetDeliveryMenEvent(search: search),
                            );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                        itemCount: deliveryMen.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == deliveryMen.length) {
                            return Padding(
                              padding: EdgeInsets.all(AppPadding.p16),
                              child: const CustomCircleIndicator(),
                            );
                          }
                          return DeliveryListItem(
                            deliveryMan: deliveryMen[index],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.navigateTo(context, Routes.addDelivery);
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
