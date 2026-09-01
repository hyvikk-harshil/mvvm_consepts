import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

// 1. This MUST be a top-level function outside of any class layout
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Always initialize Firebase here if you intend to interact with other Firebase services inside this handler
  await Firebase.initializeApp();
  print("--->Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initializeNotifications() async {
    // 2. Request user permissions (Required for iOS & Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('--->User granted notification permissions!');
    }

    // 3. Register your background message handler hook
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4. Handle Foreground Messages (When app is wide open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('--->Got a message while in the foreground! ${message.messageId}');
      if (message.notification != null) {
        final title = message.notification!.title ?? 'Notification Received';
        final body = message.notification!.body ?? '';
        print('--->Message Title: $title');
        print('--->Message Body: $body');
        // Note: For Android foreground banners, you will need to trigger
        // a local notification utilizing the `flutter_local_notifications` package.

        // 🟢 FIX: Trigger the custom banner using the safe State Handler
        ForegroundBanner.show(
          title: title,
          message: body
        );
      }
    });

    // 5. Handle Taps on Notifications when the app was in the Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('--->Notification tapped while app was in background state!');
      // Use your navigation framework here to route to specific screens
    });

    // 6. Fetch and print the unique device registration token
    String? token = await _fcm.getToken();
    print("--->FCM Device Token: $token");
  }
}



// 🟢 Custom Zero-Dependency Notification UI Component using direct Overlay State
class ForegroundBanner {
  static void show({required String title, required String message}) {
    // 1. Get the current state of our global GoRouter navigator
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) return;
    // 2. FIX: Safely retrieve the OverlayState directly from the Navigator State
    // This bypasses the upward lookup tree context error entirely!
    final overlayState = navigatorState.overlay;
    if (overlayState == null) return;
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Fallback value handling if MediaQuery context isn't fully ready during early screen builds
        top: MediaQuery.maybePaddingOf(context)?.top ?? 24.0 + 12.0,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              //color: Colors.black45.withValues(alpha: 0.92),
              border: Border.all(width: 0.5,color: Colors.redAccent),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 18,
                  child: Icon(Icons.notifications_active, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Render directly inside the application's root overlay manager layer
    overlayState.insert(overlayEntry);

    // Auto-dismiss execution logic loop
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
