import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/auth/profile/data/repositories/profile_repository.dart';


part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ProfileRepository _profileRepository;

  ChangePasswordBloc(this._profileRepository)
    : super(const ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(const ChangePasswordLoading());
    if (event.newPassword != event.confirmPassword) {
      emit(ChangePasswordError(message: AppTranslation.passwordsDoNotMatch));
      return;
    }
    final result = await _profileRepository.updateProfile(
      password: event.currentPassword,
      newPassword: event.newPassword,
      confirmedPassword: event.confirmPassword,
    );
    result.fold(
      (failure) => emit(ChangePasswordError(message: failure.message)),
      (_) => emit(const ChangePasswordSuccess()),
    );
  }
}
