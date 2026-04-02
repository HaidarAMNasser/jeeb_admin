import 'package:jeeb_admin/core/common/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple storage service for token, language, and auth state
/// Can be extended later with flutter_secure_storage for tokens
abstract class StorageService {
  /// Loads prefs into [AppConstants] static fields (call once at startup).
  Future<void> hydrateAppConstantsCache();

  Future<String> getUserToken();
  Future<void> setUserToken(String token);
  String getAppLanguage();
  Future<void> setAppLanguage(String lang);
  Future<String?> getUserRole();
  Future<void> setUserRole(String role);
  Future<int?> getUserId();
  Future<void> setUserId(int userId);
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
  Future<bool> isVerified();
  Future<void> setVerified(bool value);
  Future<String?> getPendingVerifyEmail();
  Future<void> setPendingVerifyEmail(String? email);

  /// Last FCM token successfully reported to the backend (for deduplication).
  Future<String?> getFcmLastSyncedToken();
  Future<void> setFcmLastSyncedToken(String token);

  /// Device registration token from Firebase (available before login).
  Future<String?> getFcmDeviceToken();
  Future<void> setFcmDeviceToken(String token);

  Future<bool> getMerchantHidePostConfirmEducation();
  Future<void> setMerchantHidePostConfirmEducation(bool value);

  Future<void> clearStorage({bool clearAuthParams = false});
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _sharedPreferences;

  StorageServiceImpl(this._sharedPreferences);

  void _applyCacheFromPrefs() {
    AppConstants.accessToken =
        _sharedPreferences.getString(AppConstants.prefAccessToken) ?? '';
    AppConstants.languageCode =
        _sharedPreferences.getString(AppConstants.prefLanguageCode) ?? '';
    AppConstants.fcmToken =
        _sharedPreferences.getString(AppConstants.prefFcmDeviceToken);
    AppConstants.fcmLastSyncedToken =
        _sharedPreferences.getString(AppConstants.prefFcmLastSyncedToken);
    AppConstants.userRole =
        _sharedPreferences.getString(AppConstants.prefUserRole);
    AppConstants.userId = _sharedPreferences.getInt(AppConstants.prefUserId);
    AppConstants.isLoggedIn =
        _sharedPreferences.getBool(AppConstants.prefIsLoggedIn) ?? false;
    AppConstants.isVerified =
        _sharedPreferences.getBool(AppConstants.prefIsVerified) ?? false;
    AppConstants.pendingVerifyEmail =
        _sharedPreferences.getString(AppConstants.prefPendingVerifyEmail);
    AppConstants.firstLaunchDone =
        _sharedPreferences.getBool(AppConstants.prefFirstLaunchDone) ?? false;
  }

  @override
  Future<void> hydrateAppConstantsCache() async {
    _applyCacheFromPrefs();
  }

  @override
  Future<String> getUserToken() async {
    final v =
        _sharedPreferences.getString(AppConstants.prefAccessToken) ?? '';
    AppConstants.accessToken = v;
    return v;
  }

  @override
  Future<void> setUserToken(String token) async {
    await _sharedPreferences.setString(AppConstants.prefAccessToken, token);
    AppConstants.accessToken = token;
  }

  @override
  String getAppLanguage() {
    final v =
        _sharedPreferences.getString(AppConstants.prefLanguageCode) ?? '';
    AppConstants.languageCode = v;
    return v;
  }

  @override
  Future<void> setAppLanguage(String lang) async {
    await _sharedPreferences.setString(AppConstants.prefLanguageCode, lang);
    AppConstants.languageCode = lang;
  }

  @override
  Future<String?> getUserRole() async {
    final v = _sharedPreferences.getString(AppConstants.prefUserRole);
    AppConstants.userRole = v;
    return v;
  }

  @override
  Future<void> setUserRole(String role) async {
    await _sharedPreferences.setString(AppConstants.prefUserRole, role);
    AppConstants.userRole = role;
  }

  @override
  Future<int?> getUserId() async {
    final v = _sharedPreferences.getInt(AppConstants.prefUserId);
    AppConstants.userId = v;
    return v;
  }

  @override
  Future<void> setUserId(int userId) async {
    await _sharedPreferences.setInt(AppConstants.prefUserId, userId);
    AppConstants.userId = userId;
  }

  @override
  Future<bool> isFirstLaunch() async {
    final done =
        _sharedPreferences.getBool(AppConstants.prefFirstLaunchDone) ?? false;
    AppConstants.firstLaunchDone = done;
    return !done;
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    await _sharedPreferences.setBool(AppConstants.prefFirstLaunchDone, true);
    AppConstants.firstLaunchDone = true;
  }

  @override
  Future<bool> isLoggedIn() async {
    final v = _sharedPreferences.getBool(AppConstants.prefIsLoggedIn) ?? false;
    AppConstants.isLoggedIn = v;
    return v;
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _sharedPreferences.setBool(AppConstants.prefIsLoggedIn, value);
    AppConstants.isLoggedIn = value;
  }

  @override
  Future<bool> isVerified() async {
    final v = _sharedPreferences.getBool(AppConstants.prefIsVerified) ?? false;
    AppConstants.isVerified = v;
    return v;
  }

  @override
  Future<void> setVerified(bool value) async {
    await _sharedPreferences.setBool(AppConstants.prefIsVerified, value);
    AppConstants.isVerified = value;
  }

  @override
  Future<String?> getPendingVerifyEmail() async {
    final v =
        _sharedPreferences.getString(AppConstants.prefPendingVerifyEmail);
    AppConstants.pendingVerifyEmail = v;
    return v;
  }

  @override
  Future<void> setPendingVerifyEmail(String? email) async {
    if (email == null) {
      await _sharedPreferences.remove(AppConstants.prefPendingVerifyEmail);
      AppConstants.pendingVerifyEmail = null;
    } else {
      await _sharedPreferences.setString(
        AppConstants.prefPendingVerifyEmail,
        email,
      );
      AppConstants.pendingVerifyEmail = email;
    }
  }

  @override
  Future<String?> getFcmLastSyncedToken() async {
    final v =
        _sharedPreferences.getString(AppConstants.prefFcmLastSyncedToken);
    AppConstants.fcmLastSyncedToken = v;
    return v;
  }

  @override
  Future<void> setFcmLastSyncedToken(String token) async {
    await _sharedPreferences.setString(
      AppConstants.prefFcmLastSyncedToken,
      token,
    );
    AppConstants.fcmLastSyncedToken = token;
  }

  @override
  Future<String?> getFcmDeviceToken() async {
    final v = _sharedPreferences.getString(AppConstants.prefFcmDeviceToken);
    AppConstants.fcmToken = v;
    return v;
  }

  @override
  Future<void> setFcmDeviceToken(String token) async {
    await _sharedPreferences.setString(AppConstants.prefFcmDeviceToken, token);
    AppConstants.fcmToken = token;
  }

  @override
  Future<bool> getMerchantHidePostConfirmEducation() async {
    return _sharedPreferences
            .getBool(AppConstants.prefMerchantHidePostConfirmEducation) ??
        false;
  }

  @override
  Future<void> setMerchantHidePostConfirmEducation(bool value) async {
    await _sharedPreferences.setBool(
      AppConstants.prefMerchantHidePostConfirmEducation,
      value,
    );
  }

  @override
  Future<void> clearStorage({bool clearAuthParams = false}) async {
    if (clearAuthParams) {
      await _sharedPreferences.remove(AppConstants.prefAccessToken);
      await _sharedPreferences.remove(AppConstants.prefUserRole);
      await _sharedPreferences.remove(AppConstants.prefUserId);
      await _sharedPreferences.remove(AppConstants.prefIsLoggedIn);
      await _sharedPreferences.remove(AppConstants.prefIsVerified);
      await _sharedPreferences.remove(AppConstants.prefPendingVerifyEmail);
      _applyCacheFromPrefs();
    }
  }
}
