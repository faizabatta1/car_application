import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';


class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF3F4F8),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App navn',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Bilsjekk',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Versjon',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '1.6.1 beta',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Bruker-ID',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Pn167',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Enhets-ID',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'TE1A.220922.010',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),

                    SizedBox(height: 120.0),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '© 2023 en del av Gensolv.no',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
