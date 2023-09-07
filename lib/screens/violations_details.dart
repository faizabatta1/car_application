import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/upload_violation_image.dart';
import 'package:flutter/material.dart';

class ViolationsDetails extends StatefulWidget {
  static const String route = '/postal';

  const ViolationsDetails({Key? key}) : super(key: key);

  @override
  State<ViolationsDetails> createState() => _ViolationsDetailsState();
}

class _ViolationsDetailsState extends State<ViolationsDetails> {
  TextEditingController reasonController = TextEditingController();
  TextEditingController violationNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController pnidController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    violationNumberController.dispose();
    pnidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                'Violation Number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: violationNumberController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'Violation Number',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Employee Pnid',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: pnidController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Pnid',
                  hintText: 'Employee Pnid',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Why do you want to send it?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: reasonController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Enter the reason',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Next" button click
                    String reason = reasonController.text;
                    String number = violationNumberController.text;
                    String pnid = pnidController.text;

                    if(_formKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return UploadViolationImage(
                              pnid: pnid,
                              number: number,
                              reason: reason,
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
                    }else{
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierLabel: 'Thi slAFD',
                        builder: (context) => AlertDialog(
                          title: Text('Feil'),
                          content: Text('Velg minst én sone, ukedag, periode, og skriv inn antall K.S.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK',style: TextStyle(
                                color: ThemeHelper.buttonPrimaryColor
                              ),),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ThemeHelper.buttonPrimaryColor, // Button background color
                    minimumSize: Size(140,0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

void main() {
  runApp(MaterialApp(
    home: ViolationsDetails(),
    debugShowCheckedModeBanner: false,
  ));
}
