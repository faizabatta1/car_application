import 'package:car_app/screens/shift_selection%20screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/theme_helper.dart';

class KilometerScreen extends StatelessWidget {
  final String selectedCarNumber;
  final String selectedPrivateNumber;

  KilometerScreen({
    Key? key,
    required this.selectedCarNumber,
    required this.selectedPrivateNumber,
  }) : super(key: key);

  final TextEditingController _kilometerController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.black12,
        height: 70,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ShiftChoiceScreen(
                    selectedCarNumber: selectedCarNumber,
                    selectedPrivateNumber: selectedPrivateNumber,
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
          child: Text(
            'Skip',
            style: TextStyle(
              fontSize: 20,
              color: ThemeHelper.buttonPrimaryColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _kilometerController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Enter something first";
                    }
                  }
                  return null;
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter kilometers",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ShiftChoiceScreen(
                            selectedCarNumber: selectedCarNumber,
                            selectedPrivateNumber: selectedPrivateNumber,
                            kilometers: int.parse(_kilometerController.text),
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
                  }
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: ThemeHelper.buttonPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

