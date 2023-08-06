import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/shift_selection%20screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarNumberChoiceScreen extends StatefulWidget {
  @override
  _CarNumberChoiceScreenState createState() => _CarNumberChoiceScreenState();
}

class _CarNumberChoiceScreenState extends State<CarNumberChoiceScreen> {
  List<dynamic> carDataList = [];

  @override
  void initState() {
    super.initState();
    // Fetch car data from the API when the screen is initialized
    getCarData();
  }

  Future<void> getCarData() async {
    try {
      // Replace 'https://carapp-1f4w.onrender.com/api/cars' with your API endpoint
      var response = await http.get(Uri.parse('https://carapp-1f4w.onrender.com/api/cars'));
      if (response.statusCode == 200) {
        // Parse the response body and update the carDataList
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          carDataList = data;
        });
      } else {
        // Handle the error if the API call fails
        print('Failed to fetch car data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching car data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Car Number'),
        backgroundColor: ThemeHelper.buttonPrimaryColor,
        elevation: 0,
      ),
      body: Container(
        color: ThemeHelper.buttonPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: carDataList.length,
                  itemBuilder: (context, index) {
                    return buildCarCard(carDataList[index], context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarCard(Map<String, dynamic> carData, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ShiftChoiceScreen(
                selectedCarNumber: carData['boardNumber']!,
                selectedPrivateNumber: carData['privateNumber']!,
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  carData['boardNumber']!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Private Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  carData['privateNumber']!,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: ThemeHelper.buttonPrimaryColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
