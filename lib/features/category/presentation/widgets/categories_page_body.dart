import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/category/list_category/presentation/bloc/list_category_bloc.dart';
import 'package:jeeb_admin/features/category/presentation/widgets/categories_list_body.dart';

class CategoriesPageBody extends StatelessWidget {
  const CategoriesPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListCategoryBloc, ListCategoryState>(
      listener: (context, listState) {
        if (listState is ListCategoryError) {
          customToast(msg: listState.message);
        }
      },
      child: BlocBuilder<ListCategoryBloc, ListCategoryState>(
        builder: (context, listState) {
          return BlocStateHandler<ListCategoryBloc, ListCategoryState>(
            bloc: context.read<ListCategoryBloc>(),
            isLoading: (s) => s is ListCategoryLoading,
            isError: (s) => s is ListCategoryError,
            getErrorMessage: (s) => (s as ListCategoryError).message,
            isSuccess: (s) => s is ListCategoryLoaded,
            getRetryCallback: (_) => () => context
                .read<ListCategoryBloc>()
                .add(const GetCategoriesEvent()),
            successBuilder: (context, state) {
              final loadedState = state as ListCategoryLoaded;
              return CategoriesListBody(
                pageContext: context,
                categories: loadedState.categories,
              );
            },
          );
        },
      ),
    );
  }
}
