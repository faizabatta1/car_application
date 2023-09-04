import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String,dynamic>> dummyData = List.generate(20, (index) => {
    'title': 'New Assignment',
    'message': 'You have a new assignment to grade.',
    'time': '10 min ago',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: dummyData.length, // Replace with your desired number of items
          itemBuilder: (context, index) {


            final notification = dummyData[index];
            return _buildNotification(
              title: notification['title'],
              message: notification['message'],
              time: notification['time'],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildNotification({
  required String title,
  required String message,
  required String time
}) {
  return Card(
    elevation: 5.0,
    color: Colors.blueGrey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_none_outlined, size: 48.0, color: Colors.white),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text(message),
                SizedBox(height: 8.0),
                Align(
                    child: Text(time, style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

