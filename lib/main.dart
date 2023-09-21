import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/machine_issue.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:car_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as SC;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'Nordic_Channel_4', // id
    'Nordic Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert')
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse){
    if(notificationResponse.payload != null){
      Map data = jsonDecode(notificationResponse.payload!);

      Navigator.of(navigatorKey.currentState!.context).push(
          MaterialPageRoute(builder: (context) => MachineIssue())
      );
    }
  }

  flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse ,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);



  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showFlutterNotification(String title,String body) async {


  if (!kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'id',
                'action title',
                showsUserInterface: true
              )
            ],
          playSound: true,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@drawable/ic_launcher_foreground',
          importance: Importance.high,
          priority: Priority.max
        ),
      ),
    );


  }
}
Future<void> showFlutterFirebaseNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? androidNotification = notification?.android;

  print(message);
  print(notification);
  print(androidNotification);
  if (!kIsWeb) {

    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['notes'],
        message.data['issue'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          playSound: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
                'id',
                'open issue',
                showsUserInterface: true
            )
          ],

          subText: "this is my sub text",
          styleInformation: BigTextStyleInformation(
            '<h1>Big Text   Content</h1>',
            contentTitle: '<font color="red">Title Html</font>',
            summaryText: 'Summary Text',
            htmlFormatBigText: true,
            htmlFormatContentTitle: true,
            htmlFormatContent: true,
            htmlFormatTitle: true,
            htmlFormatSummaryText: true
          ),

          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@drawable/ic_launcher_foreground',
          importance: Importance.high,
          priority: Priority.max
        ),
      ),
      payload: jsonEncode(message.data)
    );


  }
}


Future<void> requestNotificationPermission() async {
  await Permission.notification.isDenied.then((value) async{
    if (value) {
      Permission.notification.request();
    }
  });
}




Future<String> getAndroidId() async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String androidId = sharedPreferences.getString('androidId') ?? '';
    print(androidId);
    return androidId;
  }catch(error){
    return "";
  }
}


Future<void> requestStoragePermission() async {
  if(await Permission.storage.isDenied){
    await Permission.storage.request();
  }
}


Future<void> requestPhonePermission() async {
  if(await Permission.phone.isDenied){
    await Permission.phone.request();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data['title']);

  await setupFlutterNotifications();
  if(message.data['type'] == 'users'){
    print(message.data['title']);
    print(message.data['body']);
    await showFlutterNotification(message.data['title'],message.data['body']);
  }else if(message.data['type'] == 'device'){
    String encoded = message.data['imei'];
    List imeis = jsonDecode(encoded);
    if(imeis.contains(await getAndroidId())){
      await showFlutterNotification(message.data['title'],message.data['body']);
    }
  }else if(message.data['type'] == 'zone'){
    String encoded = message.data['imeis'];
    String imei = await getAndroidId();
    List imeis = jsonDecode(encoded);
    if(imeis.contains(imei)){
      await showFlutterNotification(message.data['title'],message.data['body']);
    }
  }else if(message.data['type'] == 'machine'){
    print("data is ${message.data}");
    await showFlutterFirebaseNotification(message);
  }else if(message.data['type'] == 'issue_closed'){
    await showFlutterNotification(message.data['title'], message.data['body']);
  }else{
    print('not');
  }
}



class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      // App is in the foreground
        print('App is in the foreground');
        break;
      case AppLifecycleState.inactive:
      // App is in an inactive state (e.g., when a call comes in)
        print('App is in an inactive state');
        break;
      case AppLifecycleState.paused:
      // App is in the background
        print('App is in the background');
        break;
      case AppLifecycleState.detached:
      // App is detached (e.g., when the app is terminated)
        print('App is detached');
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  await requestStoragePermission();
  await requestPhonePermission();
  // await requestNotificationPermission();

  await Firebase.initializeApp();
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await setupFlutterNotifications();


  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    if(message.data['type'] == 'users'){
      print(message.data['title']);
      print(message.data['body']);
      await showFlutterNotification(message.data['title'],message.data['body']);
    }else if(message.data['type'] == 'device'){
      String encoded = message.data['imei'];
      List imeis = jsonDecode(encoded);
      if(imeis.contains(await getAndroidId())){
        await showFlutterNotification(message.data['title'],message.data['body']);
      }
    }else if(message.data['type'] == 'zone'){
      String encoded = message.data['imeis'];
      String imei = await getAndroidId();
      List imeis = jsonDecode(encoded);
      if(imeis.contains(imei)){
        await showFlutterNotification(message.data['title'],message.data['body']);
      }
    }else if(message.data['type'] == 'machine'){
      await showFlutterFirebaseNotification(message);
    }else if(message.data['type'] == 'issue_closed'){
      await showFlutterNotification(message.data['title'], message.data['body']);
    }else{
      print('not');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.subscribeToTopic('nordic');

  NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if(notificationAppLaunchDetails?.didNotificationLaunchApp ?? false){
    print('Strange Act .......................');
    if(notificationAppLaunchDetails?.notificationResponse?.payload != null){
      Navigator.of(navigatorKey.currentState!.context).push(
          MaterialPageRoute(builder: (context) => MachineIssue())
      );
    }
  }else{
    print('noooooooooooooooooooooooooooooo');
  }

  // await initializeService();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  // await initializeService();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString('token');

  runApp(AppEntryPoint(token: token));
}

class AppEntryPoint extends StatefulWidget {
  final String? token;
  const AppEntryPoint({super.key,required this.token});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  final platform = const MethodChannel('unique_id');

  Future<void> saveAndroidId() async {
    try {
      final String androidId = await platform.invokeMethod('getAndroidId');
      print(androidId);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('androidId', androidId);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    saveAndroidId();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'BilSjekk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeHelper.secondaryColor,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)
          )
        )
      ),

      home: SplashScreen(token: widget.token),
    );
  }
}


