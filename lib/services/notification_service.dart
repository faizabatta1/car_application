import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

class NotificationService{
  static Future getAllNotifications() async{
    try{

      String? serial = await UniqueIdentifier.serial;
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/notifications');
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