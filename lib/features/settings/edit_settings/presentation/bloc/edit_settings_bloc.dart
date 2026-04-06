import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/settings/edit_settings/data/repositories/edit_settings_repository.dart';

part 'edit_settings_event.dart';
part 'edit_settings_state.dart';

class EditSettingsBloc extends Bloc<EditSettingsEvent, EditSettingsState> {
  final EditSettingsRepository _repository;

  EditSettingsBloc(this._repository) : super(const EditSettingsInitial()) {
    on<EditSettingsEvent>((event, emit) async {
      if (event is EditSettingsSubmitted) {
        emit(const EditSettingsLoading());
        final body = [
          {'key': 'supportPhone', 'value': event.supportPhone},
          {'key': 'whatsappNumber', 'value': event.whatsappNumber},
          {'key': 'defaultProductCommissionRate', 'value': event.defaultProductCommissionRate},
          {'key': 'deliveryTipPerKilometer', 'value': event.deliveryTipPerKilometer},
        ];
        final result = await _repository.patchSettings(body);
        result.fold(
          (failure) => emit(EditSettingsError(message: failure.message)),
          (_) => emit(const EditSettingsSuccess()),
        );
      }
    });
  }
}
