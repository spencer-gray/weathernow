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
      body: Container(
        margin: const EdgeInsets.only(top: 70.0),
        alignment: Alignment.topCenter,
        child: RaisedButton(
          onPressed: () async {
            // autocomplete and predict
            Prediction p = await PlacesAutocomplete.show(context: context, apiKey: googleKey, mode: Mode.overlay,);
            displayPrediction(p);
          },
          //new address ability
          child: Text('Find new address'),
          //need to add way to store previous addresses here

        )
        
      )
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double long = detail.result.geometry.location.lng;

      //var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print("lat: "+ lat.toString());
      print("long: "+ long.toString());
    }
  }
}