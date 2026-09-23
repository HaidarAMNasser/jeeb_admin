# Store release prep notes (do not commit secrets)

## IDs
- Android applicationId / namespace: `com.zawada.zawada`
- iOS bundle id: `com.zawada.zawada`
- Display name: `zawada`

## Android signing
- Keystore: `android/app/upload-keystore.jks` (gitignored)
- Credentials: `android/key.properties` (gitignored)
- Backup the `.jks` + passwords offline. If lost, you cannot update the Play app.

## Firebase (REQUIRED before shipping)
1. Firebase Console → project `jeeb-f64a4`
2. Add Android app with package `com.zawada.zawada` → download `google-services.json`
3. Add iOS app with bundle `com.zawada.zawada` → download `GoogleService-Info.plist`
4. Replace:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - (optional root) `google-services.json`

Until you do this, FCM / Firebase may fail because the old app IDs were `com.example.*` / `com.zawada.app`.

## Google Maps
Restrict your Maps API key to `com.zawada.zawada` (Android SHA-1 from the upload keystore) and iOS bundle `com.zawada.zawada`.

Get Android SHA-1:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
```

## Production API
`AppConfig.isProduction = true` → `https://api.jeeb2.com/api/v1/`
For local/dev, set `isProduction = false`.

## Build for stores
```bash
flutter clean
flutter build appbundle --release
flutter build ipa --release   # Mac + Xcode required
```
