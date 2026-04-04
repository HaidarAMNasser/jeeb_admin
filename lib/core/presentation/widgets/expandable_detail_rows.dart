import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

/// Stacks [rows] with spacing; shows only the first [collapsedCount] until expanded.
class ExpandableDetailRows extends StatefulWidget {
  const ExpandableDetailRows({
    super.key,
    required this.rows,
    this.collapsedCount = 3,
  });

  final List<Widget> rows;
  final int collapsedCount;

  @override
  State<ExpandableDetailRows> createState() => _ExpandableDetailRowsState();
}

class _ExpandableDetailRowsState extends State<ExpandableDetailRows> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    if (rows.isEmpty) return const SizedBox.shrink();

    final limit = widget.collapsedCount;
    if (rows.length <= limit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(rows),
      );
    }

    final visible =
        _expanded ? rows : rows.take(limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._withSpacing(visible),
        SizedBox(height: AppHeight.s4),
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(AppRadius.r8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.p10,
              horizontal: AppPadding.p4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: _expanded
                      ? AppTranslation.detailsShowLess
                      : AppTranslation.detailsShowMore,
                  textStyle: getSemiBoldStyle(
                    fontSize: AppFontSize.s14,
                    color: ColorManager.primary,
                  ),
                ),
                SizedBox(width: AppWidth.s4),
                Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: ColorManager.primary,
                  size: AppSize.s22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _withSpacing(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) out.add(SizedBox(height: AppHeight.s12));
      out.add(items[i]);
    }
    return out;
  }
}
