import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'Nordic Channel 1', // id
    'Nordic Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert')
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
          playSound: true,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
          importance: Importance.high,
          priority: Priority.max
        ),
      ),
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
    String androidId = sharedPreferences.getString('androidId') ?? 'XD';
    print(androidId);
    return androidId;
  }catch(error){
    return "";
  }
}

Future initializeSocketNotificationChannel() async{
  String identifier = await getAndroidId();
  // Connect to the WebSocket server
  IO.Socket socket = IO.io(
    'wss://test.bilsjekk.in',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build()
  ); // Replace with your server address
  socket.onConnect((_) {
    print('Connection established');
    socket.emit('imei', identifier);
  });
  socket.onDisconnect((_) => print('Connection Disconnection'));
  socket.onConnectError((err) async => print(err.toString()) );
  socket.onError((err) async => print(err.toString()));

  // Listen for messages from the server
  socket.on('devices', (data) async{
    String identifier = await getAndroidId();
    Map decoded = jsonDecode(data);
    if((decoded['imeis'] as List).contains(identifier)){
      await showFlutterNotification(decoded['title'], decoded['body']);
    }
  });

  socket.on('users',(data) async{
    Map decoded = jsonDecode(data);
    await showFlutterNotification(decoded['title'], decoded['body']);
  });

  socket.on('zones',(data) async{
    String identifier = await getAndroidId();
    Map decoded = jsonDecode(data);
    print(decoded);
    if((decoded['imeis'] as List).contains(identifier)){
      await showFlutterNotification(decoded['title'], decoded['body']);
    }
  });

  socket.connect();
}

@pragma('vm:entry-point')
Future onStart(ServiceInstance instance) async{
  DartPluginRegistrant.ensureInitialized();
  await setupFlutterNotifications();

  try{
    await initializeSocketNotificationChannel();
  }catch(error){
    print(error.toString());
    await showFlutterNotification('Error', error.toString());
  }
}

Future initializeService() async{
  final service = FlutterBackgroundService();
  if(!(await service.isRunning())){
    await service.configure(
        iosConfiguration: IosConfiguration(),
        androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            autoStart: true,
            autoStartOnBoot: true,
            isForegroundMode: true
        )
    );

    await service.startService();
  }
}

Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission granted. You can now read files.
  } else {
    // Permission denied.
  }
}


Future<void> requestPhonePermission() async {
  if(await Permission.phone.isDenied){
    await Permission.phone.request();
  }
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await requestStoragePermission();
  await requestPhonePermission();
  await requestNotificationPermission();

  await initializeService();
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
      title: 'BilSjekk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeHelper.secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeHelper.secondaryColor,
        )
      ),

      home: SplashScreen(token: widget.token),
    );
  }
}


