import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class MapPage extends StatefulWidget{

  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{

  var _geoLocator = Geolocator();
  LatLng centre;
  bool first = true;

  @override
  Widget build(BuildContext context){

    if(first){
      _getCurrentLocation();
      first = false;
    }
    
    return FutureBuilder(
      future: _getAPI(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done && centre != null){
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: FlutterMap(
              options: MapOptions(
                center: centre,
                minZoom: 16.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.mapbox.com/styles/v1/jimmyjoe67/ck2wnp8w61tvk1cqizjh7wzfl/tiles/256/{z}/{x}/{y}@2x?access_token=${snapshot.data}",
                  additionalOptions: {
                    'accessToken': snapshot.data,
                    'id': 'mapbox.streets',
                  },
                ),
                MarkerLayerOptions(
                  //can be used for things like current position
                  //or weather patterns
                  markers: [
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: centre,
                      builder: (context) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: Colors.blue,
                          iconSize: 45.0,
                          onPressed: () {
                            print('Icon clicked');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                PolylineLayerOptions(
                    /*polylines: [
                    Polyline(
                      points: path,
                      strokeWidth: 2.0,
                      color: Colors.blue,
                    ),
                  ],*/
                ),
              ],
            ),
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _getCurrentLocation() {
    _geoLocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position location) {
      setState(() {
        centre = LatLng(location.latitude, location.longitude);
      });
    });
  }

  Future<String> _getAPI() async{
    await DotEnv().load('.env');
    return DotEnv().env["MAPBOX_API"];
  }

}

