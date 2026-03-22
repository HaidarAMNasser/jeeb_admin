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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (!_isBottom) return;
    final state = context.read<ListDeliveryBloc>().state;
    if (state is! ListDeliveryLoaded) return;
    if (!state.hasMore || state.isLoadingMore) return;
    context.read<ListDeliveryBloc>().add(
          GetDeliveryMenEvent(loadMore: true, search: state.search),
        );
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
            child: BlocBuilder<ListDeliveryBloc, ListDeliveryState>(
              builder: (context, state) {
                return BlocStateHandler<ListDeliveryBloc, ListDeliveryState>(
                  bloc: context.read<ListDeliveryBloc>(),
                  isLoading: (s) => s is ListDeliveryLoading,
                  isError: (s) => s is ListDeliveryError,
                  getErrorMessage: (s) => (s as ListDeliveryError).message,
                  isSuccess: (s) => s is ListDeliveryLoaded,
                  isEmpty: (s) {
                    if (s is ListDeliveryLoaded) {
                      return s.deliveryMen.isEmpty && !s.isLoadingMore;
                    }
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
                    final s = deliveryState as ListDeliveryLoaded;
                    final deliveryMen = s.deliveryMen;
                    final isLoadingMore = s.isLoadingMore;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ListDeliveryBloc>().add(
                              GetDeliveryMenEvent(search: s.search),
                            );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                        itemCount:
                            deliveryMen.length + (isLoadingMore ? 1 : 0),
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
