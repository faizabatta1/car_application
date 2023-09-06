import 'dart:async';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/services/map_service.dart';
import 'package:car_app/services/zones_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _chosedZone = false;
  Map? zone;
  late Future future;

  @override
  void initState() {
    future = ZoneService.getAllZones();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text('Select Zone First',style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(height: 12,),
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasError){
                  return Center(
                    child: Text('Something Went wrong'),
                  );
                }

                if(snapshot.data != null){
                  List zones = snapshot.data;
                  if(zones.isEmpty){
                    return Center(
                      child: Text('No Zones Yet'),
                    );
                  }

                  return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                    children: zones.map((e){
                      return ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _chosedZone = true;
                            zone = e;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeHelper.buttonPrimaryColor,
                          minimumSize: Size(110, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                          )
                        ),
                        child: Text(e['name'],style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
                      );
                    }).toList(),
                  );
                }

                return Container();

              },
            ),

            if(_chosedZone)
              Expanded(
                  child: MapSample(zone: zone)
              )
          ],
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  final Map? zone;
  const MapSample({super.key, required this.zone});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late Future future;

  @override
  void initState() {
    super.initState();
    print(widget.zone!);
    future = MapService.downloadMapFeatures(widget.zone!['_id']);
  }
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if(snapshot.data != null){
            print(snapshot.data.toString());
            return GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }else{
            return Center(
              child: Text(
                'There is no available map for this zone',
                style: TextStyle(
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Container();
      },
    );
  }
}