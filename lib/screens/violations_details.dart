import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/upload_violation_image.dart';
import 'package:flutter/material.dart';

class ViolationsDetails extends StatefulWidget {
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value != null){
                    if(value.isEmpty){
                      return "Enter something";
                    }

                    return null;
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter violation number',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value != null){
                    if(value.isEmpty){
                      return "Enter something";
                    }

                    return null;
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter kilometers driven',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value != null){
                    if(value.isEmpty){
                      return "Enter something";
                    }

                    return null;
                  }

                  return null;
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter the reason',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Next" button click
                    String reason = reasonController.text;
                    String kilometers = violationNumberController.text;

                    if(_formKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return UploadViolationImage();
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
                    primary: Colors.teal, // Button background color
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
