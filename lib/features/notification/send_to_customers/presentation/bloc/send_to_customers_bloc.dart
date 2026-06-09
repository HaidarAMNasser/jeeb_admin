import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/notification/send_to_customers/data/repositories/send_to_customers_repository.dart';

part 'send_to_customers_event.dart';
part 'send_to_customers_state.dart';

class SendToCustomersBloc
    extends Bloc<SendToCustomersEvent, SendToCustomersState> {
  final SendToCustomersRepository _repository;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SendToCustomersBloc(this._repository) : super(const SendToCustomersInitial()) {
    on<SendToCustomersEvent>((event, emit) async {
      if (event is UpdateNotificationTitle) {
        titleController.text = event.title;
        emit(state.copyWith());
        add(const CheckSendNotificationValidation());
      } else if (event is UpdateNotificationBody) {
        bodyController.text = event.body;
        emit(state.copyWith());
        add(const CheckSendNotificationValidation());
      } else if (event is CheckSendNotificationValidation) {
        emit(state.copyWith(isValid: _isFormValid()));
      } else if (event is SendToCustomersSubmitted) {
        if (!state.isValid) return;

        emit(SendToCustomersLoading(isValid: state.isValid));

        final result = await _repository.sendNotification(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
        );

        result.fold(
          (failure) => emit(
            SendToCustomersError(
              message: failure.message,
              isValid: state.isValid,
            ),
          ),
          (_) => emit(const SendToCustomersSuccess()),
        );
      } else if (event is ResetSendNotificationForm) {
        titleController.clear();
        bodyController.clear();
        emit(const SendToCustomersInitial());
      }
    });
  }

  bool _isFormValid() {
    return titleController.text.trim().isNotEmpty &&
        bodyController.text.trim().isNotEmpty;
  }

  @override
  Future<void> close() {
    titleController.dispose();
    bodyController.dispose();
    return super.close();
  }
}
