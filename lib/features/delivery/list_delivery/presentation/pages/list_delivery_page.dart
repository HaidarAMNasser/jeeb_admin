import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
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
                // Real API-based rendering kept here for easy restore after testing.
                // if (state is ListDeliveryLoading) {
                //   return const Center(child: CustomCircleIndicator());
                // }
                //
                // if (state is ListDeliveryError) {
                //   return Center(
                //     child: Padding(
                //       padding: EdgeInsets.all(AppPadding.p16),
                //       child: Text(
                //         state.message,
                //         style: const TextStyle(color: Colors.white),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   );
                // }
                //
                // final deliveryMen = state is ListDeliveryLoaded
                //     ? state.deliveryMen
                //     : state is ListDeliveryLoadingMore
                //         ? state.deliveryMen
                //         : <DeliveryManEntity>[];
                // final hasMore = state is ListDeliveryLoaded ? state.hasMore : false;
                //
                // if (deliveryMen.isEmpty) {
                //   return Center(
                //     child: Text(
                //       AppTranslation.noDeliveryMenFound,
                //       style: const TextStyle(color: Colors.white),
                //     ),
                //   );
                // }

                final deliveryMen = _generateFakeDeliveryMen();
                final itemCount = deliveryMen.length;

                return RefreshIndicator(
                  onRefresh: () async {
                    // final state = context.read<ListDeliveryBloc>().state;
                    // String? searchQuery;
                    // if (state is ListDeliveryLoaded) {
                    //   searchQuery = state.search;
                    // } else if (state is ListDeliveryLoadingMore) {
                    //   searchQuery = state.search;
                    // }
                    // context.read<ListDeliveryBloc>().add(
                    //   GetDeliveryMenEvent(search: searchQuery),
                    // );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return DeliveryListItem(
                        deliveryMan: deliveryMen[index],
                      );
                    },
                  ),
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

  List<DeliveryManEntity> _generateFakeDeliveryMen() {
    final names = [
      'Ahmad Hassan',
      'Mohammad Ali',
      'Omar Khalil',
      'Youssef Ibrahim',
      'Karim Mahmoud',
      'Tarek Nasser',
      'Bassam Saleh',
      'Rami Fadi',
      'Samer George',
      'Walid Hani',
    ];

    return List.generate(25, (index) {
      final nameIndex = index % names.length;
      return DeliveryManEntity(
        id: '${index + 1}',
        name: names[nameIndex],
        phone: '+961 ${3 + (index % 7)}${1000000 + index}',
        email:
            '${names[nameIndex].toLowerCase().replaceAll(' ', '_')}@delivery.com',
        isOnline: index % 2 == 0,
        confirmed: index % 3 == 0,
      );
    });
  }
}
