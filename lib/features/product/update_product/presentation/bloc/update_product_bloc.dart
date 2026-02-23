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
        final result = await _updateRepository.updateProduct(
          id: event.id,
          name: event.name,
          description: event.description,
          price: event.price,
          categoryId: event.categoryId,
          quantity: event.quantity,
          images: event.images,
        );
        result.fold(
          (failure) => emit(UpdateProductError(message: failure.message)),
          (product) => emit(UpdateProductSuccess(product: product)),
        );
      }
    });
  }
}
