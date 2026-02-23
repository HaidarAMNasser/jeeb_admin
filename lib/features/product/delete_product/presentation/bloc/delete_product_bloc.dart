import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/delete_product/data/repositories/delete_product_repository.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final DeleteProductRepository _deleteRepository;

  DeleteProductBloc(this._deleteRepository)
      : super(const DeleteProductInitial()) {
    on<DeleteProductEvent>((event, emit) async {
      if (event is DeleteProductSubmitted) {
        emit(const DeleteProductLoading());
        final result = await _deleteRepository.deleteProduct(event.productId);
        result.fold(
          (failure) => emit(DeleteProductError(message: failure.message)),
          (_) => emit(const DeleteProductSuccess()),
        );
      }
    });
  }
}

