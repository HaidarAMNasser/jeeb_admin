import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/delete_merchant/data/repositories/delete_merchant_repository.dart';

part 'delete_merchant_event.dart';
part 'delete_merchant_state.dart';

class DeleteMerchantBloc extends Bloc<DeleteMerchantEvent, DeleteMerchantState> {
  final DeleteMerchantRepository _deleteRepository;

  DeleteMerchantBloc(this._deleteRepository)
      : super(const DeleteMerchantInitial()) {
    on<DeleteMerchantEvent>((event, emit) async {
      if (event is DeleteMerchantSubmitted) {
        emit(const DeleteMerchantLoading());
        final result = await _deleteRepository.deleteMerchant(event.merchantId);
        result.fold(
          (failure) => emit(DeleteMerchantError(message: failure.message)),
          (_) => emit(const DeleteMerchantSuccess()),
        );
      }
    });
  }
}

