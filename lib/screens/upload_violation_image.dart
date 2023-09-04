import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

class UploadViolationImage extends StatefulWidget {
  const UploadViolationImage({Key? key}) : super(key: key);

  @override
  _UploadViolationImageState createState() => _UploadViolationImageState();
}

class _UploadViolationImageState extends State<UploadViolationImage> {
  List<String>? _imagePaths;

  Future<void> _captureAndCropImages() async {
    final imagesPaths = await CunningDocumentScanner.getPictures();
    setState(() {
      _imagePaths = imagesPaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Violation Image'),
        backgroundColor: Colors.teal, // Customize the app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            if (_imagePaths != null)
              ..._imagePaths!.map((path) => Image.file(
                File.fromUri(Uri.file(path)),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureAndCropImages,
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Capture and Crop Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

