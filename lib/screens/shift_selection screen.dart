import 'package:car_app/helpers/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreen.dart';

class ShiftChoiceScreen extends StatefulWidget {
  final String selectedCarNumber;
  final String selectedPrivateNumber;

  ShiftChoiceScreen({required this.selectedCarNumber, required this.selectedPrivateNumber});

  @override
  _ShiftChoiceScreenState createState() => _ShiftChoiceScreenState();
}

class _ShiftChoiceScreenState extends State<ShiftChoiceScreen> {
  String selectedDay = '';
  String selectedPeriod = '';
  List<String> selectedZones = [];
  int trafficViolations = 0;
  List<String> zones = [];
  List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> periods = ['Day', 'Night', 'Weekend'];

  @override
  void initState() {
    super.initState();
    getZoneData();
  }

  Future<void> getZoneData() async {
    try {
      var response = await http.get(Uri.parse('https://carapp-1f4w.onrender.com/api/locations'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          zones = data.map((zoneData) => zoneData['location']).cast<String>().toList();
        });
      } else {
        print('Failed to fetch zone data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching zone data: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Selected Car',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "board: ${widget.selectedCarNumber}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20.0,),
                    Text(
                      'private: ${widget.selectedPrivateNumber}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildMultiSelectZoneDropdown(),
                SizedBox(height: 20),
                Text(
                  'Choose Day of the Week:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                buildDayOfWeekButtons(),
                SizedBox(height: 20),
                Text(
                  'Choose Period:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                buildPeriodButtons(),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      trafficViolations = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of traffic violations.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Number Of Violations',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedZones.isNotEmpty &&
                        selectedDay.isNotEmpty &&
                        selectedPeriod.isNotEmpty &&
                        trafficViolations > 0) {
                      Map data = {
                        'locations': selectedZones,
                        'day': selectedDay,
                        'period': selectedPeriod,
                        'boardNumber': widget.selectedCarNumber,
                        'privateNumber': widget.selectedPrivateNumber,
                        'trafficViolations': trafficViolations,
                        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
                      };

                      SharedPreferences shared = await SharedPreferences.getInstance();
                      await shared.setString('data', jsonEncode(data));

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Form1Screen();
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Please choose at least one zone, the day of the week, period, and enter the number of traffic violations.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.buttonPrimaryColor,
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMultiSelectZoneDropdown() {
    return GestureDetector(
      onTap: _showMultiSelectZoneOptionsDialog,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedZones.isEmpty
                  ? Text(
                'Choose Zone',
                style: TextStyle(fontSize: 18),
              )
                  : Text(
                selectedZones.join(','),
                style: TextStyle(fontSize: 18),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectZoneOptionsDialog() async{
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context,setState){
          return AlertDialog(
            title: Text('Choose Zones'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedZones.map((zone) {
                      return Chip(
                        label: Text(zone),
                        onDeleted: () {
                          setState(() {
                            selectedZones.remove(zone);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  ...zones.map((zone) {
                    bool isSelected = selectedZones.contains(zone);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedZones.remove(zone);
                          } else {
                            if(!selectedZones.contains(zone)){
                              selectedZones.add(zone);
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              zone,
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isSelected ? ThemeHelper.buttonPrimaryColor : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Done'),
              ),
            ],
          );
        },
      ),
    );

    setState(() {});
  }




  Widget buildDayOfWeekButtons() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: daysOfWeek.map((day) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedDay = day;
              if (day == 'Saturday' || day == 'Sunday') {
                selectedPeriod = 'Weekend';
              } else {
                selectedPeriod = '';
              }
            });
          },
          style: ElevatedButton.styleFrom(
            primary: selectedDay == day ? ThemeHelper.buttonPrimaryColor : Colors.grey,
          ),
          child: Text(day),
        );
      }).toList(),
    );
  }

  Widget buildPeriodButtons() {
    List<String> availableShifts = selectedDay == 'Saturday' || selectedDay == 'Sunday'
        ? ['Weekend', 'Day', 'Night']
        : ['Day', 'Night'];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: periods.map((period) {
        if (availableShifts.contains(period)) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                selectedPeriod = period;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: selectedPeriod == period ? ThemeHelper.buttonPrimaryColor : Colors.grey,
            ),
            child: Text(period),
          );
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }}
