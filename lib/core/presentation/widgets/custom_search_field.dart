import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';

/// Reusable search field with hint text, clear button, and optional refresh (restart) button.
/// [onRefetch] is called when the trailing restart is pressed or when clearing via suffix; typically clear search and reload list.
class CustomSearchField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final VoidCallback onRefetch;

  /// When false, hides the orange restart button (e.g. admin uses [trailingAction] instead).
  final bool showTrailingRefetch;

  /// Placed after the text field (e.g. admin filter/reset slot). If set, shown instead of [showTrailingRefetch].
  final Widget? trailingAction;

  const CustomSearchField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSubmitted,
    required this.onRefetch,
    this.showTrailingRefetch = true,
    this.trailingAction,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  void _onClear() {
    widget.controller.clear();
    widget.onRefetch();
  }

  void _onRefetch() {
    widget.controller.clear();
    widget.onRefetch();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16,
        AppPadding.p8,
        AppPadding.p16,
        AppPadding.p12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(
              filledColor: ColorManager.transparent,
              hintText: widget.hintText,
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              prefixIcon: Icon(Icons.search, color: ColorManager.primary),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: ColorManager.descriptionColor),
                      onPressed: _onClear,
                    )
                  : null,
            ),
          ),
          if (widget.trailingAction != null) ...[
            SizedBox(width: AppWidth.s8),
            widget.trailingAction!,
          ] else if (widget.showTrailingRefetch) ...[
            SizedBox(width: AppWidth.s8),
            Container(
              width: AppWidth.s50,
              height: AppHeight.s50,
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(AppRadius.r18),
              ),
              child: IconButton(
                icon: Icon(Icons.restart_alt, color: ColorManager.defaultWhite),
                onPressed: _onRefetch,
                tooltip: 'Clear search and refetch',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
