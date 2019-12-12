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
import 'package:weathernow/widgets/reminder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weathernow/model/weekdayForecast.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class WeatherView extends StatefulWidget {
  WeatherView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  List<String> weekdays;
  LatLng latlong;
  Future<Forecast> forecast;
  bool currentLocCheck = true;
  String locationTitle = " ";
  bool notif = true;

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

    weekdays = [
      FlutterI18n.translate(context, "weekdays.sunday"),
      FlutterI18n.translate(context, "weekdays.monday"),
      FlutterI18n.translate(context, "weekdays.tuesday"),
      FlutterI18n.translate(context, "weekdays.wednesday"),
      FlutterI18n.translate(context, "weekdays.thursday"),
      FlutterI18n.translate(context, "weekdays.friday"),
      FlutterI18n.translate(context, "weekdays.saturday"),
    ];

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
            WeekdayForecast(weekday: weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[5].time*1000).weekday)%7],
                            dailyLow: snapshot.data.daily.data[5].temperatureMin,
                            dailyHigh: snapshot.data.daily.data[5].temperatureMax),                          
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(locationTitle),
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
                        Column(
                          children: <Widget>[
                            Text(snapshot.data.currently.temperature.toString() + '\xb0C', style: TextStyle(fontSize: 50)),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            Row(
                              children: <Widget>[
                                Text("${FlutterI18n.translate(context, "low")}: " + snapshot.data.daily.data[0].temperatureMin.round().toString() + '\xb0C', style: TextStyle(fontWeight: FontWeight.bold)),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                Text("${FlutterI18n.translate(context, "high")}: " + snapshot.data.daily.data[0].temperatureMax.round().toString() + '\xb0C', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )
                          ], 
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
                    Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                    make5DayForcast(snapshot),

                    // Weekday Low + High Chart
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
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.wind_speed'), style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.windSpeed*1.60934).toStringAsFixed(2) + " km/h", style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.cloud_cover'), style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.cloudCover*100).round().toString() + '%', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.precipitation'), style: TextStyle(fontSize: 11))),
                          DataCell(Text((snapshot.data.currently.humidity*100).round().toString() + '%', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.precipitation_type'), softWrap: true, style: TextStyle(fontSize: 11)),),
                          DataCell(Text(snapshot.data.currently.precipType.toString(), style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.ozone'), style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.ozone.toString() + 'DU', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.dew_point'), style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.dewPoint.toString() + '\xb0C', style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.visibility'), style: TextStyle(fontSize: 11))),
                          DataCell(Text(snapshot.data.currently.visibility.toString().substring(0, 4), style: TextStyle(fontSize: 11)))
                        ]),
                        DataRow(cells: [
                          DataCell(Text(FlutterI18n.translate(context, 'weather_data.pressure'), style: TextStyle(fontSize: 11))),
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
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text(FlutterI18n.translate(context, 'menus.manage_locations')),
                    onTap: () => _manageCities(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text(FlutterI18n.translate(context, 'menus.map')),
                    onTap: () {
                      Navigator.of(context).pop();
                      _mapPage(context);
                    }
                  ),
                   ListTile(
                    leading: Icon(Icons.photo),
                    title: Text(FlutterI18n.translate(context, 'menus.community_photos')),
                    onTap: () => _communityPhotosPage(context),
                  ),
                  notif? ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(FlutterI18n.translate(context, 'menus.reminders')),
                    onTap: () {
                      Locale myLocale = Locale(ui.window.locale.languageCode);
                      print(myLocale);
                      Navigator.of(context).pop();
                      _reminderPage(context);
                    }
                  ) : Padding(padding: EdgeInsets.only(top: 0.0),),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(FlutterI18n.translate(context, 'menus.settings')),
                    onTap: () {
                      Navigator.of(context).pop();
                      _settingsPage(context);
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text(FlutterI18n.translate(context, 'menus.close')),
                    onTap: () {
                      Navigator.pop(context);
                    }
                  )
                ],
              ),
            ),
          );
        }

        else {       
          return LinearProgressIndicator();
        }
      }

    );
  }

  Widget make5DayForcast(AsyncSnapshot<dynamic> snapshot){
    List<Widget> panes = [];
    for(int x = 1; x <= 5; x++){
      panes.add(
        Column(
          children: <Widget>[
            Text(weekdays[(DateTime.fromMillisecondsSinceEpoch(snapshot.data.daily.data[x].time*1000).weekday)%7], style: TextStyle(fontSize: 11)),
            Image.network('https://darksky.net/images/weather-icons/' + snapshot.data.daily.data[x].icon + '.png', width: 25, height: 25,),
            Row (
              children: <Widget>[
                Text(snapshot.data.daily.data[x].temperatureMin.round().toString(), style: TextStyle(fontSize: 11)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Text(snapshot.data.daily.data[x].temperatureMax.round().toString(), style: TextStyle(fontSize: 11)),
              ],
            ),
          ]
        )
      );
      if(x < 5)
        panes.add(Padding(padding: EdgeInsets.symmetric(horizontal: 13)));
    }

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(
        color: Colors.blueGrey,
        width: 1.0,
        style: BorderStyle.solid,
      )),
      child: Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: panes
      )
    );
  }

  // finds location 
  Future<void> _findCityName(double lat, double long) async{
    var address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(lat, long));

    // if country is specified
    if (address.first.adminArea == null) {
      locationTitle = address.first.countryName;
    }
    // if city is specified
    else if (address.first.subAdminArea == null) {
      locationTitle = address.first.adminArea + ", " + address.first.countryName;
    }
    // handles when current devices locoality is null
    else if (address.first.locality == null) {
      locationTitle = address.first.subAdminArea + ", " + address.first.adminArea;
    }
    else {
      locationTitle = address.first.locality + ", " + address.first.adminArea;
    }
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
      MaterialPageRoute(builder: (context) => CityList(
        title: FlutterI18n.translate(context, 'menus.manage_locations'),
      )),
    );

    // Opens detailed weather view of the list view item pressed.
    if (location != null) {
      latlong = location;
      currentLocCheck = false;
      _findCityName(location.latitude, location.longitude);
    }
    else {
      print("null city added...");
    }
  }

  Future<void> _reminderPage(BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReminderPage(
          title: FlutterI18n.translate(context, 'menus.reminders'),
        ),
      ),
    );
  }

  Future<void> _settingsPage(BuildContext context) async{
  
    var event = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          title: FlutterI18n.translate(context, 'menus.settings'),
          notif: notif,
        ),
      ),
    );
    notif = event;

  }

  Future<void> _mapPage(BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          title: FlutterI18n.translate(context, 'menus.map'),
        ),
      ),
    );
  }

  Future<void> _communityPhotosPage(BuildContext context) async {
    Navigator.pop(context);
    
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityPhotos(
        title: FlutterI18n.translate(context, 'menus.community_photos'),
      )),
    );

  }

}