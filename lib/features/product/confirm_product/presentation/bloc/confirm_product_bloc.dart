import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/confirm_product/data/repositories/confirm_product_repository.dart';

part 'confirm_product_event.dart';
part 'confirm_product_state.dart';

class ConfirmProductBloc
    extends Bloc<ConfirmProductEvent, ConfirmProductState> {
  final ConfirmProductRepository _repository;

  ConfirmProductBloc(this._repository)
      : super(const ConfirmProductInitial()) {
    on<ConfirmProductEvent>((event, emit) async {
      if (event is ConfirmProductSubmitted) {
        emit(const ConfirmProductLoading());
        final result = await _repository.confirmProduct(
          productId: event.productId,
          newPrice: event.newPrice,
        );

        result.fold(
          (failure) => emit(ConfirmProductError(message: failure.message)),
          (_) => emit(const ConfirmProductSuccess()),
        );
      }
    });
  }
}

