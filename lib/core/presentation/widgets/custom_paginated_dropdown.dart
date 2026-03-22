import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/animated_border_wrapper.dart';

/// A reusable paginated dropdown widget with scroll detection
///
/// Generic type T should be the entity/model type
/// displayText function extracts the display text from the item
/// onLoadMore is called when user scrolls near bottom (90% threshold)
///
/// When [enableSearch] is true, a search field is shown in the expanded panel
/// and [onSearchChanged] is called (debounced) so the parent can call the API.
class CustomPaginatedDropdown<T> extends StatefulWidget {
  final String title;
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) displayText;
  final ValueChanged<T?> onChanged;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool isLoadingMore;
  /// When set, drives [AnimatedBorderWrapper] without affecting the load-more footer.
  final bool? isBorderLoading;
  final bool hasMoreData;
  final bool isError;
  final String? errorMessage;
  final bool isRequired;
  final double? maxHeight;
  final bool isReadOnly;

  final bool enableSearch;
  final String? searchHintText;
  final ValueChanged<String>? onSearchChanged;
  final String? emptyMessage;

  const CustomPaginatedDropdown({
    super.key,
    required this.title,
    required this.hintText,
    required this.items,
    this.selectedItem,
    required this.displayText,
    required this.onChanged,
    this.onLoadMore,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isBorderLoading,
    this.hasMoreData = true,
    this.isError = false,
    this.errorMessage,
    this.isRequired = false,
    this.maxHeight,
    this.isReadOnly = false,
    this.enableSearch = false,
    this.searchHintText,
    this.onSearchChanged,
    this.emptyMessage,
  });

  @override
  State<CustomPaginatedDropdown<T>> createState() =>
      _CustomPaginatedDropdownState<T>();
}

class _CustomPaginatedDropdownState<T>
    extends State<CustomPaginatedDropdown<T>> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isExpanded = false;

  bool get _borderPulse =>
      widget.isBorderLoading ?? widget.isLoadingMore;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomPaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selectionCleared =
        oldWidget.selectedItem != null && widget.selectedItem == null;
    final becameReadOnly = !oldWidget.isReadOnly && widget.isReadOnly;
    final itemsGone = !widget.enableSearch &&
        widget.items.isEmpty &&
        oldWidget.items.isNotEmpty;
    if (selectionCleared || becameReadOnly || itemsGone) {
      if (_isExpanded) {
        setState(() => _isExpanded = false);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_scrollController.position.outOfRange &&
        widget.hasMoreData &&
        !widget.isLoadingMore) {
      widget.onLoadMore?.call();
    }
  }

  void _onSearchTextChanged(String value) {
    if (!widget.enableSearch) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      widget.onSearchChanged?.call(value.trim());
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  bool get _showExpandedPanel =>
      _isExpanded &&
      !widget.isReadOnly &&
      (widget.enableSearch || widget.items.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomText(
              text: widget.title,
              textStyle: getMediumStyle(
                fontSize: AppFontSize.s15,
                color: ColorManager.defaultWhite,
              ),
            ),
            if (widget.isRequired)
              CustomText(
                text: ' *',
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s16,
                  color: ColorManager.warning,
                ),
              ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        if (widget.isLoading)
          AnimatedBorderWrapper(
            isLoading: true,
            borderRadius: AppRadius.r18,
            borderWidth: 3.0,
            child: Container(
              height: AppHeight.s56,
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
              decoration: BoxDecoration(
                color: ColorManager.defaultWhite,
                borderRadius: BorderRadius.circular(AppRadius.r18),
              ),
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: widget.hintText,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.descriptionColor,
                ),
              ),
            ),
          )
        else if (widget.isError)
          Container(
            height: AppHeight.s56,
            decoration: BoxDecoration(
              color: ColorManager.defaultWhite,
              borderRadius: BorderRadius.circular(AppRadius.r18),
              border: Border.all(color: ColorManager.warning),
            ),
            child: Center(
              child: CustomText(
                text: widget.errorMessage ?? 'Error loading data',
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.warning,
                ),
              ),
            ),
          )
        else
          AnimatedBorderWrapper(
            isLoading: _borderPulse,
            borderRadius: AppRadius.r18,
            borderWidth: 3.0,
            child: GestureDetector(
              onTap: widget.isReadOnly
                  ? null
                  : () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
              child: Container(
                height: AppHeight.s56,
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                decoration: BoxDecoration(
                  color: ColorManager.defaultWhite,
                  borderRadius: _isExpanded
                      ? BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.r18),
                          topRight: Radius.circular(AppRadius.r18),
                        )
                      : BorderRadius.circular(AppRadius.r18),
                  border: Border.all(
                    color: widget.isError
                        ? ColorManager.warning
                        : ColorManager.borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: widget.selectedItem != null
                            ? widget.displayText(widget.selectedItem as T)
                            : widget.hintText,
                        textStyle: getRegularStyle(
                          fontSize: AppFontSize.s14,
                          color: widget.selectedItem != null
                              ? ColorManager.productNameColor
                              : ColorManager.descriptionColor,
                        ),
                      ),
                    ),
                    if (!widget.isReadOnly)
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ColorManager.descriptionColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
        if (_showExpandedPanel)
          Container(
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight ?? 250,
            ),
            decoration: BoxDecoration(
              color: ColorManager.defaultWhite,
              border: Border(
                left: BorderSide(color: ColorManager.borderColor),
                right: BorderSide(color: ColorManager.borderColor),
                bottom: BorderSide(color: ColorManager.borderColor),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r18),
                bottomRight: Radius.circular(AppRadius.r18),
              ),
            ),
            child: widget.enableSearch
                ? SizedBox(
                    height: widget.maxHeight ?? 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppPadding.p12,
                            AppHeight.s8,
                            AppPadding.p12,
                            AppHeight.s4,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchTextChanged,
                            style: getRegularStyle(
                              fontSize: AppFontSize.s14,
                              color: ColorManager.productNameColor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorManager.defaultWhite,
                              hintText: widget.searchHintText ?? '',
                              hintStyle: getRegularStyle(
                                fontSize: AppFontSize.s14,
                                color: ColorManager.descriptionColor,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorManager.descriptionColor,
                                size: 22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p8,
                                vertical: AppHeight.s12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                borderSide: BorderSide(
                                  color: ColorManager.borderColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                borderSide: BorderSide(
                                  color: ColorManager.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                borderSide: BorderSide(
                                  color: ColorManager.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildItemList(),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.items.length +
                        (widget.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) =>
                        _buildListTile(context, index),
                  ),
          ),
      ],
    );
  }

  Widget _buildItemList() {
    if (widget.items.isEmpty && !widget.isLoadingMore) {
      final msg = widget.emptyMessage;
      if (msg == null || msg.isEmpty) {
        return const SizedBox.shrink();
      }
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: CustomText(
            text: msg,
            textAlign: TextAlign.center,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.descriptionColor,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.items.length + (widget.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) => _buildListTile(context, index),
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    if (index == widget.items.length) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: widget.isLoadingMore
              ? const CustomCircleIndicator()
              : const SizedBox.shrink(),
        ),
      );
    }

    final item = widget.items[index];
    final isSelected = widget.selectedItem == item;

    return InkWell(
      onTap: () {
        widget.onChanged(item);
        setState(() {
          _isExpanded = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppHeight.s12,
        ),
        color: isSelected
            ? ColorManager.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: widget.displayText(item),
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: isSelected
                      ? ColorManager.primary
                      : ColorManager.productNameColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 20,
                color: ColorManager.primary,
              ),
          ],
        ),
      ),
    );
  }
}
