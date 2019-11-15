import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:flutter/material.dart';
import 'package:weathernow/widgets/settings.dart';
import '../util/darksky.dart';
import 'manage-cities.dart';
import 'weather_map.dart';
import '../model/city.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherView extends StatefulWidget {
  WeatherView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    _loadForecasts();

    return FutureBuilder(
      future: _loadForecasts(),
      initialData: Forecast,
      builder: (context, snapshot) { 

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Mountain View, CA"),
              centerTitle: true,
            ),

            body: Container(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: <Widget> [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Container(
                        child: Text(snapshot.data.currently.temperature.toString().substring(0, 4) + '\xb0', style: TextStyle(fontSize: 50))
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                            Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.currently.icon + '.png', width: 25, height: 25,),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(snapshot.data.currently.summary, style: TextStyle(fontSize: 14)),
                          ]),
                          Row(
                            children: <Widget>[
                            Icon(Icons.arrow_forward),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text((snapshot.data.currently.windSpeed*1.60934).toStringAsFixed(2) + " kph", style: TextStyle(fontSize: 14)),
                          ]),
                          Row(
                            children: <Widget>[
                            Icon(Icons.beach_access),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text((snapshot.data.currently.humidity*100).round().toString() + "%", style: TextStyle(fontSize: 14)),
                          ]),
                        ],
                      ),
                    ]
                  ),
                  // 5 day forecast box
                  Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(
                      color: Colors.blueGrey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    )),
                    child: Row( 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[0].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
                                  Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[0].icon + '.png', width: 25, height: 25,),
                                  Row (
                                    children: <Widget>[
                                      Text(snapshot.data.daily.data[0].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(snapshot.data.daily.data[0].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[1].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
                                  Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[1].icon + '.png', width: 25, height: 25,),
                                  Row (
                                    children: <Widget>[
                                      Text(snapshot.data.daily.data[1].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(snapshot.data.daily.data[1].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[2].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
                                  Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[2].icon + '.png', width: 25, height: 25,),
                                  Row (
                                    children: <Widget>[
                                      Text(snapshot.data.daily.data[2].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(snapshot.data.daily.data[2].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[3].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
                                  Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[3].icon + '.png', width: 25, height: 25,),
                                  Row (
                                    children: <Widget>[
                                      Text(snapshot.data.daily.data[3].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(snapshot.data.daily.data[3].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[4].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
                                  Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[4].icon + '.png', width: 25, height: 25,),
                                  Row (
                                    children: <Widget>[
                                      Text(snapshot.data.daily.data[4].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(snapshot.data.daily.data[4].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                            ],
                          ),
                               
                  )
        
                ]
              )
            ),

            drawer: Drawer(
              child:  ListView(
                //padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text('Manage Locations'),
                    onTap: () => _manageCities(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _mapPage(context);
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      print("Settings pressed...");
                      Navigator.of(context).pop();
                      _settingsPage(context);
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text('Close'),
                    onTap: () {
                      Navigator.pop(context);
                    }
                  )
                ],
              ),
            ),
            //bottomSheet: menu(), 
          );
        }

        // Temp Placeholder
        // Loading indication when first starting up the app
        // Should add some styling
        else {       
          return CircularProgressIndicator();
        }
      }

    );
    
  }

  // Loads the forecast data
  Future<Forecast> _loadForecasts() async {
    DarkSkyHandler handler = new DarkSkyHandler();
    Forecast forecast = await handler.getCurrentForecast();

    return forecast;
  }

  Future<void> _manageCities(BuildContext context) async {
    Navigator.pop(context);
    
    City result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CityList()),
    );

    // NEEDS IMPLEMENTING: Opens detailed weather view of the list view item pressed.
    if (result != null) {
      print(result);
    }
  }

  Future<void> _settingsPage(BuildContext context) async{
    
    var event = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          title: "Settings Page",
        ),
      ),
    );
    
  }

  Future<void> _mapPage(BuildContext context) async{
    var event = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          title: "Map Page",
        ),
      ),
    );
  }

}

// No longer used
// Future<void> _showSearchPage(BuildContext context) async {
  
//     var event = await Navigator.pushNamed(context, '/searchPage');
//     print('search page:');
//     print(event);
//   }