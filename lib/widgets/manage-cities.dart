import 'package:flutter/material.dart';
import '../model/city.dart';
import '../model/CityModel.dart';
import '../model/db_utils.dart';
import 'google_search.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import '../grade_form.dart';


class CityList extends StatefulWidget {
  CityList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {

  final _model = CityModel();
  var _selectedIndex;
  var _lastInsertedId = 0;

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

    _loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Locations"),
      ),
      body: FutureBuilder(
        future: _loadData(),
        initialData: List<City>(),
        builder: (context, snapshot) {
          return listCities(snapshot.data);
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCity();
        },
        tooltip: 'New City',
        child: Icon(Icons.add),
      ),
      );
  }

  // READS data from SQL DB into List<City> city variable
  // to be used by ListView
  Future<List<City>> _loadData() async{
    final db = await DBUtils.init();

    final List<Map<String, dynamic>> maps = await db.query('citiesdb');
    List<City> cities = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cities.add(City.fromMap(maps[i]));
      }
    }
    return cities;
  }

  // Opens CityForm page and adds non null entries to DB
  Future<void> _addCity() async {
    print("Add City pressed");

    Prediction p = await PlacesAutocomplete.show(context: context, apiKey: googleKey, mode: Mode.overlay,);
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double long = detail.result.geometry.location.lng;
      String name = detail.result.name;
      String state;
      String country;
      String locationStr;

      // Where location has city, state/province, country
      if (detail.result.addressComponents.length > 3) {
        state = detail.result.addressComponents[2].shortName;
        country = detail.result.addressComponents.last.shortName;

        locationStr = name + ", " + state + ", " + country;
      }
      // Where location has state/province, country
      else if (detail.result.addressComponents.length > 2) {
        country = detail.result.addressComponents.last.shortName;

        locationStr = name + ", " + country;
      }
      // Where location has country
      else {
        locationStr = detail.result.name;
      }

      print(locationStr);
      print("lat: "+ lat.toString());
      print("long: "+ long.toString());

      City newCity = City(name: locationStr, latitude: lat.toString(), longitude: long.toString());

      print("New City Added!");
      _lastInsertedId = await _model.insertCity(newCity);

      setState(() {
        
      });
    }
    else {
      print("Null location was not added!");
    }
  }

  // Deletes selected listview's data from DB
  Future<void> _deleteCity(int id) async {
    _model.deleteCityById(id);
    print("deleted " + id.toString());

    // this empty setState will automatically update UI
    // to reflect database deletion
    setState(() {
        
      });
  }

  Widget listCities(List<City> cities) {
    return ListView.separated(
      padding: EdgeInsets.all(20),
      itemCount: cities.length,
      itemBuilder: (BuildContext context, int index) {
        return cityItem(cities[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1,),
    );
  }

  Widget cityItem(City city) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            child: ListTile(
              title: Text(city.name), 
              trailing:  IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                      title: Text("Delete location?"),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: const Text('Yes'),
                          onPressed: () { 
                            _deleteCity(city.id);
                            Navigator.pop(context);
                          }
                        ),
                        SimpleDialogOption(
                          child: const Text('No'),
                          onPressed: () { 
                            Navigator.pop(context); }
                        ),
                        
                      ],
                    );
                    }
                  );
                }
              ),
              onTap: () {
                print(city.id.toString() + " was pressed...");
              }
            ),
          )
      ],
    );
  }
}
