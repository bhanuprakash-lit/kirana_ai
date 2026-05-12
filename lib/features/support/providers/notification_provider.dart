import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../auth/providers/user_provider.dart';

class NotificationService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  NotificationService(this._ref);

  Future<void> init() async {
    if (kDebugMode) {
      print('Initializing NotificationService...');
    }

    // 1. Request permissions
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized || 
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted notification permission: ${settings.authorizationStatus}');
      }
      
      // 2. Get and upload token
      await uploadToken();
      
      // 3. Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) {
        if (kDebugMode) {
          print('FCM Token refreshed: $newToken');
        }
        _uploadTokenToServer(newToken);
      });
    } else {
      if (kDebugMode) {
        print('User denied notification permissions');
      }
    }
  }

  Future<void> uploadToken() async {
    try {
      final token = await _fcm.getToken();
      if (kDebugMode) {
        print('Current FCM Token: $token');
      }
      if (token != null) {
        await _uploadTokenToServer(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM Token: $e');
      }
    }
  }

  Future<void> _uploadTokenToServer(String token) async {
    if (kDebugMode) {
      print('Attempting to upload token to server...');
    }

    try {
      // Use future to wait for the user to be available (handles race condition)
      final user = await _ref.read(userProvider.future);
      
      if (user == null) {
        if (kDebugMode) {
          print('Token upload skipped: User not logged in');
        }
        return;
      }

      final client = _ref.read(apiClientProvider);
      await client.post('/kirana/auth/fcm-token', {'fcm_token': token});
      
      if (kDebugMode) {
        print('FCM Token associated with user ${user.username} successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to upload FCM Token: $e');
      }
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});
