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
        
        // Build FormData with text fields
        final formData = FormData.fromMap({
          'name': event.name,
          if (event.description != null && event.description!.isNotEmpty)
            'description': event.description,
          'price': priceInSmallestUnit,
          'categoryId': event.categoryId,
          if (event.quantity != null) 'hasStock': true,
          if (event.quantity != null) 'stockQuantity': event.quantity,
          if (event.servesCount != null)
            'personCount': event.servesCount,
        });

        // Add images as actual file uploads (not path strings)
        for (final path in event.images) {
          if (path.startsWith('http')) continue; // existing URL
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(path),
          ));
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
