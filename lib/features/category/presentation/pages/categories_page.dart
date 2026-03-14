import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/features/category/list_category/presentation/bloc/list_category_bloc.dart';
import 'package:jeeb_admin/features/category/add_category/presentation/bloc/add_category_bloc.dart';
import 'package:jeeb_admin/features/category/update_category/presentation/bloc/update_category_bloc.dart';
import 'package:jeeb_admin/features/category/delete_category/presentation/bloc/delete_category_bloc.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/categories_page_body.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/add_category_dialog.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ListCategoryBloc>().add(const GetCategoriesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddCategoryBloc, AddCategoryState>(
          listener: (context, addState) {
            if (addState is AddCategorySuccess) {
              customToast(msg: AppTranslation.categoryAddedSuccessfully);
              context.read<ListCategoryBloc>().add(const GetCategoriesEvent());
            } else if (addState is AddCategoryError) {
              customToast(msg: addState.message);
            }
          },
        ),
        BlocListener<UpdateCategoryBloc, UpdateCategoryState>(
          listener: (context, updateState) {
            if (updateState is UpdateCategorySuccess) {
              customToast(msg: AppTranslation.categoryUpdatedSuccessfully);
              context.read<ListCategoryBloc>().add(const GetCategoriesEvent());
            } else if (updateState is UpdateCategoryError) {
              customToast(msg: updateState.message);
            }
          },
        ),
        BlocListener<DeleteCategoryBloc, DeleteCategoryState>(
          listener: (context, deleteState) {
            if (deleteState is DeleteCategorySuccess) {
              customToast(msg: AppTranslation.categoryDeletedSuccessfully);
              context.read<ListCategoryBloc>().add(const GetCategoriesEvent());
            } else if (deleteState is DeleteCategoryError) {
              customToast(msg: deleteState.message);
            }
          },
        ),
      ],
      child: BlocBuilder<AddCategoryBloc, AddCategoryState>(
        buildWhen: (_, s) => s is AddCategoryLoading || s is AddCategoryInitial || s is AddCategorySuccess || s is AddCategoryError,
        builder: (context, addState) {
          return BlocBuilder<UpdateCategoryBloc, UpdateCategoryState>(
            buildWhen: (_, s) => s is UpdateCategoryLoading || s is UpdateCategoryInitial || s is UpdateCategorySuccess || s is UpdateCategoryError,
            builder: (context, updateState) {
              return BlocBuilder<DeleteCategoryBloc, DeleteCategoryState>(
                buildWhen: (_, s) => s is DeleteCategoryLoading || s is DeleteCategoryInitial || s is DeleteCategorySuccess || s is DeleteCategoryError,
                builder: (context, deleteState) {
                  final isLoading = addState is AddCategoryLoading ||
                      updateState is UpdateCategoryLoading ||
                      deleteState is DeleteCategoryLoading;
                  return ModalProgressHUD(
                    progressIndicator: const CustomCircleIndicator(),
                    inAsyncCall: isLoading,
                    child: Scaffold(
                      backgroundColor: ColorManager.background,
                      appBar: CustomAppBar(title: AppTranslation.categories),
                      body: const CategoriesPageBody(),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () => AddCategoryDialog.show(context),
                        backgroundColor: ColorManager.primary,
                        child: const Icon(Icons.add, color: ColorManager.defaultWhite),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
