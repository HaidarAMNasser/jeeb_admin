import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/infrastructure/di/dependency_injection.dart' as di;
import '../../../../../core/infrastructure/services/notification_service.dart';
import '../../../../../core/infrastructure/services/storage_service.dart';
import '../../../login/data/models/token_model.dart';
import '../../../login/data/repositories/login_repository.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import '../../data/repositories/verify_repository.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final VerifyRepository _verifyRepository;
  final StorageService _storageService;
  final ProfileRepository _profileRepository;
  final LoginRepository _loginRepository;

  VerifyBloc(
    this._verifyRepository,
    this._storageService,
    this._profileRepository,
    this._loginRepository,
  ) : super(const VerifyInitial()) {
    on<VerifyEvent>((event, emit) async {
      if (event is VerifySubmitted) {
        emit(const VerifyLoading());
        final result = await _verifyRepository.verify(
          email: event.email,
          otp: event.otp,
        );

        await result.fold(
          (failure) async => emit(VerifyError(message: failure.message)),
          (data) async {
            final responseToken = data?['access_token'];
            final responseUser = data?['user'];

            if (responseToken != null &&
                responseToken.toString().isNotEmpty &&
                responseUser != null &&
                responseUser is Map) {
              try {
                final userMap = Map<String, dynamic>.from(responseUser);
                final tokenModel = TokenModel.fromJson({
                  'access_token': responseToken,
                  'user': userMap,
                });
                await _storageService.setUserToken(tokenModel.accessToken);
                await _storageService.setUserId(tokenModel.user.id);
                await _storageService.setUserRole(tokenModel.user.role);
                final verified = tokenModel.user.isVerified ||
                    (tokenModel.user.verifiedAt != null &&
                        tokenModel.user.verifiedAt!.isNotEmpty);
                await _storageService.setLoggedIn(true);
                await _storageService.setVerified(verified);
                await _storageService.setPendingVerifyEmail(null);

                final password = event.password?.trim();
                if (password != null && password.isNotEmpty) {
                  if (!emit.isDone) emit(const VerifyLoggingIn());
                  final loginResult = await _loginRepository.login(
                    email: event.email,
                    password: password,
                  );
                  await loginResult.fold(
                    (_) async {
                      // Login failed but we already have token from verify; still go to main
                    },
                    (tokenEntity) async {
                      await _storageService.setUserToken(tokenEntity.accessToken);
                      await _storageService.setUserId(tokenEntity.user.id);
                      await _storageService.setUserRole(tokenEntity.user.role.name);
                    },
                  );
                }
                if (!emit.isDone) {
                  di.sl<NotificationService>().requestSyncAfterLogin();
                  emit(const VerifySuccess(goToMain: true));
                }
                return;
              } catch (_) {
                // Fall through to try profile or go to login if parsing fails
              }
            }
            // No token in response: try existing stored token + profile
            final tokenToUse = await _storageService.getUserToken();
            if (tokenToUse.isEmpty) {
              if (!emit.isDone) emit(const VerifySuccess(goToMain: false));
              return;
            }
            final profileResult = await _profileRepository.getProfile();
            await profileResult.fold(
              (failure) async {
                if (!emit.isDone) emit(const VerifySuccess(goToMain: false));
              },
              (user) async {
                final verified =
                    user.isVerified || (user.verifiedAt != null);
                await _storageService.setLoggedIn(true);
                await _storageService.setVerified(verified);
                await _storageService.setPendingVerifyEmail(null);
                if (!emit.isDone) {
                  di.sl<NotificationService>().requestSyncAfterLogin();
                  emit(const VerifySuccess(goToMain: true));
                }
              },
            );
          },
        );
      } else if (event is ResendOtpSubmitted) {
        emit(const VerifyLoading());
        final result = await _verifyRepository.resendOtp(email: event.email);

        result.fold(
          (failure) => emit(VerifyError(message: failure.message)),
          (_) => emit(const VerifyOtpResent()),
        );
      }
    });
  }
}

