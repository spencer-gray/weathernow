import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:weathernow/widgets/community_photos.dart';
import 'package:weathernow/widgets/settings.dart';
import '../util/darksky.dart';
import 'manage-cities.dart';
import 'weather_map.dart';
import '../model/city.dart';
import 'package:weathernow/widgets/reminder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weathernow/model/weekdayForecast.dart';
import '../util/app_localizations.dart';




class WeatherView extends StatefulWidget {
  WeatherView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  LatLng latlong;
  Future<Forecast> forecast;
  bool currentLocCheck = true;
  String locationTitle = " ";

  Future<LatLng> findCurrentLocation() async {
    var location = new Location();
    LocationData currentLocation;

    try {
        await location.getLocation().then((result) {
          currentLocation = result;
        });
      } catch (e) {
        currentLocation = null;
      }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    _loadForecasts();

    if (currentLocCheck) {
      findCurrentLocation().then((result) {
        latlong = result;
      });
      forecast = _loadForecasts();
    }
    // if location is not current location
    else {
      forecast = _loadSpecifiedForecasts(latlong);
    }

    return FutureBuilder(
      future: forecast,
      initialData: Forecast,
      builder: (context, snapshot) { 

        if (snapshot.connectionState == ConnectionState.done) {
          
          if (locationTitle == " ") {
            _findCityName(snapshot.data.latitude, snapshot.data.longitude);
          }


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
              title: Text(locationTitle),
              //title: Text("Mountain View, CA"),
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
                          DataCell(Text(snapshot.data.currently.precipType.toString(), style: TextStyle(fontSize: 11)))
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
                    //onTap: () => {},
                    // (WORK IN PROGRESS)
                    onTap: () => _communityPhotosPage(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(AppLocalizations.of(context).translate('Reminders')),
                    onTap: () {
                      Locale myLocale = Locale(ui.window.locale.languageCode);
                      print("Reminders pressed...");
                      print(myLocale);
                      Navigator.of(context).pop();
                      _reminderPage(context);
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

        else {       
          return LinearProgressIndicator();
        }
      }

    );
  }

  // finds location 
  Future<void> _findCityName(double lat, double long) async{
    var address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(lat, long));
    locationTitle = address.first.subAdminArea + ", " + address.first.adminArea;
    setState(() {});
  }


  Future<Forecast> _loadSpecifiedForecasts(LatLng loc) async {
    DarkSkyHandler handler = new DarkSkyHandler();
    Forecast forecast = await handler.getSpecifiedForecast(loc.latitude, loc.longitude);
    return forecast;
  }

  // Loads the forecast data
  Future<Forecast> _loadForecasts() async {
    DarkSkyHandler handler = new DarkSkyHandler();
    Forecast forecast = await handler.getCurrentForecast();

    return forecast;
  }

  Future<void> _manageCities(BuildContext context) async {
    Navigator.pop(context);
    
    LatLng location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CityList()),
    );

    // NEEDS IMPLEMENTING: Opens detailed weather view of the list view item pressed.
    if (location != null) {
      print("opening new weather-details page");
      latlong = location;
      currentLocCheck = false;
      _findCityName(location.latitude, location.longitude);
    }
    else {
      print("null city added...");
    }
  }

  Future<void> _reminderPage(BuildContext context) async{
    var event = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReminderPage(
          title: AppLocalizations.of(context).translate('Reminders'),
          
        ),
      ),
    );
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
  Future<void> _communityPhotosPage(BuildContext context) async {
    Navigator.pop(context);
    
    City result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityPhotos()),
    );

    if (result != null) {
      print(result);
    }
  }

}