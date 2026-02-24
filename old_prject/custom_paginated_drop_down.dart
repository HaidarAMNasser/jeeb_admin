import 'package:easy_localization/easy_localization.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/widgets/animated_border.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPaginatedDropDown extends StatefulWidget {
  final String title;
  final String hintText;
  final String? editText;
  final double? height;
  final double? maxHeight;
  final double? borderRadius;
  final List dropDownList;
  final List? selectedDropDownList;
  final GestureTapCallback? validation;
  final void Function(dynamic) onSelectItem;
  final VoidCallback? clearData;
  final bool? allowRefresh;
  final bool? hasTitle;
  final bool? hasBorder;
  final BoxBorder? border;
  final Color? color;
  final bool? hasBottomSpace;
  final bool? isRequired;
  final bool? forBanks;
  final bool? fromProduct;
  final bool isError;
  final ValueChanged<bool>? onExpandedChanged;
  final bool? fromSuppliers;
  final bool? isReadOnly;
  final bool? fromTax;
  final bool? toShowAll;
  final bool? fromAccount;
  final VoidCallback? onLoadMore; // Local pagination
  final bool? withSearch;
  final bool? fromPayment;
  final bool? fromCurrencies;
  final bool? onlyString;
  final String? initOption;
  final bool? isPrimaryBeneficiary;
  final bool? fromId;
  final bool? fromEdit;
  final bool? fromClassification;
  final bool? fromCostCenter;
  final Color? searchBorderColor;
  final bool? isLoading;
  final VoidCallback? onFetchingData;
  final VoidCallback? onRefreshPressed;
  final bool withApiPagination;
  final bool isLoadingMore;
  final bool isSuccess;
  final bool hasMoreData;
  final bool isFiltered;
  final Future<void> Function()? onLoadMoreApi;
  final void Function(String)? onSearchChangedApi;
  final bool autoOpenOnSuccess;
  final bool showFtechButton;
  final bool
  hideSelectedValueInSearch; // NEW: Optional parameter to hide selected value in search bar
  final bool showCancel; // Show cancel button when value is selected
  const CustomPaginatedDropDown({
    super.key,
    required this.title,
    required this.hintText,
    required this.dropDownList,
    required this.onSelectItem,
    this.selectedDropDownList,
    this.clearData,
    this.editText,
    this.isReadOnly = false,
    this.isSuccess = false,
    this.validation,
    this.hasTitle = true,
    this.height,
    this.hasBorder = true,
    this.border,
    this.color,
    this.onFetchingData,
    this.onRefreshPressed,
    this.borderRadius,
    this.hasBottomSpace = true,
    this.maxHeight,
    this.isRequired = false,
    this.isLoading = false,
    this.forBanks,
    this.onExpandedChanged,
    this.fromSuppliers,
    this.fromTax,
    this.toShowAll,
    this.fromAccount,
    this.onLoadMore,
    this.withSearch,
    this.fromPayment,
    this.fromCurrencies,
    this.isError = false,
    this.onlyString,
    this.initOption,
    this.isPrimaryBeneficiary,
    this.fromEdit,
    this.fromId,
    this.fromClassification,
    this.fromCostCenter,
    this.searchBorderColor,
    this.fromProduct,
    // NEW: Initialize new parameters
    this.withApiPagination =
        false, // Default to false to not break existing implementations
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.isFiltered = false,
    this.onLoadMoreApi,
    this.onSearchChangedApi,
    this.autoOpenOnSuccess = true,
    this.showFtechButton = false,
    this.hideSelectedValueInSearch =
        false, // Default to false to not affect existing usage
    this.showCancel = false, // Default to false - cancel button is optional
    this.allowRefresh = true,
    });

  @override
  State<CustomPaginatedDropDown> createState() =>
      _SelectDropdownTextFieldWidgetState();
}

class _SelectDropdownTextFieldWidgetState
    extends State<CustomPaginatedDropDown> {
  var isExpanded = false;
  late TextEditingController controller;
  late TextEditingController searchController;
  List filteredList = [];
  final FocusNode _searchFocusNode = FocusNode();

  // Track if we just made a selection to prevent auto-opening after selection
  bool _justMadeSelection = false;

  // NEW: Scroll controller to detect when user reaches the end of the list
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.editText ?? '');
    searchController = TextEditingController();
    filteredList = widget.dropDownList;

    // NEW: Add listener for API pagination
    if (widget.withApiPagination) {
      _scrollController.addListener(_onScroll);
    }
  }

  // NEW: Scroll listener method
  void _onScroll() {
    // Check if we are at the bottom of the list, not currently loading, and have more data to fetch
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent *
                0.95 && // 95% threshold
        !widget.isLoadingMore &&
        widget.hasMoreData) {
      widget.onLoadMoreApi?.call();
    }
  }

  @override
  void didUpdateWidget(covariant CustomPaginatedDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editText != oldWidget.editText &&
        widget.editText != controller.text) {
      controller.text = widget.editText ?? '';
    }
    if (widget.dropDownList != oldWidget.dropDownList) {
      // When API pagination is off, local filtering is active.
      // When API pagination is on, the parent widget provides the full (paginated) list.
      if (widget.withApiPagination || searchController.text.isEmpty) {
        filteredList = widget.dropDownList;
      } else {
        filterOptions(searchController.text);
      }
      setState(() {});
    }
    final wasLoading = oldWidget.isLoading ?? false;
    final isNotLoading = !(widget.isLoading ?? false);

    if (wasLoading &&
        isNotLoading &&
        widget.withSearch != null &&
        widget.withSearch! &&
        !_justMadeSelection &&
        widget.autoOpenOnSuccess &&
        (widget.isReadOnly == null || widget.isReadOnly == false)) {
      // The search has finished. Now, expand the list to show results.
      // We also check if the widget is still mounted to prevent errors.
      if (mounted) {
        setState(() {
          isExpanded = true;
        });
      }
    }

    // Don't reset the selection flag automatically - only reset on user search action
  }

  // Local filtering function (only used when withApiPagination is false)
  void filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = widget.dropDownList;
      } else {
        filteredList = widget.dropDownList.where((item) {
          String itemName = "";
          try {
            if (widget.fromTax == true) {
              itemName = item.taxName.toString().toLowerCase();
            } else if (widget.fromCurrencies == true) {
              final String name = item.name.toString();
              final String code = (item.code ?? '').toString();
              itemName = "$name $code".toLowerCase();
            } else if (widget.fromPayment != null && widget.fromPayment!) {
              itemName = item.name.toString().toLowerCase();
            } else if (widget.fromCostCenter == true) {
              final String code = (item.code ?? '').toString();
              final String name = item.name.toString();
              itemName = "$code $name".toLowerCase();
            } else {
              itemName = item.name.toString().toLowerCase();
            }
          } catch (e) {
            itemName = item.toString().toLowerCase();
          }
          return itemName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _toggleExpansion() {
    print("CustomPaginatedDropDown _toggleExpansion called:");
    print("isReadOnly: ${widget.isReadOnly}");
    setState(() {
      if (!(widget.isReadOnly != null && widget.isReadOnly!)) {
        print("Expanding dropdown...");
        isExpanded = !isExpanded;
        widget.onExpandedChanged?.call(isExpanded);
        if (isExpanded) {
          // When expanding, if not using API search, reset the local filter
          if (!widget.withApiPagination) {
            filteredList = widget.dropDownList;
          }
        }
      } else {
        print("Expansion blocked - widget is read-only");
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    searchController.dispose();
    _searchFocusNode.dispose();
    // NEW: Dispose the scroll controller
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hasTitle!)
          Container(
            margin: EdgeInsetsDirectional.only(bottom: AppPadding.p4),
            child: Row(
              children: [
                CustomText(
                  text: widget.title,
                  textStyle: getMediumStyle(
                    fontSize: AppFontSize.s14,
                    color: ColorManager.labelColor,
                  ),
                ),
                CustomText(
                  text: widget.isRequired! ? ' *' : '',
                  textStyle: getMediumStyle(
                    fontSize: AppFontSize.s14,
                    color: ColorManager.red,
                  ),
                ),
              ],
            ),
          ),
        if (widget.withSearch == true)
          AnimatedBorderWrapper(
            isLoading: widget.isLoading ?? false,
            child: Container(
              height: widget.height ?? 48.h,
              child: TextField(
                readOnly: widget.isReadOnly ?? false,
                controller: searchController,
                focusNode: _searchFocusNode,
                onSubmitted: (query) {
                  // if (query.isNotEmpty) {
                  setState(() {
                    this.isExpanded = false;
                    _justMadeSelection = false;
                  });
                  if (widget.withApiPagination) {
                    widget.onSearchChangedApi?.call(query);
                  } else {
                    if (!isExpanded) {
                      setState(() {
                        widget.onSelectItem(null);
                        isExpanded = true;
                        widget.onExpandedChanged?.call(isExpanded);
                      });
                    }
                    filterOptions(query);
                  }
                  // }
                },
                onTap: () {
                  print("CustomPaginatedDropDown search field onTap:");
                  print("isReadOnly: ${widget.isReadOnly}");
                  print("isExpanded: $isExpanded");
                  if (!isExpanded && !(widget.isReadOnly ?? false)) {
                    print("Expanding from search field tap...");
                    setState(() {
                      isExpanded = true;
                      // Reset the selection flag when user starts a new search
                      _justMadeSelection = false;
                      widget.onExpandedChanged?.call(isExpanded);
                      if (!widget.withApiPagination) {
                        filteredList = widget.dropDownList;
                      }
                    });
                  } else {
                    print(
                      "Search field tap blocked - read-only or already expanded",
                    );
                  }
                },
                // ... (rest of the TextField decoration is the same)
                style: getRegularStyle(color: ColorManager.black),
                decoration: InputDecoration(
                  filled: true, // enable filling
                  fillColor: ColorManager.white,
                  hintStyle: getRegularStyle(
                    color: widget.initOption != null && widget.initOption != ""
                        ? ColorManager.black
                        : ColorManager.hintColor,
                  ),
                  hintText:
                      widget.initOption ??
                      TranslationsController.instance.getTranslations().search,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isError || widget.showFtechButton)
                        IconButton(
                          onPressed: () {
                            if (widget.isReadOnly == null ||
                                widget.isReadOnly == false) {
                              if (widget.onFetchingData != null) {
                                searchController.clear();

                                if (!widget.withApiPagination) {
                                  filteredList = widget.dropDownList;
                                }

                                if (widget.onRefreshPressed != null) {
                                  widget.onRefreshPressed!();
                                }

                                setState(() {});

                                (widget.allowRefresh == null ||
                                        widget.allowRefresh == true)
                                    ? widget.onFetchingData!()
                                    : null;

                                if (((widget.isLoading == null) ||
                                        (widget.isLoading == false)) &&
                                    (isExpanded == true)) {
                                  _toggleExpansion();
                                }
                              }
                            }
                          },
                          icon: Icon(
                            Icons.restart_alt,
                            size: 20.sp,
                            color: ColorManager.textSubColor,
                          ),
                        ),
                      if (widget.showCancel &&
                          widget.clearData != null &&
                          widget.initOption != null &&
                          widget.initOption!.isNotEmpty &&
                          !(widget.isReadOnly ?? false))
                        IconButton(
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              searchController.clear();
                              isExpanded = false;
                            });
                            widget.clearData!();
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(left: AppSize.s8.w),
                            child: Icon(
                              Icons.delete_outline_outlined,
                              size: 20.sp,
                              color: ColorManager.red.withOpacity(0.5),
                            ),
                          ),
                        ),
                      InkWell(
                        onTap:
                            (widget.fromEdit != null && widget.fromEdit!) ||
                                (widget.isReadOnly ?? false)
                            ? () {
                                print(
                                  "Arrow tap blocked - fromEdit: ${widget.fromEdit}, isReadOnly: ${widget.isReadOnly}",
                                );
                              } // Disable tap for both fromEdit and isReadOnly
                            : () {
                                print("Arrow tap - calling _toggleExpansion");
                                if ((widget.isLoading == null) ||
                                    (widget.isLoading == false)) {
                                  _toggleExpansion();
                                }
                              },
                        child: Padding(
                          padding: context.locale.languageCode != 'en'
                              ? EdgeInsets.only(left: 16)
                              : EdgeInsets.only(right: 16),
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: AppSize.s25,
                            color: ColorManager.textSubColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 13.w),
                  border: widget.hasBorder!
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.isError
                                ? ColorManager.red
                                : widget.isSuccess
                                ? ColorManager.primaryColor
                                : (widget.searchBorderColor ??
                                      ColorManager.borderColor),
                            width: widget.isSuccess ? 1 : AppWidth.s1.sp,
                          ),
                          borderRadius: isExpanded
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r50,
                                  ),
                                  topRight: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r50,
                                  ),
                                )
                              : BorderRadius.circular(
                                  widget.borderRadius ?? AppRadius.r50,
                                ),
                        )
                      : InputBorder.none,
                  enabledBorder: widget.hasBorder!
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.isError
                                ? ColorManager.red
                                : widget.isSuccess
                                ? ColorManager.primaryColor
                                : (widget.searchBorderColor ??
                                      ColorManager.borderColor),
                            width: widget.isSuccess ? 1 : AppWidth.s1.sp,
                          ),
                          borderRadius: isExpanded
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r30,
                                  ),
                                  topRight: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r30,
                                  ),
                                )
                              : BorderRadius.circular(
                                  widget.borderRadius ?? AppRadius.r50,
                                ),
                        )
                      : InputBorder.none,
                  focusedBorder: widget.hasBorder!
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.isError
                                ? ColorManager.red
                                : widget.isSuccess
                                ? ColorManager.primaryColor
                                : (widget.searchBorderColor ??
                                      ColorManager.borderColor),
                            width: widget.isSuccess ? 1 : AppWidth.s1.sp,
                          ),
                          borderRadius: isExpanded
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r30,
                                  ),
                                  topRight: Radius.circular(
                                    widget.borderRadius ?? AppRadius.r30,
                                  ),
                                )
                              : BorderRadius.circular(
                                  widget.borderRadius ?? AppRadius.r30,
                                ),
                        )
                      : InputBorder.none,
                ),
              ),
            ),
          ),
        if (widget.withSearch == null || !(widget.withSearch!))
          GestureDetector(
            onTap: (widget.fromEdit != null && widget.fromEdit!)
                ? () {}
                : () {
                    _searchFocusNode.unfocus();
                    if ((widget.isLoading == null) ||
                        (widget.isLoading == false)) {
                      _toggleExpansion();
                    }
                    if (isExpanded) {
                      filteredList = widget.dropDownList;
                      searchController.clear();
                    }
                  },
            child: AnimatedBorderWrapper(
              isLoading: widget.isLoading ?? true,
              borderRadius: AppRadius.r30,
              child: Container(
                height: widget.height ?? 48.h,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 12.w,
                ),
                decoration: BoxDecoration(
                  border:
                      widget.border ??
                      (widget.hasBorder!
                          ? Border.all(
                              color: widget.isError
                                  ? ColorManager.red
                                  : widget.isSuccess
                                  ? ColorManager.primaryColor
                                  : ColorManager.borderColor,
                              width: widget.isSuccess ? 1 : AppWidth.s0_5,
                            )
                          : null),
                  borderRadius: isExpanded
                      ? BorderRadius.only(
                          topLeft: Radius.circular(
                            widget.borderRadius ?? AppRadius.r30,
                          ),
                          topRight: Radius.circular(
                            widget.borderRadius ?? AppRadius.r30,
                          ),
                        )
                      : BorderRadius.circular(
                          widget.borderRadius ?? AppRadius.r50,
                        ),
                  color: widget.color ?? ColorManager.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: widget.height ?? AppHeight.s45,
                        child: TextField(
                          enabled: false,
                          style: getRegularStyle(color: ColorManager.black),
                          controller: controller,
                          cursorColor: ColorManager.primaryColor,

                          decoration: InputDecoration(
                          
                            contentPadding: EdgeInsets.zero,
                            filled: true, // enable filling
                            fillColor: ColorManager.transparent,
                            border: InputBorder.none,
                            hintText: widget.initOption ?? widget.hintText,
                            hintStyle: getRegularStyle(
                              color:
                                  widget.initOption != "" &&
                                      widget.initOption != null
                                  ? ColorManager.black
                                  : ColorManager.textSubColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (widget.isError || widget.showFtechButton)
                      IconButton(
                        onPressed: () {
                          if (widget.onFetchingData != null) {
                            searchController.clear();

                            if (!widget.withApiPagination) {
                              filteredList = widget.dropDownList;
                            }

                            if (widget.onRefreshPressed != null) {
                              widget.onRefreshPressed!();
                            }

                            setState(() {});

                            (widget.allowRefresh == null ||
                                    widget.allowRefresh == true)
                                ? widget.onFetchingData!()
                                : null;

                            if (((widget.isLoading == null) ||
                                    (widget.isLoading == false)) &&
                                (isExpanded == true)) {
                              _toggleExpansion();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.restart_alt,
                          size: 20.sp,
                          color: ColorManager.textSubColor,
                        ),
                      ),
                    if (widget.showCancel &&
                        widget.clearData != null &&
                        widget.initOption != null &&
                        widget.initOption!.isNotEmpty &&
                        !(widget.isReadOnly ?? false))
                      IconButton(
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            searchController.clear();
                            isExpanded = false;
                          });
                          widget.clearData!();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: ColorManager.red,
                        ),
                      ),
                    SizedBox(
                      height: AppHeight.s24,
                      width: AppWidth.s24,
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: AppSize.s25,
                        color: ColorManager.textSubColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Visibility(
          visible: isExpanded && filteredList.isNotEmpty,
          child: Container(
            constraints: BoxConstraints(maxHeight: widget.maxHeight ?? 250.h),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: AppWidth.s0_5,
                color: ColorManager.borderColor,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.r15),
                bottomRight: Radius.circular(AppRadius.r15),
              ),
              color: ColorManager.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  filteredList.length +
                  (widget.withApiPagination && widget.hasMoreData ? 1 : 0) +
                  (!widget.withApiPagination && widget.onLoadMore != null
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (widget.withApiPagination &&
                    index == filteredList.length &&
                    widget.hasMoreData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.isLoadingMore
                          ? CustomCircularProgressIndicator(size: 35)
                          : const SizedBox.shrink(),
                    ),
                  );
                }
                if (!widget.withApiPagination &&
                    index == filteredList.length &&
                    widget.onLoadMore != null) {
                  return IconButton(
                    onPressed: widget.onLoadMore,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: AppSize.s25,
                      color: ColorManager.textSubColor,
                    ),
                  );
                }

                final item = filteredList[index];
                String itemText = "";
                try {
                  if (widget.fromSuppliers == true) {
                    itemText = "${item.name} -${item.identificationNumber}";
                  } else if (widget.fromProduct == true) {
                    String displayQuantity = "0";
                    if (item.quantity != null &&
                        item.quantity.toString() != "null" &&
                        item.quantity.toString() != "0" &&
                        item.quantity.toString() != "" &&
                        item.quantity != 0) {
                      displayQuantity = item.quantity.toString();
                    }
                    itemText = "${item.name} - المتاح $displayQuantity";
                  } else if (widget.forBanks == true) {
                    itemText =
                        "${item.accountEntity.title} -${item.identificationNumber}";
                  } else if (widget.fromPayment != null &&
                      widget.fromPayment!) {
                    itemText = item.name;
                  } else if (widget.fromTax == true) {
                    itemText = item.taxName;
                  } else if (widget.onlyString != null && widget.onlyString!) {
                    itemText = item;
                  } else if (widget.fromCurrencies == true) {
                    final String name = (item.name ?? '').toString();
                    final String code = (item.code ?? '').toString();
                    itemText = code.isNotEmpty ? "$name - $code" : name;
                  } else if (widget.fromCostCenter == true) {
                    final String code = (item.code ?? '').toString();
                    final String name = (item.name ?? '').toString();
                    itemText = code.isNotEmpty ? "$code - $name" : name;
                  } else if (widget.isPrimaryBeneficiary != null &&
                      widget.isPrimaryBeneficiary!) {
                    itemText = item.isPrimaryBeneficiary;
                  } else if (widget.fromId != null && widget.fromId!) {
                    itemText = item.title;
                  } else {
                    itemText = item.name;
                  }
                } catch (e) {
                  itemText = item.toString();
                }

                return GestureDetector(
                  onTap: () {
                    _searchFocusNode.unfocus();
                    // Set the flag to indicate we just made a selection
                    _justMadeSelection = true;
                    if (widget.forBanks == null || !widget.forBanks!) {
                      if (widget.selectedDropDownList != null) {
                        final isAlreadySelected = widget.selectedDropDownList!
                            .any(
                              (paymentMethod) =>
                                  paymentMethod.methodId == item.id,
                            );
                        if (isAlreadySelected) {
                          widget.validation?.call();
                        } else {
                          widget.onSelectItem(item);
                          setState(() {
                            isExpanded = false;
                          });
                          String selectedText = (widget.fromTax == true)
                              ? item.taxName
                              : (widget.fromCostCenter == true)
                              ? "${item.code} - ${item.name}"
                              : (widget.isPrimaryBeneficiary != null &&
                                    widget.isPrimaryBeneficiary!)
                              ? item.isPrimaryBeneficiary
                              : (widget.fromId != null && widget.fromId!)
                              ? item.title
                              : item.name;
                          if (widget.withSearch == true &&
                              !widget.hideSelectedValueInSearch) {
                            searchController.text = selectedText;
                          }
                          if (widget.forBanks != null && widget.forBanks!) {
                            if (!widget.hideSelectedValueInSearch) {
                              controller.text =
                                  "${item.accountEntity.title} -${item.identificationNumber}";
                            }
                            setState(() {});
                          }
                          if (widget.fromProduct == true) {
                            String displayQuantity = "0";
                            if (item.quantity != null &&
                                item.quantity.toString() != "null" &&
                                item.quantity.toString() != "0" &&
                                item.quantity.toString() != "" &&
                                item.quantity != 0) {
                              displayQuantity = item.quantity.toString();
                            }
                            if (!widget.hideSelectedValueInSearch) {
                              controller.text =
                                  "${item.name} - المتاح $displayQuantity";
                            }
                            setState(() {});
                          }
                          if (widget.fromSuppliers != null &&
                              widget.fromSuppliers!) {
                            if (!widget.hideSelectedValueInSearch) {
                              controller.text =
                                  "${item.name} -${item.identificationNumber}";
                            }
                            setState(() {});
                          } else if (widget.fromCostCenter == true) {
                            if (!widget.hideSelectedValueInSearch) {
                              controller.text = "${item.code} - ${item.name}";
                            }
                            setState(() {});
                          } else {
                            if (!widget.hideSelectedValueInSearch) {
                              controller.text = selectedText;
                            }
                            setState(() {});
                          }
                        }
                      } else {
                        widget.onSelectItem(item);
                        setState(() {
                          isExpanded = false;
                        });
                        String selectedText =
                            (widget.isPrimaryBeneficiary != null &&
                                widget.isPrimaryBeneficiary == true)
                            ? item.isPrimaryBeneficiary
                            : (widget.fromId != null && widget.fromId == true)
                            ? item.title
                            : (widget.fromTax == true)
                            ? item.taxName
                            : (widget.fromCostCenter == true)
                            ? "${item.code} - ${item.name}"
                            : (widget.fromPayment != null &&
                                  widget.fromPayment!)
                            ? item.name
                            : (widget.onlyString != null && widget.onlyString!)
                            ? item
                            : item.name;
                        if (widget.withSearch == true &&
                            !widget.hideSelectedValueInSearch) {
                          searchController.text = selectedText;
                        }
                        if (widget.forBanks != null && widget.forBanks!) {
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text =
                                "${item.accountEntity.title} -${item.identificationNumber}";
                          }
                          setState(() {});
                        }
                        if (widget.fromProduct == true) {
                          String displayQuantity = "0";
                          if (item.quantity != null &&
                              item.quantity.toString() != "null" &&
                              item.quantity.toString() != "0" &&
                              item.quantity.toString() != "" &&
                              item.quantity != 0) {
                            displayQuantity = item.quantity.toString();
                          }
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text =
                                "${item.name} - المتاح $displayQuantity";
                          }
                          setState(() {});
                        }
                        if (widget.fromSuppliers != null &&
                            widget.fromSuppliers!) {
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text =
                                "${item.name} -${item.identificationNumber}";
                          }
                          setState(() {});
                        } else {
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text = selectedText;
                          }
                          setState(() {});
                        }
                      }
                    } else {
                      widget.onSelectItem(item);
                      setState(() {
                        isExpanded = false;
                      });
                      String selectedText =
                          (widget.onlyString != null && widget.onlyString!)
                          ? item
                          : item.name;
                      if (widget.withSearch == true &&
                          !widget.hideSelectedValueInSearch) {
                        searchController.text = selectedText;
                      }
                      if (widget.forBanks != null && widget.forBanks!) {
                        if (!widget.hideSelectedValueInSearch) {
                          controller.text =
                              "${item.accountEntity.title} -${item.identificationNumber}";
                        }
                        setState(() {});
                      } else if (widget.fromProduct == true) {
                        String displayQuantity = "0";
                        if (item.quantity != null &&
                            item.quantity.toString() != "null" &&
                            item.quantity.toString() != "0" &&
                            item.quantity.toString() != "" &&
                            item.quantity != 0) {
                          displayQuantity = item.quantity.toString();
                        }
                        if (!widget.hideSelectedValueInSearch) {
                          controller.text =
                              "${item.name} - المتاح $displayQuantity";
                        }
                        setState(() {});
                      }
                      if (widget.fromSuppliers != null &&
                          widget.fromSuppliers!) {
                        if (!widget.hideSelectedValueInSearch) {
                          controller.text =
                              "${item.name} -${item.identificationNumber}";
                        }
                        setState(() {});
                      } else if (widget.fromPayment != null &&
                          widget.fromPayment!) {
                        if (!widget.hideSelectedValueInSearch) {
                          controller.text = item.name;
                        } else if (widget.fromCostCenter == true) {
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text = "${item.code} - ${item.name}";
                          }
                          setState(() {});
                        } else {
                          if (!widget.hideSelectedValueInSearch) {
                            controller.text = selectedText;
                          }
                          setState(() {});
                        }
                      }
                    }
                  },

                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    color: ColorManager.transparent,
                    padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                    width: double.infinity,
                    child: CustomText(
                      text: itemText,
                      textStyle: getRegularStyle(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: widget.hasBottomSpace!,
          child: verticalSpace(height: AppHeight.s10),
        ),
      ],
    );
  }
}