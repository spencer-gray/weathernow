import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:flutter/material.dart';
//import 'package:weathernow/widgets/community_photos.dart';
//import 'package:weathernow/widgets/photo_upload.dart';
import 'package:weathernow/widgets/settings.dart';
import '../util/darksky.dart';
import 'manage-cities.dart';
import 'weather_map.dart';
import '../model/city.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weathernow/model/weekdayForecast.dart';


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
          // store the weekday data here by passing the snapshot and taking data from it in weekDayForecast
          //print('hi');
          // initializing weekday data to be displayed in chart
          List<WeekdayForecast> _weekdayData = [
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[0].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[0].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[0].temperatureMax),
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[1].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[1].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[1].temperatureMax),
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[2].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[2].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[2].temperatureMax),
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[3].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[3].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[3].temperatureMax),
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[4].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[4].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[4].temperatureMax),                          
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text("Mountain View, CA"),
              centerTitle: true,
            ),
            body: ListView(
              padding: EdgeInsets.only(top: 100),
              children: <Widget> [ 
                Column(
                  children: <Widget> [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Container(
                          // need to handle substring size when temp is single vs. double digit
                          child: Text(snapshot.data.currently.temperature.toString() + '\xb0C', style: TextStyle(fontSize: 50))
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
                                
                    ),

                    // Weekday Low + High Chart
                    //Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 300,
                        child: charts.BarChart(
                          [
                            charts.Series<WeekdayForecast, String> (
                              id: 'Weekly Lows',
                              colorFn: (a,b) => charts.MaterialPalette.indigo.shadeDefault,
                              domainFn: (WeekdayForecast day, unused) => day.weekday,
                              measureFn: (WeekdayForecast day, unused) => day.dailyLow,
                              data: _weekdayData,               
                            ),
                            charts.Series<WeekdayForecast, String> (
                              id: 'Weekly Highs',
                              colorFn: (a,b) => charts.MaterialPalette.cyan.shadeDefault,
                              domainFn: (WeekdayForecast day, unused) => day.weekday,
                              measureFn: (WeekdayForecast day, unused) => day.dailyHigh,
                              data: _weekdayData,
                            ),
                          ]
                        )
                      )
                    ),

                    // Current weather data table
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    DataTable(
                      dataRowHeight: 30,
                      headingRowHeight: 0,
                      columns: [
                        DataColumn(label: Text(' ')),
                        DataColumn(label: Text(' '))
                      ],
                      rows: [
                        DataRow(
                          cells: [
                          DataCell(Text('Wind Speed', style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.windSpeed*1.60934).toStringAsFixed(2) + " km/h", style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Cloud Cover', style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.cloudCover*100).round().toString() + '%', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Precipitation', style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.humidity*100).round().toString() + '%', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Precipitation\nType', style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.precipType, style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Ozone', style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.ozone.toString() + 'DU', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Dew Point', style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.dewPoint.toString() + '\xb0C', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Visibility', style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.visibility.toString().substring(0, 4), style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Pressure', style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.pressure.round().toString() + ' mbar', style: TextStyle(fontSize: 11)))
                        ]),
                      ]
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                  ]
                )
              ]
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
                    leading: Icon(Icons.photo),
                    title: Text('Community Photos'),
                    onTap: () => {},
                    // (WORK IN PROGRESS)
                    //onTap: () => _communityPhotosPage(context),
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

  // (WORK IN PROGRESS) opens the community photos page
  // Future<void> _communityPhotosPage(BuildContext context) async {
  //   Navigator.pop(context);
    
  //   City result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ProfilePage()),
  //   );

  //   if (result != null) {
  //     print(result);
  //   }
  // }

}

// No longer used
// Future<void> _showSearchPage(BuildContext context) async {
  
//     var event = await Navigator.pushNamed(context, '/searchPage');
//     print('search page:');
//     print(event);
//   }