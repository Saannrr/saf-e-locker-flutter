import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Impor FirebaseAuth
import 'package:flutter/foundation.dart'; // Untuk kDebugMode
// import 'package:slock/services/auth_service.dart'; // Jika Anda ingin mengambil user dari AuthService

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final AuthService _authService = AuthService(); // Atau dapatkan via constructor/Provider

  bool _isInitialized =
      false; // Flag untuk memastikan inisialisasi hanya sekali jika perlu

  Future<void> initializeAndSaveToken() async {
    // Fungsi ini dipanggil setelah user dipastikan login
    if (_isInitialized) return; // Hindari re-inisialisasi yang tidak perlu

    await _initializeFCMListeners();
    await _initializeLocalNotifications();

    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token on initializeAndSaveToken: $token');
    }
    if (token != null) {
      await saveTokenToDatabase(token);
    }
    _isInitialized = true;
  }

  Future<void> _initializeFCMListeners() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Foreground Message data: ${message.data}');
        if (message.notification != null) {
          print('Foreground Message notification: ${message.notification}');
        }
      }
      if (message.notification != null) {
        showLocalNotification(message.notification!);
      }
    });
    // Handle notifikasi saat app dibuka dari background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message clicked! Data: ${message.data}');
      }
      // TODO: Handle navigasi atau aksi berdasarkan message.data
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // Pastikan icon ini ada
    // final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Untuk iOS versi lama
    // );
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          // iOS: initializationSettingsIOS,
        );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // Handler baru
    );
  }

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null && kDebugMode) {
  //     print('notification payload: $payload');
  //   }
  //   // TODO: Handle navigasi atau aksi berdasarkan payload
  // }

  Future<void> saveTokenToDatabase(String token) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // Atau: User? currentUser = _authService.currentUser;

    if (currentUser == null) {
      if (kDebugMode) {
        print('User not logged in. Cannot save FCM token.');
      }
      return;
    }
    String userUid = currentUser.uid;

    if (token.isEmpty) {
      if (kDebugMode) {
        print('FCM token is empty, not saving.');
      }
      return;
    }

    final DatabaseReference database = FirebaseDatabase.instance.ref();
    try {
      await database.child('users/$userUid/fcmTokens/$token').set(true);
      if (kDebugMode) {
        print('Saved FCM token to database: $token for user $userUid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving FCM token to database: $e');
      }
    }
  }

  void showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id_safelocker', // Ganti dengan ID channel Anda
          'Safelocker Notifications', // Ganti dengan nama channel Anda
          channelDescription: 'Notifications from Safelocker App',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    // const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      // payload: notification.data.toString(), // Sesuaikan payload jika ada
    );
  }
}
