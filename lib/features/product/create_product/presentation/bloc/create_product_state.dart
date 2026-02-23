part of 'create_product_bloc.dart';

abstract class CreateProductState extends Equatable {
  final List<String> images;
  final String? selectedCategoryId;
  final String? productId; // For edit mode
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const CreateProductState({
    this.images = const [],
    this.selectedCategoryId,
    this.productId,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  CreateProductState copyWith({
    List<String>? images,
    String? selectedCategoryId,
    String? productId,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  });

  @override
  List<Object?> get props => [
        images,
        selectedCategoryId,
        productId,
        isValid,
        isLoading,
        errorMessage,
      ];
}

class CreateProductInitial extends CreateProductState {
  const CreateProductInitial({
    super.images,
    super.selectedCategoryId,
    super.productId,
    super.isValid,
    super.isLoading,
    super.errorMessage,
  });

  @override
  CreateProductState copyWith({
    List<String>? images,
    String? selectedCategoryId,
    String? productId,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreateProductInitial(
      images: images ?? this.images,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      productId: productId ?? this.productId,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CreateProductSuccess extends CreateProductState {
  final ProductEntity product;

  CreateProductSuccess({required this.product})
      : super(
          images: product.images,
          selectedCategoryId: product.categoryId,
        );

  @override
  List<Object?> get props => [product, ...super.props];

  @override
  CreateProductState copyWith({
    List<String>? images,
    String? selectedCategoryId,
    String? productId,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreateProductInitial(
      images: images ?? this.images,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      productId: productId ?? this.productId,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

