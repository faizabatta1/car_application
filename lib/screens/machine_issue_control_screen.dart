import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/models/issue_data.dart';
import 'package:car_app/screens/machine_issue.dart';
import 'package:car_app/services/issue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'notification_issue_solve_data.dart'; // Import the screen for solving the issue

class MachineIssueControlScreen extends StatelessWidget {
  final IssueData issue;

  MachineIssueControlScreen({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset('assets/bil.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Issue in machine',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '${issue.serial}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '${issue.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                '${issue.date}',
                style: TextStyle(
                    fontSize: 18, color: ThemeHelper.buttonPrimaryColor),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Is Machine Fixed?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to NotificationIssueSolveData screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationIssueSolveData(issueData: issue),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: Text('Yes'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _showReasonDialog(
                        context); // Show the reason dialog for "No" option
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Redirect Issue'),
          content: Text(
            'Issue was sent',
            style: TextStyle(backgroundColor: ThemeHelper.buttonPrimaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MachineIssue()),
                );
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 300),
    );
  }

  void _showErrorPopup(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Feil'),
        content: Text('En feil oppstod: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to show a dialog for entering details when "No" is selected
  void _showReasonDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide details about the issue'),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Details...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (reasonController.text.isNotEmpty) {
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    await IssueService.notifyExternalSource(
                        reasonController.text, issue.id);
                    Navigator.pop(context);

                    _showSuccessPopup(context);
                  } catch (error) {
                    _showErrorPopup(context, error.toString());
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fill Details First')));
                }
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: ThemeHelper.buttonPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
