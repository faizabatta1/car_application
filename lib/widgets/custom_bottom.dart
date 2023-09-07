import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';
import '../screens/map_screen.dart';
import '../screens/terms_screen.dart';
import '../screens/violations_details.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TermsScreen())
                );
              },
              icon: Icon(Icons.policy,size: 40,),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ViolationsDetails())
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: ThemeHelper.buttonPrimaryColor,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(Icons.add,color: Colors.white,size: 40,),
              ),
            ),
            IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MapsScreen())
                );
              },
              icon: Icon(Icons.map,size: 40,),
            ),
          ],
        ),
      ),
    );
  }
}
