import 'package:flutter/material.dart';

import '../models/issue_notification_data.dart';
import '../widgets/complete_issues_tab.dart';
import '../widgets/current_issues_tab.dart';
import '../widgets/notifications_tab.dart';
import 'machine_issue_control_screen.dart';

class MachineIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20,),
            TabBar(
              tabs: [
                Tab(text: 'Current Issues'),
                Tab(text: 'Completed'),
                Tab(text: 'Notifications'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Current Issues
                  CurrentIssuesTab(),

                  CompletedIssuesTab(),

                  // Tab 2: Notifications
                  NotificationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

