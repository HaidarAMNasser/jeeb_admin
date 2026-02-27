import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';

class SearchDeliveryWidget extends StatefulWidget {
  const SearchDeliveryWidget({super.key});

  @override
  State<SearchDeliveryWidget> createState() => _SearchDeliveryWidgetState();
}

class _SearchDeliveryWidgetState extends State<SearchDeliveryWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  void _onSearchSubmitted(String query) {
    context.read<ListDeliveryBloc>().add(
          GetDeliveryMenEvent(search: query.isEmpty ? null : query),
        );
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<ListDeliveryBloc>().add(
      const GetDeliveryMenEvent(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: CustomTextField(
        hintText: AppTranslation.searchDeliveryMenHint,
        controller: _searchController,
        onSubmitted: _onSearchSubmitted,
        prefixIcon: Icon(
          Icons.search,
          color: ColorManager.primary,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: ColorManager.descriptionColor,
                ),
                onPressed: _onClearSearch,
              )
            : null,
      ),
    );
  }
}

