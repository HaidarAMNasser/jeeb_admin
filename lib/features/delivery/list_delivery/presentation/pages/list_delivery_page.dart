import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/delivery_list_item.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/search_delivery_widget.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';

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
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: AppTranslation.deliveryMen,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              AppRouter.navigateTo(context, Routes.addDelivery);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchDeliveryWidget(),
          Expanded(
            child: BlocConsumer<ListDeliveryBloc, ListDeliveryState>(
              listener: (context, state) {
                if (state is ListDeliveryLoaded ||
                    state is ListDeliveryError) {
                  setState(() => _isLoadingMore = false);
                }
              },
              builder: (context, state) {
                final fakeDeliveryMen = _generateFakeDeliveryMen();
                return RefreshIndicator(
                  onRefresh: () async {
                    final state = context.read<ListDeliveryBloc>().state;
                    String? searchQuery;
                    if (state is ListDeliveryLoaded) {
                      searchQuery = state.search;
                    } else if (state is ListDeliveryLoadingMore) {
                      searchQuery = state.search;
                    }
                    context.read<ListDeliveryBloc>().add(
                          GetDeliveryMenEvent(search: searchQuery),
                        );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                    itemCount: fakeDeliveryMen.length,
                    itemBuilder: (context, index) {
                      return DeliveryListItem(
                        deliveryMan: fakeDeliveryMen[index],
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
    final vehicles = ['Motorcycle', 'Bicycle', 'Car', 'Van'];
    final statuses = ['active', 'inactive', 'busy'];

    return List.generate(25, (index) {
      final nameIndex = index % names.length;
      return DeliveryManEntity(
        id: '${index + 1}',
        name: names[nameIndex],
        phone: '+961 ${3 + (index % 7)}${1000000 + index}',
        email: '${names[nameIndex].toLowerCase().replaceAll(' ', '_')}@delivery.com',
        vehicleType: vehicles[index % vehicles.length],
        status: statuses[index % statuses.length],
      );
    });
  }
}
