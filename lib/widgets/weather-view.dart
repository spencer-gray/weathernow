import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import '../util/weather-parser.dart';
import '../util/darksky.dart';
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
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _showSearchPage(context);
                  },
                ),
              ],
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
                                  Text(weekdays[(DateTime.now().weekday)%7], style: TextStyle(fontSize: 11)),
                                  Icon(Icons.wb_sunny),
                                  Row (
                                    children: <Widget>[
                                      Text('12\xb0', style: TextStyle(fontSize: 11)),
                                      //Text('10\xb0', style: TextStyle(fontSize: 11)),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text('4\xb0', style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ]
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: <Widget>[
                                  Text(weekdays[(DateTime.now().weekday+1)%7], style: TextStyle(fontSize: 11)),
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
                                  Text(weekdays[(DateTime.now().weekday+2)%7], style: TextStyle(fontSize: 11)),
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
                                  Text(weekdays[(DateTime.now().weekday+3)%7], style: TextStyle(fontSize: 11)),
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
                                  Text(weekdays[(DateTime.now().weekday+4)%7], style: TextStyle(fontSize: 11)),
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
                    onTap: () {
                      print("Manage locations pressed...");
                      // below was causing errors in the app
                      //showSearch(context: context, delegate: SearchData());
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

  // Loads the forecast data
  Future<Forecast> _loadForecasts() async {
    DarkSkyHandler handler = new DarkSkyHandler();
    Forecast forecast = await handler.getCurrentForecast();

    return forecast;
  }
}

Future<void> _showSearchPage(BuildContext context) async {
  
    var event = await Navigator.pushNamed(context, '/searchPage');
    print('search page:');
    print(event);
  }