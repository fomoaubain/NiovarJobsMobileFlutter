//@dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/services/LocalNotificationService.dart';
import 'package:niovarjobs/src/MesAffectations.dart';
import 'package:niovarjobs/src/MesCandidatures.dart';
import 'package:niovarjobs/src/MesContratTravail.dart';
import 'package:niovarjobs/src/MesLocationsCdt.dart';
import 'package:niovarjobs/src/Splaschscreen.dart';
import 'package:niovarjobs/src/mesTalonPaie.dart';
import 'package:niovarjobs/src/notificationPage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'src/homePage.dart';
import 'package:flutter/services.dart';


/*const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();*/

Future<void> BackgroundHandler(RemoteMessage message) async {
  print("background "+message.data.toString());
  print("background "+message.notification.title.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(BackgroundHandler);

  /*  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  ); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child:MaterialApp(
        routes: {
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/notification': (context) =>  NotificationPage(),
          '/candidature': (context) =>  MesCandidatures(),
          '/affectation': (context) =>  MesAffectations(),
          '/contrat': (context) =>  MesContratTravail(),
          '/talon': (context) =>  MesTalonPaie(),
          '/location': (context) =>  MesLocationsCdt(),
          //'/paiement': (context) =>  MesTalonPaie(),
        },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Splaschscreen(title: ''),
      ),

    );


  }
}

