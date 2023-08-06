import 'dart:convert';
import 'dart:io';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/car_number_choice.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:car_app/services/driver_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/home.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),

            FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(snapshot.hasError){
                  return Center(
                    child: Text("Something Went Wrong"),
                  );
                }

                if(snapshot.data != null){
                  return Text(
                    'Hei ${snapshot.data!.getString('user')}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                return Container();
              },
            ),
            SizedBox(height: 10),
            Text(
              'Du skal alltid se over bilen og forsikre deg om at den er iht. Reglement før du kjører ut. Det erdu som sjåfør som er ansvarlig for at bilen du kjører er I forsvalig stand.Blir du stoppet av politi / bilsakkyndig I bil som ikke er I forsvarlig stand, er det du som sjåførsom blir holdt ansvarlig',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      if(await canLaunchUrl(Uri.parse('https://skademelding.naf.no/opprett'))){
                        launchUrl(Uri.parse('https://skademelding.naf.no/opprett'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor
                    ),
                    icon: Icon(Icons.web),
                    label: Text('Skademelding'),
                  ),
                ),
                SizedBox(width: 12.0,),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      if(await canLaunchUrl(Uri.parse('tel:+4747931499'))){
                        launchUrl(Uri.parse('tel:+4747931499'));
                      }
                    },
                    icon: Icon(Icons.phone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor
                    ),
                    label: Text('Heshmet'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Form 1 screen to fill the form
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CarNumberChoiceScreen();
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
                  minimumSize: Size(double.infinity,40),
                backgroundColor: ThemeHelper.buttonPrimaryColor

              ),
              icon: Icon(Icons.drive_eta),
              label: Text(
                'Fylle ut skjemaet',
                style: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: () async{
                SharedPreferences shared = await SharedPreferences.getInstance();
                if (shared.containsKey('token')) await shared.remove('token');

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SplashScreen(token: null);
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
                  minimumSize: Size(double.infinity,40),
                  backgroundColor: Colors.red

              ),
              icon: Icon(Icons.logout),
              label: Text(
                'Logg ut',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Form1Screen extends StatefulWidget {
  @override
  _Form1ScreenState createState() => _Form1ScreenState();
}

class _Form1ScreenState extends State<Form1Screen> {


  List<Map<String, dynamic>> form1Results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text('First Form'),
        backgroundColor: ThemeHelper.buttonPrimaryColor,
      ),
      body: FutureBuilder(
        future: DriverService.getFormFields(formName: 'First'), builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircularProgressIndicator(
                    backgroundColor: ThemeHelper.buttonPrimaryColor,
                  ),
                  SizedBox(height: 12.0,),
                  Text('Loading First Form',style: TextStyle(
                    fontSize: 20
                  ),)
                ],
              ),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text("Something Went Wrong"),
            );
          }

          if(snapshot.data != null){
            return FormCard(
              formFields: snapshot.data!,
              results: form1Results,
              onFormSubmitted: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Form2Screen(form1Results);
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
            );

          }else{
            return Text('');
          }

      },
      ),
    );
  }
}

class Form2Screen extends StatefulWidget {
  final List<Map<String, dynamic>> form1Results;

  Form2Screen(this.form1Results);

  @override
  _Form2ScreenState createState() => _Form2ScreenState();
}

class _Form2ScreenState extends State<Form2Screen> {

  List<Map<String, dynamic>> form2Results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text('Second Form'),
        backgroundColor: ThemeHelper.buttonPrimaryColor,
      ),
      body: FutureBuilder(
        future: DriverService.getFormFields(formName: 'Second'), builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircularProgressIndicator(
                    backgroundColor: ThemeHelper.buttonPrimaryColor,
                  ),
                  SizedBox(height: 12.0,),
                  Text('Loading Second Form',style: TextStyle(
                      fontSize: 20
                  ),)
                ],
              ),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text("Something Went Wrong"),
            );
          }


          return FormCard(
            formFields: snapshot.data!,
            results: form2Results,
            onFormSubmitted: () {
              // Merge Form 1 and Form 2 results before navigating to DriverProfileScreen
              List<Map<String, dynamic>> combinedResults = [...widget.form1Results, ...form2Results];

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DriverProfileScreen(combinedResults);
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
          );
      },
      ),
    );
  }
}



class FormCard extends StatefulWidget {
  final List formFields;
  final List<Map<String, dynamic>> results;
  final VoidCallback onFormSubmitted;





  FormCard({required this.formFields, required this.results, required this.onFormSubmitted});

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  Map<String, dynamic> _formValues = {};
  String? _imageFilePath;

  String _readFileName = "";
  String? _readFilePath;
  int currentIndex = 0;
  Map<String, bool> _showYesFields = {};
  GlobalKey<FormState>? _formKey;
  void nextPage() {
    if (currentIndex < widget.formFields.length - 1) {
      currentIndex++;
      setState(() {});
      _pageController.nextPage(duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
    }else{
          widget.results.clear();
          _formKey = null;
          for (var key in _formValues.keys) {
            widget.results.add({
              'title': key,
              'value': _formValues[key],
              'answerDataType': widget.formFields.firstWhere((field) => field['title'] == key)['answerDataType'],
              'id': widget.formFields.firstWhere((field) => field['title'] == key)['_id'],
              'group': widget.formFields.firstWhere((field) => field['title'] == key)['group']['_id'],
              'form': widget.formFields.firstWhere((field) => field['title'] == key)['form'],
            });
          }

      widget.onFormSubmitted();
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      currentIndex--;
      _pageController.previousPage(duration: Duration(milliseconds: 1000), curve: Curves.easeInOutCubic);
      setState(() {});
    }
  }

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> field_ = widget.formFields.isEmpty ? {} : widget.formFields[currentIndex];
    bool showYesField = _showYesFields[field_['title']] ?? false;
    _formKey = GlobalKey<FormState>();

    return Scaffold(
      bottomNavigationBar: Visibility(
          visible: currentIndex < widget.formFields.length || widget.formFields.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton(
                    child: Text('Tilbake'.toUpperCase(),style: TextStyle(
                      fontSize: 18
                    ),),
                    onPressed: previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Neste'.toUpperCase(),style: TextStyle(
                      fontSize: 18
                    ),),
                    onPressed: (){
                      if(_formKey!.currentState!.validate()){
                        nextPage();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor,
                    ),
                  ),
                // if (currentIndex == widget.formFields.length - 1)
                  // ElevatedButton(
                  //   child: Text('Go Profile'),
                  //   onTap: getDetailAPi,
                  // ),
              ],
            ),
          )),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: widget.formFields.map((field){
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(widget.formFields.isNotEmpty)
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(field['title'],style: TextStyle(
                            fontSize: 20
                        ),),
                        SizedBox(height: 20,),
                        if (field['answerDataType'] == 'text')
                          TextFormField(
                            onChanged: (value) {
                              _formValues[field['title']] = value;
                            },
                            validator: (val){
                              if(val!.isEmpty){
                                return "Please Enter Something";
                              }

                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                labelText: 'Type Text Here',
                                hintText: field['requiredDescription'],
                                border: OutlineInputBorder()
                            ),
                          ),
                        if (field['answerDataType'] == 'number')
                          TextFormField(
                            onChanged: (value) {
                              _formValues[field['title']] = value;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (val){
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Type Number Here',
                                hintText: field['requiredDescription'],
                                border: OutlineInputBorder()
                            ),
                          ),
                        if (field['answerDataType'] == 'yes_no')
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    child: Text('Ja',style: TextStyle(
                                        fontSize: 18
                                    ),),
                                    onPressed: () {
                                      if(field['hasRequiredDescription']){
                                        setState(() {
                                          _showYesFields[field['title']] = true;
                                        });
                                      }else{
                                        _formValues[field['title']] = 'Ja';
                                        nextPage();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeHelper.buttonPrimaryColor,
                                        minimumSize: Size(100,40)
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  ElevatedButton(
                                    child: Text('Nei',style: TextStyle(
                                        fontSize: 18
                                    ),),
                                    onPressed: () {
                                      setState(() {
                                        _formValues[field['title']] = 'Nei';
                                        nextPage();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeHelper.buttonPrimaryColor,
                                        minimumSize: Size(100,40)
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),
                              if(showYesField)
                                TextFormField(
                                  onChanged: (value) {
                                    _formValues[field['title']] = value;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return "Enter Something";
                                    }

                                    return null;
                                  },
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: 'Type It Here',
                                      hintText: field['requiredDescription'],
                                      border: OutlineInputBorder()
                                  ),
                                )
                            ],
                          ),
                        if (field['answerDataType'] == 'file')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                                  if (result != null && result.files.isNotEmpty) {
                                    String? filePath = result.files.single.path;
                                    _formValues[field['title']] = filePath;
                                    setState(() {
                                      _readFileName = result.files.single.name;
                                      _readFilePath = result.files.single.path;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeHelper.buttonPrimaryColor
                                ),
                                child: Text('Select File'.toUpperCase(),style: TextStyle(
                                    fontSize: 18
                                ),),
                              ),
                              Text(_readFileName),
                              // if(_readFilePath != null)
                              //   Container(
                              //     width: double.infinity,
                              //     height: 100,
                              //     color: Colors.red,
                              //   )
                            ],

                          ),
                        if (field['answerDataType'] == 'image')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                                  if (pickedImage != null) {
                                    setState(() {
                                      _imageFilePath = pickedImage.path;
                                      _formValues[field['title']] = _imageFilePath;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeHelper.buttonPrimaryColor
                                ),
                                child: Text('Select Image'.toUpperCase(),style: TextStyle( fontSize: 18 ),),
                              ),
                              SizedBox(height: 20,),
                              if (_imageFilePath != null)
                                Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: Image.file(
                                          File(_imageFilePath!),
                                          fit: BoxFit.cover,
                                        ).image,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                ),
                            ],
                          ),

                        if (field['answerDataType'] == 'date')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                field['title'],
                                style: TextStyle(fontSize: 20),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    setState(() {
                                      _formValues[field['title']] = selectedDate.toString();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeHelper.buttonPrimaryColor,
                                ),
                                child: Text(
                                  'Select Date',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 20),
                              if (_formValues[field['title']] != null)
                                Text(
                                  'Selected Date: ${DateTime.parse(_formValues[field['title']]).toLocal()}',
                                  style: TextStyle(fontSize: 16),
                                ),
                            ],
                          ),


                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Store the form values in the results list when the form is submitted
                //     widget.results.clear();
                //     for (var key in _formValues.keys) {
                //       widget.results.add({
                //         'title': key,
                //         'value': _formValues[key],
                //         'answerDataType': widget.formFields.firstWhere((field) => field['title'] == key)['answerDataType'],
                //         'id': widget.formFields.firstWhere((field) => field['title'] == key)['_id'],
                //         'group': widget.formFields.firstWhere((field) => field['title'] == key)['group']['_id'],
                //         'form': widget.formFields.firstWhere((field) => field['title'] == key)['form'],
                //       });
                //     }
                //
                //     // Call the onFormSubmitted callback
                //     widget.onFormSubmitted();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: ThemeHelper.buttonPrimaryColor,
                //   ),
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(fontSize: 20),
                //   ),
                // ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
// class FormCard extends StatefulWidget {
//   final List formFields;
//   final List<Map<String, dynamic>> results;
//   final VoidCallback onFormSubmitted;
//
//
//
//
//
//   FormCard({required this.formFields, required this.results, required this.onFormSubmitted});
//
//   @override
//   _FormCardState createState() => _FormCardState();
// }
//
// class _FormCardState extends State<FormCard> {
//   Map<String, dynamic> _formValues = {};
//   String? _imageFilePath;
//
//   String _readFileName = "";
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             for (var field in widget.formFields)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     if (field['answerDataType'] == 'text')
//                       TextFormField(
//                         onChanged: (value) {
//                           _formValues[field['title']] = value;
//                         },
//                         decoration: InputDecoration(
//                           labelText: field['title'],
//                           hintText: field['requiredDescription'],
//                         ),
//                       ),
//                     if (field['answerDataType'] == 'number')
//                       TextFormField(
//                         onChanged: (value) {
//                           _formValues[field['title']] = value;
//                         },
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: field['title'],
//                           hintText: field['requiredDescription'],
//                         ),
//                       ),
//                     if (field['answerDataType'] == 'yes_no')
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             field['title'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Checkbox(
//                             value: _formValues[field['title']] == 'Yes',
//                             onChanged: (value) {
//                               setState(() {
//                                 _formValues[field['title']] = value != null ? 'Yes' : 'No';
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     if (field['answerDataType'] == 'file')
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(field['title'],style: TextStyle(
//                             fontSize: 20
//                           ),),
//                           ElevatedButton(
//                             onPressed: () async {
//                               FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//                               if (result != null && result.files.isNotEmpty) {
//                                 String? filePath = result.files.single.path;
//                                 _formValues[field['title']] = filePath;
//                                 setState(() {
//                                   _readFileName = result.files.single.name;
//                                 });
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ThemeHelper.buttonPrimaryColor
//                             ),
//                             child: Text('Select File'),
//                           ),
//                           Text(_readFileName)
//                         ],
//
//                       ),
//                     if (field['answerDataType'] == 'image')
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(field['title']),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final picker = ImagePicker();
//                               final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//                               if (pickedImage != null) {
//                                 setState(() {
//                                   _imageFilePath = pickedImage.path;
//                                   _formValues[field['title']] = _imageFilePath;
//                                 });
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: ThemeHelper.buttonPrimaryColor
//                             ),
//                             child: Text('Select Image',style: TextStyle( fontSize: 18 ),),
//                           ),
//                           if (_imageFilePath != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Image.file(
//                                 File(_imageFilePath!),
//                                 height: 150,
//                                 width: 150,
//                               ),
//                             ),
//                         ],
//                       ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//             ElevatedButton(
//               onPressed: () {
//                 // Store the form values in the results list when the form is submitted
//                 widget.results.clear();
//                 for (var key in _formValues.keys) {
//                   widget.results.add({
//                     'title': key,
//                     'value': _formValues[key],
//                     'answerDataType': widget.formFields.firstWhere((field) => field['title'] == key)['answerDataType'],
//                     'id': widget.formFields.firstWhere((field) => field['title'] == key)['_id'],
//                     'group': widget.formFields.firstWhere((field) => field['title'] == key)['group']['_id'],
//                     'form': widget.formFields.firstWhere((field) => field['title'] == key)['form'],
//                   });
//                 }
//
//                 // Call the onFormSubmitted callback
//                 widget.onFormSubmitted();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ThemeHelper.buttonPrimaryColor,
//               ),
//               child: Text(
//                 'Submit',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class DriverProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  DriverProfileScreen(this.results);

  void _showSuccessPopup(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Takk! Skjemaet er sendt.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MainScreen();
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
              child: Text('OK'),
            ),
          ],
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 300),
    );
  }

  void _uploadData(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call or any asynchronous task
    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // Hide the loading indicator

    _showSuccessPopup(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                _uploadData(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeHelper.buttonPrimaryColor,
                minimumSize: Size(160, 35),
              ),
              icon: Icon(Icons.upload),
              label: Text('Legge til', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(width: 12.0,),
            ElevatedButton.icon(
              onPressed: () async {
                SharedPreferences shared = await SharedPreferences.getInstance();
                if (shared.containsKey('token')) await shared.remove('token');

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SplashScreen(token: null);
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
                minimumSize: Size(160, 35),
                backgroundColor: Colors.red,
              ),
              icon: Icon(Icons.logout),
              label: Text(
                'Logg ut',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(snapshot.hasError){
                    return Center(
                      child: Text("Something Went Wrong"),
                    );
                  }

                  if(snapshot.data != null){
                    Map data = jsonDecode(snapshot.data!.getString('data')!);
                    return Container(
                      color: Colors.black12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text('Location'),
                            subtitle: Text(data['location']),
                          ),
                          ListTile(
                            leading: Icon(Icons.local_taxi),
                            title: Text('Car'),
                            subtitle: Text("${data['boardNumber']}  -  ${data['privateNumber']}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('Shift'),
                            subtitle: Text("${data['day']}  -  ${data['period']}"),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container();
                },
              ),
              for (var entry in results)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (entry['answerDataType'] == 'text' || entry['answerDataType'] == 'number')
                      ListTile(
                        leading: Icon(Icons.text_fields),
                        title: Text(entry['title']),
                        subtitle: Text(entry['value'].toString()),
                      ),
                    if (entry['answerDataType'] == 'yes_no')
                      ListTile(
                        leading: Icon(Icons.check_box),
                        title: Text(entry['title']),
                        subtitle: Text(entry['value']),
                      ),
                    if (entry['answerDataType'] == 'file')
                      ListTile(
                        leading: Icon(Icons.attach_file),
                        title: Text(entry['title']),
                        subtitle: Text('File: ${entry['value']}'),
                      ),
                    if (entry['answerDataType'] == 'image')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.file(
                              File(entry['value']),
                              height: 150,
                              width: 150,
                            ),
                          ),
                        ],
                      ),
                    Divider(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
