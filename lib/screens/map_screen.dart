import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/services/map_service.dart';
import 'package:car_app/services/zones_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as MX;

class MapsScreen extends StatefulWidget {
  static const String route = '/maps';
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  bool _chosenZone = false;
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
            SizedBox(height: 30),
            Text(
              'Select Zone First',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something Went wrong'),
                  );
                }

                if (snapshot.data != null) {
                  List zones = snapshot.data;
                  if (zones.isEmpty) {
                    return Center(
                      child: Text('No Zones Yet'),
                    );
                  }

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: zones.map((e) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _chosenZone = true;
                            zone = e;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeHelper.buttonPrimaryColor,
                            minimumSize: Size(110, 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Text(
                          e['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  );
                }

                return Container();
              },
            ),
            if (_chosenZone)
              Expanded(
                child: MapSample(zone: zone),
              ),
            if(!_chosenZone)
              Expanded(
                child: Center(
                  child: Text('No Map Was Selected',style: TextStyle(
                    fontSize: 20
                  ),),
                ),
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
  GoogleMapController? _controller;
  Set<Polygon> _polygons = Set<Polygon>();

  List<List<LatLng>> _getPointsFromGeoJSON(Map<String, dynamic> geoJson) {
    final List<List<LatLng>> allCoordinates = [];
    final List<dynamic> features = geoJson['features'];

    for (final feature in features) {
      final List<dynamic> coordinates = feature['geometry']['coordinates'][0];
      final List<LatLng> polygonCoordinates = coordinates.map((coord) {
        final lat = coord[1];
        final lng = coord[0];
        return LatLng(lat, lng);
      }).toList();
      allCoordinates.add(polygonCoordinates);
    }

    return allCoordinates;
  }

  LatLngBounds _getPolygonBounds(Polygon polygon) {
    final points = polygon.points;
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MapService.downloadMapFeatures(widget.zone!['_id']),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString().replaceAll('"', ''),style: TextStyle(
              fontSize: 20
            ),),
          );
        }
        if (snapshot.data != null) {
          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(snapshot.data['latitude'].toString()),
                    double.parse(snapshot.data['longitude'].toString())),
                zoom: 6),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;

              final geoJsonText = snapshot.data['data'];
              final geoJson = jsonDecode(geoJsonText);

              List features = geoJson['features'];
              print(features.length.toString());
              for(var feature in features){
                print('yupppppppppp');
                var coords = feature['geometry']['coordinates'];
                List<LatLng> points = [];
                for(var coord in coords[0]){
                  points.add(LatLng(coord[1],coord[0]));
                }
                Polygon polygon = Polygon(
                  polygonId: PolygonId('${Random().nextInt(100000000).toString()}'),
                  points: points,
                  fillColor: HexColor.fromHex(feature['properties']['color']).withOpacity(0.3),
                  strokeWidth: 0,
                  onTap: () async{
                    final availableMaps = await MX.MapLauncher.installedMaps;
                    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                    await availableMaps.first.showMarker(
                      coords: MX.Coords(points[0].latitude, points[0].longitude),
                      title: "Ocean Beach",
                    );
                  },
                  consumeTapEvents: true,
                  zIndex: 5,

                );

                setState(() {
                  _polygons.add(polygon);
                });
              }

            },
            polygons: _polygons,
          );
        }

        return Container();
      },
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
