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

  @override
  void dispose() {
    reasonController.dispose();
    kilometersDrivenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey, // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter the reason...',
                hintStyle: TextStyle(color: Colors.white54),
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
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter kilometers driven...',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Next" button click
                    String reason = reasonController.text;
                    String kilometers = kilometersDrivenController.text;

                    // You can add validation and navigation logic here

                    // For now, let's print the input values
                    print('Reason: $reason');
                    print('Kilometers Driven: $kilometers');

                    // Navigate to Form 1 screen to fill the form
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
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
            ),
          ],
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
