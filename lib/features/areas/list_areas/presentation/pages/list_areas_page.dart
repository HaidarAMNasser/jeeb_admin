import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/areas/delete_area/presentation/bloc/delete_area_bloc.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/bloc/list_areas_bloc.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/widgets/area_list_item.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/widgets/search_areas_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ListAreasPage extends StatefulWidget {
  const ListAreasPage({super.key});

  @override
  State<ListAreasPage> createState() => _ListAreasPageState();
}

class _ListAreasPageState extends State<ListAreasPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    final state = context.read<ListAreasBloc>().state;
    if (state is! ListAreasLoaded) return;
    if (!state.hasMore || state.isLoadingMore) return;
    context.read<ListAreasBloc>().add(
          GetAreasEvent(
            loadMore: true,
            search: state.search,
          ),
        );
  }

  void _showDeleteConfirmation(AreaEntity area) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteArea,
      confirmText: AppTranslation.delete,
      cancelText: AppTranslation.cancel,
      confirmColor: ColorManager.primary,
      onConfirm: () {
        context.read<DeleteAreaBloc>().add(
              DeleteAreaSubmitted(areaId: area.id),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAreaBloc, DeleteAreaState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is DeleteAreaSuccess || s is DeleteAreaError,
      ),
      listener: (context, deleteState) {
        if (deleteState is DeleteAreaSuccess) {
          customToast(msg: AppTranslation.areaDeletedSuccessfully);
          context.read<ListAreasBloc>().add(const GetAreasEvent());
        } else if (deleteState is DeleteAreaError) {
          customToast(msg: deleteState.message);
        }
      },
      child: BlocBuilder<DeleteAreaBloc, DeleteAreaState>(
        builder: (context, deleteState) {
          return ModalProgressHUD(
            progressIndicator: const CustomCircleIndicator(),
            inAsyncCall: deleteState is DeleteAreaLoading,
            child: Scaffold(
              backgroundColor: ColorManager.background,
              appBar: CustomAppBar(title: AppTranslation.areas),
              body: BlocBuilder<ListAreasBloc, ListAreasState>(
                builder: (context, state) {
                  return BlocStateHandler<ListAreasBloc, ListAreasState>(
                    bloc: context.read<ListAreasBloc>(),
                    isLoading: (state) => state is ListAreasLoading,
                    isError: (state) => state is ListAreasError,
                    getErrorMessage: (state) =>
                        (state as ListAreasError).message,
                    isSuccess: (state) => state is ListAreasLoaded,
                    isEmpty: (state) {
                      if (state is ListAreasLoaded) {
                        return state.areas.isEmpty && !state.isLoadingMore;
                      }
                      return false;
                    },
                    emptyMessage: AppTranslation.noAreasFound,
                    getRetryCallback: (state) => () {
                      context.read<ListAreasBloc>().add(const GetAreasEvent());
                    },
                    getEmptyRetryCallback: (state) => () {
                      context.read<ListAreasBloc>().add(const GetAreasEvent());
                    },
                    successBuilder: (context, areaState) {
                      final s = areaState as ListAreasLoaded;
                      final areas = s.areas;
                      final isLoadingMore = s.isLoadingMore;
                      final currentSearch = s.search;

                      return Column(
                        children: [
                          SearchAreasWidget(initialSearch: currentSearch),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                context.read<ListAreasBloc>().add(
                                      GetAreasEvent(search: currentSearch),
                                    );
                              },
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.all(AppPadding.p16),
                                itemCount:
                                    areas.length + (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == areas.length) {
                                    return Padding(
                                      padding: EdgeInsets.all(AppPadding.p16),
                                      child: const CustomCircleIndicator(),
                                    );
                                  }
                                  final area = areas[index];
                                  return AreaListItem(
                                    area: area,
                                    onDelete: () =>
                                        _showDeleteConfirmation(area),
                                  );
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
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.primary,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.addArea);
                },
                child: Icon(Icons.add, color: ColorManager.surface),
              ),
            ),
          );
        },
      ),
    );
  }
}
