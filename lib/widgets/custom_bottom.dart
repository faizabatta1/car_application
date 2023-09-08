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
              onTap: () async {
                await showModalBottomSheet(
                  enableDrag: true,
                  showDragHandle: true,

                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.document_scanner),
                            title: Text("Scan"),
                            onTap: () async{
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Container(
                                    color: Colors.red,
                                  ))
                              );
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.local_post_office),
                            title: Text("Postal"),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ViolationsDetails())
                              );
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Avbryt", style: TextStyle(
                                color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                        ],
                      ),
                    );
                  },
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
