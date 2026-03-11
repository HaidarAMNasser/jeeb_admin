import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';

class SearchDeliveryWidget extends StatefulWidget {
  const SearchDeliveryWidget({super.key});

  @override
  State<SearchDeliveryWidget> createState() => _SearchDeliveryWidgetState();
}

class _SearchDeliveryWidgetState extends State<SearchDeliveryWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: AppTranslation.searchDeliveryMenHint,
      controller: _searchController,
      onSubmitted: (query) {
        context.read<ListDeliveryBloc>().add(
              GetDeliveryMenEvent(search: query.isEmpty ? null : query),
            );
      },
      onRefetch: () {
        context.read<ListDeliveryBloc>().add(const GetDeliveryMenEvent());
      },
    );
  }
}
