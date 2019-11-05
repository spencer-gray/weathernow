import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherView extends StatefulWidget {
  WeatherView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  Future<Weather> _loadData() async {
    WeatherStation weatherStation = new WeatherStation("API_KEY_HERE");
    Weather weather = await weatherStation.currentWeather();

    return weather;

  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return FutureBuilder(
      future: _loadData(),
      initialData: Weather,
      builder: (context, snapshot) { 

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.areaName),
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
                        child: Text(snapshot.data.temperature.toString().substring(0, 4) + '\xb0', style: TextStyle(fontSize: 50))
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                            Image.network('http://openweathermap.org/img/w/' + snapshot.data.weatherIcon+ '.png'),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(snapshot.data.weatherMain, style: TextStyle(fontSize: 14)),
                          ]),
                          Row(
                            children: <Widget>[
                            Icon(Icons.arrow_forward),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text((snapshot.data.windSpeed*1.60934).toStringAsFixed(2) + " kph", style: TextStyle(fontSize: 14)),
                          ]),
                          Row(
                            children: <Widget>[
                            Icon(Icons.beach_access),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(snapshot.data.humidity.round().toString() + "%", style: TextStyle(fontSize: 14)),
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
                            Text('Monday', style: TextStyle(fontSize: 11)),
                            Icon(Icons.wb_sunny),
                            Row (
                              children: <Widget>[
                                Text('10\xb0', style: TextStyle(fontSize: 11)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text('4\xb0', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ]
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Column(
                          children: <Widget>[
                            Text('Tuesday', style: TextStyle(fontSize: 11)),
                            Icon(Icons.wb_cloudy),
                            Row (
                              children: <Widget>[
                                Text('6\xb0', style: TextStyle(fontSize: 11)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text('2\xb0', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ]
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Column(
                          children: <Widget>[
                            Text('Wednesday', style: TextStyle(fontSize: 11)),
                            Icon(Icons.wb_sunny),
                            Row (
                              children: <Widget>[
                                Text('6\xb0', style: TextStyle(fontSize: 11)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text('4\xb0', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ]
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Column(
                          children: <Widget>[
                            Text('Thursday', style: TextStyle(fontSize: 11)),
                            Icon(Icons.wb_cloudy),
                            Row (
                              children: <Widget>[
                                Text('7\xb0', style: TextStyle(fontSize: 11)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text('2\xb0', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ]
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Column(
                          children: <Widget>[
                            Text('Friday', style: TextStyle(fontSize: 11)),
                            Icon(Icons.wb_sunny),
                            Row (
                              children: <Widget>[
                                Text('12\xb0', style: TextStyle(fontSize: 11)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text('7\xb0', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ]
                        ),
                      ],
                    )
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
                    onTap: () {
                      print("Manage locations pressed...");
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Item 2'),
                    onTap: () {
                      print("Item 2 pressed...");
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      print("Settings pressed...");
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
}