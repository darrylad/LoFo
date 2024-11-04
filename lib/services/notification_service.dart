import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool areNotificationsEnabled = false;
bool enabledNotificationSubscription = false;

class NotificationService {
  static String fcmDeviceToken = '';

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@drawable/ic_stat_mono');
    var darwinInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        carPlay: true,
        criticalAlert: true,
        announcement: true,
        provisional: true,
        sound: true,
        badge: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      areNotificationsEnabled = true;
      debugPrint("Notification authorization status is authorized");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      areNotificationsEnabled = true;
      debugPrint("Notification authorization status is provisional");
    } else {
      areNotificationsEnabled = false;
      debugPrint("Notification authorization status is not determined");
    }
  }

  Future<bool> checkNotificationPermission() async {
    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      areNotificationsEnabled = true;
      debugPrint("Notification authorization status is authorized");
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      areNotificationsEnabled = true;
      debugPrint("Notification authorization status is provisional");
      return true;
    } else {
      areNotificationsEnabled = false;
      debugPrint(
          "Notification authorization status is not authorized or determined");
      return false;
    }
  }

  Future<String?> getFCMDeviceToken() async {
    String? token = await messaging.getToken();
    debugPrint(" ####### Getting FCM Device Token");
    debugPrint(token);
    fcmDeviceToken = token!;
    return token;
  }

  bool hasTokenRefreshed() {
    bool hasTokenRefreshed = false;

    messaging.onTokenRefresh.listen((token) {
      hasTokenRefreshed = true;
      fcmDeviceToken = token;
      debugPrint(" ######### FCM Device Token has been refreshed");
      debugPrint(token);
    });

    return hasTokenRefreshed;
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("######### Message received");
      debugPrint(message.notification!.title);
      debugPrint(message.notification!.body);
      showNotification(message);

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // AndroidNotificationChannel channel = AndroidNotificationChannel(
    //     Random.secure().nextInt(100000).toString(),
    //     'High Importance Notifications');

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification?.body.toString(),
          notificationDetails);
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> disableNotifications() async {
    // 1. Unsubscribe from Firebase topics (optional, depends on your app)
    // await FirebaseMessaging.instance.unsubscribeFromTopic('your_topic');

    // 2. Delete the FCM token to stop receiving notifications
    await messaging.deleteToken();

    // 3. Optionally: Unregister any active notification listeners if applicable
    // If you've set any listeners for notifications, remove them here
    // For example:
    // _notificationStreamSubscription?.cancel();

    // 4. (Optional) Provide instructions to revoke notification permissions
    debugPrint('Notifications disabled. Token deleted and listeners stopped.');
  }

  Future<void> uploadDeviceToken() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      if (fcmDeviceToken.isNotEmpty) {
        // Reference to the user's document in Firestore
        DocumentReference userDoc =
            firestore.collection('userNotiTokens').doc(loginID);

        // Upload the token to Firestore under the user's document
        await userDoc.set({
          'token': fcmDeviceToken,
        }, SetOptions(merge: true));

        debugPrint("Device token uploaded: $fcmDeviceToken");
      } else {
        debugPrint("Failed to get device token");
      }
    } catch (e) {
      debugPrint("Error uploading device token: $e");
    }
  }

  Future<void> deleteUserDeviceToken() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('userNotiTokens').doc(loginID).delete();
    } catch (e) {
      debugPrint("Error deleting user device token: $e");
    }
  }

  Future<void> uploadSecurityDeviceToken() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      if (fcmDeviceToken.isNotEmpty) {
        // Reference to the user's document in Firestore
        DocumentReference userDoc =
            firestore.collection('securityNotiTokens').doc(loginID);

        // Upload the token to Firestore under the user's document
        await userDoc.set({
          'token': fcmDeviceToken,
        }, SetOptions(merge: true));

        debugPrint("Device token uploaded: $fcmDeviceToken");
      } else {
        debugPrint("Failed to get device token");
      }
    } catch (e) {
      debugPrint("Error uploading device token: $e");
    }
  }

  Future<void> deleteSecuityDeviceToken() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('securityNotiTokens').doc(loginID).delete();
    } catch (e) {
      debugPrint("Error deleting security device token: $e");
    }
  }

  Future<void> subsribsibeUsersToTopic() async {
    await messaging.subscribeToTopic("allUsers");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('subscribedToAllUsers', true);
    enabledNotificationSubscription = true;

    debugPrint("#### Subscribed to allUsers topic");
  }

  Future<void> subsribsibeSecurityToTopic() async {
    await messaging.subscribeToTopic("allSecurity");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('subscribedToAllSecurity', true);
    enabledNotificationSubscription = true;

    debugPrint("#### Subscribed to allSecurity topic");
  }

  Future<void> unsubscribeUsersFromTopic() async {
    await messaging.unsubscribeFromTopic("allUsers");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('subscribedToAllUsers', false);
    enabledNotificationSubscription = false;

    debugPrint("#### Unsubscribed from allUsers topic");
  }

  Future<void> unsubscribeSecurityFromTopic() async {
    await messaging.unsubscribeFromTopic("allSecurity");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('subscribedToAllSecurity', false);
    enabledNotificationSubscription = false;

    debugPrint("#### Unsubscribed from allSecurity topic");
  }

  Future<void> completelyDisableNotifications() async {
    await unsubscribeUsersFromTopic();
    await unsubscribeSecurityFromTopic();
    await deleteUserDeviceToken();
    await deleteSecuityDeviceToken();
    await disableNotifications();
  }
}
