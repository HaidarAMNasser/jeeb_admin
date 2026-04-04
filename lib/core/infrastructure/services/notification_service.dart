import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/notification/update_device_token/presentation/bloc/update_device_token_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

/// FCM + local notifications: foreground display, background/terminated handling,
/// and navigation when a notification is opened.
class NotificationService {
  NotificationService(
    this._tokenBloc,
    this._navigation,
    this._storage,
  );

  final UpdateDeviceTokenBloc _tokenBloc;
  final NavigationService _navigation;
  final StorageService _storage;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannelId = 'jeeb_fcm_default';
  static const _androidChannelName = 'General notifications';

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  Future<void> initialize() async {
    await _setupLocalNotifications();

    if (!kIsWeb && Platform.isAndroid) {
      await Permission.notification.request();
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) async {
      await _storage.setFcmDeviceToken(token);
      _tokenBloc.add(SubmitFcmTokenRequested(token: token));
    });

    _messageSubscription =
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    _openedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedFromBackground);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateFromPayload(initial.data);
      });
    }

    await _syncCurrentToken();
  }

  /// Call after login / verify success (non-blocking; safe if token is not ready yet).
  void requestSyncAfterLogin() {
    unawaited(_syncCurrentToken(forceSync: true));
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _androidChannelId,
          _androidChannelName,
          description: 'Firebase Cloud Messaging',
          importance: Importance.high,
        ),
      );
    }
  }

  Future<void> _syncCurrentToken({bool forceSync = false}) async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;
    await _storage.setFcmDeviceToken(token);
    _tokenBloc.add(
      SubmitFcmTokenRequested(token: token, forceSync: forceSync),
    );
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    final payload = jsonEncode({
      ...message.data,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
    });

    unawaited(
      _localNotifications.show(
        id: message.hashCode,
        title: title ?? 'Notification',
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannelId,
            _androidChannelName,
            channelDescription: 'Firebase Cloud Messaging',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      ),
    );
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final map = Map<String, dynamic>.from(
        jsonDecode(payload) as Map<dynamic, dynamic>,
      );
      _navigateFromPayload(map);
    } catch (_) {}
  }

  void _handleOpenedFromBackground(RemoteMessage message) {
    _navigateFromPayload(message.data);
  }

  void _navigateFromPayload(Map<String, dynamic> data) {
    final orderId = data['orderId'] ?? data['order_id'];
    if (orderId != null && orderId.toString().isNotEmpty) {
      _navigation.navigationKey.currentState?.pushNamed(
        Routes.orderDetails,
        arguments: {'orderId': orderId.toString()},
      );
      return;
    }

    final route = data['route']?.toString();
    if (route == Routes.orders || route == '/orders') {
      _navigation.navigationKey.currentState?.pushNamed(Routes.orders);
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _openedAppSubscription?.cancel();
  }
}
