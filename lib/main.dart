import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mission_ed/authenticate/authenticate_firebase.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/screens/home_screen.dart';
import 'package:mission_ed/screens/splash.dart';
import 'package:provider/provider.dart';
import 'screens/description_screen.dart';
import 'authenticate/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

/*var bigPictureStyleInformation = BigPictureStyleInformation(
  DrawableResourceAndroidBitmap("flutter_devs"),
  largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
  contentTitle: 'flutter devs',
  summaryText: 'summaryText',
);*/
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'Post Created') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Description(
                      postId: message.data['id'],
                    )));
      }
    });
    getToken();
    /* FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification=message.notification;
      AndroidNotification androidNotification=message.notification?.android;
      if(notification!=null&& androidNotification!=null){
       showDialog(context: context, builder: (_){
         return AlertDialog(
           title:Text(notification.title) ,
         );
       });
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
Future<String> getToken() async {
  String token = await FirebaseMessaging.instance.getToken();
  print('this is $token');
  return token;
}