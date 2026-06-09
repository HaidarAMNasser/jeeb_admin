import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/features/areas/area_details/presentation/bloc/area_details_bloc.dart';
import 'package:jeeb_admin/features/areas/create_area/presentation/bloc/create_area_bloc.dart';
import 'package:jeeb_admin/features/areas/create_area/presentation/widgets/create_area_form.dart';
import 'package:jeeb_admin/features/areas/delete_area/presentation/bloc/delete_area_bloc.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/update_area/presentation/bloc/update_area_bloc.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateAreaPage extends StatefulWidget {
  final AreaEntity? area;

  const CreateAreaPage({super.key, this.area});

  @override
  State<CreateAreaPage> createState() => _CreateAreaPageState();
}

class _CreateAreaPageState extends State<CreateAreaPage> {
  @override
  void initState() {
    super.initState();
    if (widget.area != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<AreaDetailsBloc>().add(
                GetAreaDetailsEvent(id: widget.area!.id),
              );
        }
      });
    }
  }

  void _goToAreasList(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.areas,
      (_) => false,
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureDeleteArea,
      onConfirm: () {
        if (widget.area != null) {
          context.read<DeleteAreaBloc>().add(
                DeleteAreaSubmitted(areaId: widget.area!.id),
              );
        }
      },
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.area != null;

    return BlocConsumer<DeleteAreaBloc, DeleteAreaState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is DeleteAreaSuccess || s is DeleteAreaError,
      ),
      listener: (context, deleteState) {
        if (deleteState is DeleteAreaSuccess) {
          customToast(msg: AppTranslation.areaDeletedSuccessfully);
          _goToAreasList(context);
        } else if (deleteState is DeleteAreaError) {
          customToast(msg: deleteState.message);
        }
      },
      builder: (context, deleteState) {
        return BlocConsumer<UpdateAreaBloc, UpdateAreaState>(
          listenWhen: (previous, current) => listenWhenEnteringTerminal(
            previous,
            current,
            (s) => s is UpdateAreaSuccess || s is UpdateAreaError,
          ),
          listener: (context, updateState) {
            if (updateState is UpdateAreaSuccess) {
              customToast(msg: AppTranslation.areaUpdatedSuccessfully);
              _goToAreasList(context);
            } else if (updateState is UpdateAreaError) {
              customToast(msg: updateState.message);
            }
          },
          builder: (context, updateState) {
            return BlocConsumer<CreateAreaBloc, CreateAreaState>(
              listenWhen: (previous, current) => listenWhenEnteringTerminal(
                previous,
                current,
                (s) => s is CreateAreaSuccess || s is CreateAreaError,
              ),
              listener: (context, createState) {
                if (createState is CreateAreaSuccess) {
                  customToast(msg: AppTranslation.areaAddedSuccessfully);
                  _goToAreasList(context);
                } else if (createState is CreateAreaError) {
                  customToast(msg: createState.message);
                }
              },
              builder: (context, createState) {
                return BlocBuilder<DeleteAreaBloc, DeleteAreaState>(
                  builder: (context, deleteStateBuilder) {
                    return ModalProgressHUD(
                      progressIndicator: const CustomCircleIndicator(),
                      inAsyncCall: createState is CreateAreaLoading ||
                          updateState is UpdateAreaLoading ||
                          deleteStateBuilder is DeleteAreaLoading,
                      child: Scaffold(
                        backgroundColor: ColorManager.background,
                        appBar: CustomAppBar(
                          title: isEdit
                              ? AppTranslation.editArea
                              : AppTranslation.addArea,
                          actions: isEdit
                              ? [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: ColorManager.primary,
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context);
                                    },
                                  ),
                                ]
                              : null,
                        ),
                        body: isEdit
                            ? BlocListener<AreaDetailsBloc, AreaDetailsState>(
                                listenWhen: (previous, current) =>
                                    current is AreaDetailsLoaded &&
                                    previous is! AreaDetailsLoaded,
                                listener: (context, areaDetailsState) {
                                  if (areaDetailsState is AreaDetailsLoaded) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        context.read<CreateAreaBloc>().add(
                                              InitializeAreaForm(
                                                area: areaDetailsState.area,
                                              ),
                                            );
                                      }
                                    });
                                  }
                                },
                                child: BlocStateHandler<AreaDetailsBloc,
                                    AreaDetailsState>(
                                  bloc: context.read<AreaDetailsBloc>(),
                                  isLoading: (state) =>
                                      state is AreaDetailsLoading,
                                  isError: (state) =>
                                      state is AreaDetailsError,
                                  getErrorMessage: (state) =>
                                      (state as AreaDetailsError).message,
                                  isSuccess: (state) =>
                                      state is AreaDetailsLoaded,
                                  getRetryCallback: (state) => () {
                                    context.read<AreaDetailsBloc>().add(
                                          GetAreaDetailsEvent(
                                            id: widget.area!.id,
                                          ),
                                        );
                                  },
                                  successBuilder:
                                      (context, areaDetailsState) {
                                    return CreateAreaForm(
                                      bloc: context.read<CreateAreaBloc>(),
                                      state: createState,
                                      isEdit: true,
                                    );
                                  },
                                ),
                              )
                            : _buildCreateView(createState),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCreateView(CreateAreaState state) {
    return BlocBuilder<CreateAreaBloc, CreateAreaState>(
      builder: (context, blocState) {
        final bloc = context.read<CreateAreaBloc>();
        return CreateAreaForm(
          bloc: bloc,
          state: blocState,
          isEdit: false,
        );
      },
    );
  }
}
