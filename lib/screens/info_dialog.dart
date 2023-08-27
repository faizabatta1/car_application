import 'package:car_app/helpers/theme_helper.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.all(8.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      content: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Set width to full screen width
      height: MediaQuery.of(context).size.height, // Set height to full screen height
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // color: Colors.white.withOpacity(0.8),
        color: Colors.transparent,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.close,size: 40,color: ThemeHelper.buttonPrimaryColor,),
          ),
          SizedBox(height: 20,),
          Text(
            'Info',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(height: 16),
          Text(
            'This is the shift choice screen. Here you can select the day, period, and location for your shift. Make sure to fill in all required information before submitting.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
          SizedBox(height: 24),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.amber,
          //   ),
          //   child: Text('OK'),
          // ),
        ],
      ),
    );
  }
}
