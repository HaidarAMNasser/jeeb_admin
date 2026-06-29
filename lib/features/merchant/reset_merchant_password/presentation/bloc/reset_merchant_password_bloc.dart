import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/reset_merchant_password/data/repositories/reset_merchant_password_repository.dart';

part 'reset_merchant_password_event.dart';
part 'reset_merchant_password_state.dart';

class ResetMerchantPasswordBloc
    extends Bloc<ResetMerchantPasswordEvent, ResetMerchantPasswordState> {
  final ResetMerchantPasswordRepository _repository;

  ResetMerchantPasswordBloc(this._repository)
      : super(const ResetMerchantPasswordInitial()) {
    on<ResetMerchantPasswordSubmitted>((event, emit) async {
      emit(const ResetMerchantPasswordLoading());
      final result = await _repository.resetMerchantPassword(
        id: event.merchantId,
        password: event.password,
      );

      result.fold(
        (failure) =>
            emit(ResetMerchantPasswordError(message: failure.message)),
        (_) => emit(const ResetMerchantPasswordSuccess()),
      );
    });
  }
}
