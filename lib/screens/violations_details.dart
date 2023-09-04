import 'package:car_app/screens/upload_violation_image.dart';
import 'package:flutter/material.dart';

class ViolationsDetails extends StatefulWidget {
  const ViolationsDetails({Key? key}) : super(key: key);

  @override
  State<ViolationsDetails> createState() => _ViolationsDetailsState();
}

class _ViolationsDetailsState extends State<ViolationsDetails> {
  TextEditingController reasonController = TextEditingController();
  TextEditingController kilometersDrivenController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    reasonController.dispose();
    kilometersDrivenController.dispose();
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
                'Why do you want to send it?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              SizedBox(height: 16),
              Text(
                'Kilometers Driven by Car',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: kilometersDrivenController,
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
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Next" button click
                    String reason = reasonController.text;
                    String kilometers = kilometersDrivenController.text;

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Missing required fields'))
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
