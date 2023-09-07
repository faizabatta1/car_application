import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  static const String route = '/terms';

  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Terms And Condition Screen',style: TextStyle(
          fontSize: 24
        ),),
      ),
    );
  }
}
