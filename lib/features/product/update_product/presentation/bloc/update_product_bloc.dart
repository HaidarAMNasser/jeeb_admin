import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/update_product/data/repositories/update_product_repository.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final UpdateProductRepository _updateRepository;

  UpdateProductBloc(this._updateRepository)
      : super(const UpdateProductInitial()) {
    on<UpdateProductEvent>((event, emit) async {
      if (event is UpdateProductSubmitted) {
        emit(const UpdateProductLoading());
        
        // Convert price from decimal to smallest currency unit (e.g., 12.99 -> 1299)
        final priceInSmallestUnit = (event.price * 100).toInt();
        
        // Build FormData
        final formData = FormData.fromMap({
          'name': event.name,
          if (event.description != null && event.description!.isNotEmpty)
            'description': event.description,
          'price': priceInSmallestUnit,
          'categoryId': event.categoryId,
          if (event.quantity != null)
            'stockQuantity': event.quantity,
        });
        
        // Add images individually to FormData
        for (var image in event.images) {
          formData.fields.add(MapEntry('images', image));
        }
        
        final result = await _updateRepository.updateProduct(
          id: event.id,
          formData: formData,
        );
        result.fold(
          (failure) => emit(UpdateProductError(message: failure.message)),
          (product) => emit(UpdateProductSuccess(product: product)),
        );
      }
    });
  }
}
