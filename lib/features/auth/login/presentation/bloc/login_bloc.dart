import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/infrastructure/services/storage_service.dart';
import '../../data/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final StorageService _storageService;

  LoginBloc(
    this._loginRepository,
    this._storageService,
  ) : super(const LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(const LoginLoading());

      final result = await _loginRepository.login(
        email: event.email,
        password: event.password,
      );

      await result.fold(
        (failure) async {
          if (emit.isDone) return;
          emit(LoginError(message: failure.message));
        },
        (tokenEntity) async {
          await _storageService.setUserToken(tokenEntity.accessToken);
          await _storageService.setUserRole(tokenEntity.user.role.name);

          if (emit.isDone) return;
          emit(const LoginSuccess());
        },
      );
    });
  }
}

