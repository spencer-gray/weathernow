import 'dart:async';
import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DarkSkyHandler {

  Forecast forecast;
  String api;
  DarkSkyHandler({this.forecast});

  Future<Forecast> getCurrentForecast() async {

    var location = new Location();
    var currentLocation;


    try {
        currentLocation = await location.getLocation();
      } catch (e) {
        currentLocation = null;
      }

    await DotEnv().load('.env');

    var darksky = new DarkSkyWeather(DotEnv().env['DARKSKY_API'],
        language: Language.English, units: Units.SI);

    var forecast = await darksky.getForecast(currentLocation.latitude, currentLocation.longitude);

    return forecast;
    
  }

}
