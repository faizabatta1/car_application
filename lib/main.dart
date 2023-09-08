import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:unique_identifier/unique_identifier.dart';


Future<void> setupFlutterNotification() async{
  AwesomeNotifications().initialize(
      null,
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'basic',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
            defaultColor: Color(0xFF5088DD),
            ledColor: Colors.white,
          playSound: true
        ),

        NotificationChannel(
            channelGroupKey: 'image_test',
            channelKey: 'image',
            channelName: 'image notifications',
            channelDescription: 'Notification channel for image tests',
            defaultColor: Colors.redAccent,
            ledColor: Colors.white,
            channelShowBadge: true,
            importance: NotificationImportance.High
        )

        //add more notification type with different configuration

      ]
  );
}

Future<void> showFlutterNotification(String title,String body) async {
  if (!kIsWeb) {
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    }else{
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent( //simgple notification
            id: 123,
            channelKey: 'basic', //set configuration wuth key "basic"
            title: title,
            body: body,
          )
      );
    }
  }
}


Future<void> requestNotificationPermission() async {
  await Permission.notification.isDenied.then((value) async{
    if (value) {
      await Permission.notification.request();
    }
  });
}


Future initializeSocketNotificationChannel() async{
  String? identifier = await UniqueIdentifier.serial;
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
  socket.onConnectError((err) => print(err.toString()) );
  socket.onError((err) => print(err.toString()));

  // Listen for messages from the server
  socket.on('devices', (data) async{
    String? identifier =await UniqueIdentifier.serial;
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
    String? identifier =await UniqueIdentifier.serial;
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
  await requestNotificationPermission();
  await setupFlutterNotification();

  try{
    await initializeSocketNotificationChannel();
  }catch(error){
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


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await requestNotificationPermission();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  await initializeService();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString('token');
  if(!sharedPreferences.containsKey('notified')){
    await sharedPreferences.setBool('notified',false);
  }

  runApp(AppEntryPoint(token: token));
}

class AppEntryPoint extends StatelessWidget {
  final String? token;
  const AppEntryPoint({super.key,required this.token});

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

      home: SplashScreen(token: token),
    );
  }
}


