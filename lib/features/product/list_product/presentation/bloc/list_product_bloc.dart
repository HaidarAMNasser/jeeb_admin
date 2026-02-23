import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/data/repositories/list_product_repository.dart';

part 'list_product_event.dart';
part 'list_product_state.dart';

class ListProductBloc extends Bloc<ListProductEvent, ListProductState> {
  final ListProductRepository _repository;

  ListProductBloc(this._repository) : super(const ListProductInitial()) {
    on<ListProductEvent>((event, emit) async {
      if (event is GetProductsEvent) {
        emit(const ListProductLoading());
        final result = await _repository.getProducts();
        result.fold(
          (failure) => emit(ListProductError(message: failure.message)),
          (products) => emit(ListProductLoaded(products: products)),
        );
      }
    });
  }
}

