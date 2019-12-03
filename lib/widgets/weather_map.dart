import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class MapPage extends StatefulWidget{

  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{

  var _geoLocator = Geolocator();
  LatLng centre;
  List<Placemark> _places;
  String googleKey;
  GoogleMapsPlaces _mapsPlaces;


  @override
  void initState(){
    _getCurrentLocation();
    
    //DotEnv().load('.env');

    this.googleKey = 'AIzaSyAjNnwNrnkC3HbvSOdfNF34ALGe7iJaU90';
    this._mapsPlaces = GoogleMapsPlaces(apiKey: googleKey);

    super.initState();
    /*_geoLocator.getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 10000)).listen((userLocation){
      _updateLocaiton(userLocation);
    });*/
  }

  @override
  Widget build(BuildContext context){
    
    return FutureBuilder(
      future: _getAPI(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done && centre != null){
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.blue,
                  onPressed: () {
                    searchCities();
                  },
                  tooltip: 'New Location',
                ),
                IconButton(
                  icon: Icon(Icons.my_location),
                  color: Colors.blue,
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  tooltip: 'Current User Location',
                ),
              ],
            ),
            body: FlutterMap(
              options: MapOptions(
                center: centre,
                minZoom: 1.0,
                maxZoom: 20.0,
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
                            SnackBar snackbar = SnackBar(
                              content: Text("${_places[0].locality}, ${_places[0].administrativeArea}"),
                            );
                            Scaffold.of(context).showSnackBar(snackbar);
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
          return LinearProgressIndicator();
        }
      },
    );
  }

  void _getCurrentLocation() {
    _geoLocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position location) {
      _setInfo(location.latitude, location.longitude);
    });
  }

  void _setInfo(double lat, double long){
    setState(() {
      centre = LatLng(lat, long);
      _geoLocator.placemarkFromCoordinates(lat, long).then((List<Placemark> p){
        _places = p;
      });
    });
  }

  Future searchCities() async{
    Prediction p = await PlacesAutocomplete.show(context: context, apiKey: googleKey, mode: Mode.overlay,);
    print(p);
    if(p != null){
      PlacesDetailsResponse detail = await _mapsPlaces.getDetailsByPlaceId(p.placeId);
      _setInfo(
        detail.result.geometry.location.lat,
        detail.result.geometry.location.lng,
      );   
    }
  }

  /*void _updateLocaiton(Position userLocation){
    centre = LatLng(userLocation.latitude, userLocation.longitude);
    _geoLocator.placemarkFromPosition(userLocation).then((List<Placemark> places){

    });
  }*/

  Future<String> _getAPI() async{
    //await DotEnv().load('.env');
    return "pk.eyJ1IjoiamltbXlqb2U2NyIsImEiOiJjazJ3ZW55MjgwMTU4M2JvbTd1MzRybDNmIn0.AE0eYpvn456vVKXO8EUQ3Q";
  }

}

