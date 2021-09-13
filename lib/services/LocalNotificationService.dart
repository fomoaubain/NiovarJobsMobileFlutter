


import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
static final  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

static void initialize(){
  final InitializationSettings initializationSettings =
      InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher")
      );
_flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

static void display(RemoteMessage message) async {
  try{
    Random random = new Random();
    final int id = random.nextInt(100);
    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "niovarjobschannel",
          "niovarjobschannel channel",
          "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        )
    );
    await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails
    );

  }on Exception catch(e){
    print(e);
  }



}

}