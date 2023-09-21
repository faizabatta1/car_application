import 'dart:io';

import 'package:car_app/models/issue_data.dart';
import 'package:car_app/services/issue_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

class NotificationIssueSolveData extends StatefulWidget {
  final IssueData issueData;

  const NotificationIssueSolveData({super.key, required this.issueData});

  @override
  _NotificationIssueSolveDataState createState() =>
      _NotificationIssueSolveDataState();
}

class _NotificationIssueSolveDataState
    extends State<NotificationIssueSolveData> {
  TextEditingController detailsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  final picker = ImagePicker(); // Create an instance of ImagePicker
  XFile? _image;

  bool hasNotes = false;

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12,),
            Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: detailsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter details about issue resolution...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upload Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _getImage, // Open the image picker when tapped
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: _image == null
                      ? Text('Tap to select an image')
                      : Image.file(File(_image!.path)),
                ),
                width: double.infinity,
                height: 200.0,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('do you have any notes',style: TextStyle(
                  fontSize: 18
                ),),
                SizedBox(width: 8,),
                Checkbox(
                    value: hasNotes,
                    onChanged: (value){
                      setState(() {
                        hasNotes = !hasNotes;
                      });
                    }
                ),
              ],
            ),
            if(hasNotes)
            Text(
              'Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if(hasNotes)
            TextField(
              controller: notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter additional notes (optional)...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async{
                  // Implement sending the report with details, notes, and the image
                  String details = detailsController.text;
                  String notes = notesController.text;


                  Map<String,String> data = {
                    'details': details
                  };

                  if(hasNotes){
                    data.addAll({
                      'notes': notes
                    });
                  }

                  try{
                    await IssueService.uploadMachineIssueFixReport(
                        widget.issueData,
                        _image!.path,
                        data
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Done'))
                    );

                  }catch(error){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString()))
                    );
                  }
                  // Perform further actions here, such as sending the report
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,

                ),
                label: Text('Upload Report'),
                icon: Icon(Icons.upload_file),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
