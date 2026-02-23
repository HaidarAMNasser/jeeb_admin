import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/create_product/data/repositories/create_product_repository.dart';

part 'create_product_event.dart';
part 'create_product_state.dart';

class CreateProductBloc extends Bloc<CreateProductEvent, CreateProductState> {
  final CreateProductRepository _createRepository;

  // Controllers accessible from BLoC
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // State values accessible directly
  List<String> get images => state.images;
  String? get selectedCategoryId => state.selectedCategoryId;

  CreateProductBloc(this._createRepository)
      : super(const CreateProductInitial()) {
    on<CreateProductEvent>((event, emit) async {
      if (event is InitializeProductForm) {
        if (event.product != null) {
          // Edit mode - initialize with product data
          nameController.text = event.product!.name;
          descriptionController.text = event.product!.description ?? '';
          priceController.text = event.product!.price.toString();
          quantityController.text = event.product!.quantity?.toString() ?? '';
          emit(CreateProductInitial(
            images: event.product!.images,
            selectedCategoryId: event.product!.categoryId,
            productId: event.product!.id,
          ));
        } else {
          // Create mode
          emit(const CreateProductInitial());
        }
        add(const CheckValidationEvent());
      } else if (event is UpdateProductName) {
        nameController.text = event.name;
        emit(state.copyWith());
        add(const CheckValidationEvent());
      } else if (event is UpdateProductDescription) {
        descriptionController.text = event.description;
        emit(state.copyWith());
        add(const CheckValidationEvent());
      } else if (event is UpdateProductPrice) {
        priceController.text = event.price;
        emit(state.copyWith());
        add(const CheckValidationEvent());
      } else if (event is UpdateProductQuantity) {
        quantityController.text = event.quantity;
        emit(state.copyWith());
      } else if (event is UpdateSelectedCategory) {
        emit(state.copyWith(selectedCategoryId: event.categoryId));
        add(const CheckValidationEvent());
      } else if (event is AddProductImage) {
        final updatedImages = List<String>.from(state.images)..add(event.imageUrl);
        emit(state.copyWith(images: updatedImages));
        add(const CheckValidationEvent());
      } else if (event is RemoveProductImage) {
        final updatedImages = List<String>.from(state.images)..removeAt(event.index);
        emit(state.copyWith(images: updatedImages));
        add(const CheckValidationEvent());
      } else if (event is CreateProductSubmitted) {
        if (!state.isValid) {
          return;
        }
        emit(state.copyWith(isLoading: true));
        final result = await _createRepository.createProduct(
          name: nameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
          price: double.tryParse(priceController.text.trim()) ?? 0.0,
          categoryId: state.selectedCategoryId ?? '',
          quantity: quantityController.text.trim().isEmpty
              ? null
              : int.tryParse(quantityController.text.trim()),
          images: state.images,
        );
        result.fold(
          (failure) => emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          )),
          (product) => emit(CreateProductSuccess(product: product)),
        );
      } else if (event is CheckValidationEvent) {
        final isValid = _isFormValid();
        emit(state.copyWith(isValid: isValid));
      } else if (event is ResetForm) {
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        quantityController.clear();
        emit(const CreateProductInitial());
      }
    });
  }

  bool _isFormValid() {
    if (nameController.text.trim().isEmpty) return false;
    if (priceController.text.trim().isEmpty) return false;
    if (double.tryParse(priceController.text.trim()) == null ||
        double.tryParse(priceController.text.trim())! <= 0) {
      return false;
    }
    if (state.selectedCategoryId == null || state.selectedCategoryId!.isEmpty) {
      return false;
    }
    if (state.images.isEmpty) return false;
    return true;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    return super.close();
  }
}

