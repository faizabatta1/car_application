import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
// import 'package:unique_identifier/unique_identifier.dart';

class NotificationService{
  static Future getAllNotifications() async{
    try{
      final devicePlugin = DeviceInfoPlugin();
      AndroidDeviceInfo info = await devicePlugin.androidInfo;
      String serial = info.id;
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/notifications/imei/$serial');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        throw "Invalid Status Code";
      }
    }catch(error){
      throw error.toString();
    }
  }
}