import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/widgets/area_item_info.dart';
import 'package:jeeb_admin/features/areas/presentation/widgets/area_options_dialog.dart';

class AreaListItem extends StatelessWidget {
  final AreaEntity area;
  final VoidCallback onDelete;

  const AreaListItem({
    super.key,
    required this.area,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorManager.defaultWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AreaItemInfo(area: area),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => AreaOptionsDialog.show(
                context: context,
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    Routes.addArea,
                    arguments: {'area': area},
                  );
                },
                onDelete: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
