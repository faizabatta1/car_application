import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostalService{
  static Future sendPostal({
    required String number,
    required String pnid,
    required String reason,
    required String image,
  }) async {
    try{
      final Uri uri = Uri.parse("https://test.bilsjekk.in/api/postals");
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('violation', image));
      request.fields['number'] = number;
      request.fields['pnid'] = pnid;
      request.fields['reason'] = reason;

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString('token');
      request.headers['token'] = token ?? '';


      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Postal Violation was uploaded successfully');
      } else {
        // Handle error response if needed
        print('Error uploading postal. Status code: ${response.statusCode}');

        throw await response.stream.bytesToString();
      }
    }catch(error){
        throw error.toString();
    }
  }
}