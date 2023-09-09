import 'dart:io';
import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:car_app/services/postal_service.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

class UploadViolationImage extends StatefulWidget {
  final String number;
  final String reason;
  final String pnid;
  const UploadViolationImage({Key? key,required this.number,required this.pnid,required this.reason}) : super(key: key);

  @override
  _UploadViolationImageState createState() => _UploadViolationImageState();
}

class _UploadViolationImageState extends State<UploadViolationImage> {
  List<String>? _imagePaths;
  bool _isUploaded = false;

  bool _isUploading = false;


  Future<void> _captureAndCropImages() async {
    final imagesPaths = await CunningDocumentScanner.getPictures();
    if(imagesPaths != null && imagesPaths.isNotEmpty){
      setState(() {
        _imagePaths = imagesPaths;
        _isUploaded = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: !_isUploaded ? 120 : 20),
              if(!_isUploaded)
              Text('Upload your violations document to upload it to server',style: TextStyle(
                fontSize: 22
              ),textAlign: TextAlign.center,),
              if (_imagePaths != null)
                SizedBox(
                  height: 580,
                  child: Image.file(
                    File.fromUri(Uri.file(_imagePaths!.first)),
                    fit: BoxFit.cover,
                    height: 400,
                    width: double.infinity,
                  ),
                ),
              SizedBox(height: 20),
              !_isUploaded ?
              ElevatedButton(
                onPressed: _captureAndCropImages,
                style: ElevatedButton.styleFrom(
                  primary: ThemeHelper.buttonPrimaryColor, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Capture and Crop Violation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ) : ElevatedButton(
                  onPressed: () async{
                    if(_imagePaths != null && _imagePaths!.isNotEmpty){
                      setState(() {
                        _isUploading = true;
                      });
                      await PostalService.sendPostal(
                          number: widget.number,
                          pnid: widget.pnid,
                          reason: widget.reason,
                          image: _imagePaths!.first
                      ).then((value){
                        setState(() {
                          _isUploading = false;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MainScreen())
                        );
                      }).catchError((onError){
                        print(onError.toString());
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ThemeHelper.buttonPrimaryColor, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _isUploading ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    ) : Text(
                        'Finish And Upload',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

