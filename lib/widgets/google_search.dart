import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String googleKey;
  GoogleMapsPlaces _places;

  @override
  void initState() {
    DotEnv().load('.env');

    this.googleKey = DotEnv().env['GOOGLE_API'];
    this._places = GoogleMapsPlaces(apiKey: googleKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
      title: const Text('Location List', ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            print("delete location");
          },
        )
      ],
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,            
      children: <Widget>[  
        Flexible(
          child: buildLocations(),          
        ),
        RaisedButton(
          onPressed: () async {
            // autocomplete and predict
            Prediction p = await PlacesAutocomplete.show(context: context, apiKey: googleKey, mode: Mode.overlay,);
            displayPrediction(p);
          },
          child: Text('Add Location'),
        ),
      ],
      
      
    ),
      // body: Container(
      //   margin: const EdgeInsets.only(top: 30.0),
      //   alignment: Alignment.topCenter,
      //   child: RaisedButton(
      //     onPressed: () async {
      //       // autocomplete and predict
      //       Prediction p = await PlacesAutocomplete.show(context: context, apiKey: googleKey, mode: Mode.overlay,);
      //       displayPrediction(p);
      //     },
      //     //new address ability
      //     child: Text('Find x address'),
      //     //need to add way to store previous addresses here

      //   )
        
      // )
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double long = detail.result.geometry.location.lng;
      var time = detail.result.openingHours;


      //var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print("lat: "+ lat.toString());
      print("long: "+ long.toString());
      print("time: " + time.toString());
    }
  }
}

Widget buildLocations() {
  return ListView.separated(
    padding: EdgeInsets.only(top: 13, bottom: 10, left: 20, right: 20),
    itemCount: 20,
    itemBuilder: (BuildContext context, int index){
      
      return Row(
        
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Column(
            children: <Widget>[
              Text('City ' + index.toString()),
              Text('Country ' + index.toString()),
            ],
          ),
          Padding(padding: EdgeInsets.only(right: 10)),
          Flexible(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: <Widget>[
                  Text('25'+ '\xb0'),
                  ],
                )
              ],
            ),
          )
        ],
        
      );
    },     separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}