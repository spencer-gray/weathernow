import 'dart:async';
import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DarkSkyHandler {

  Forecast forecast;

  DarkSkyHandler({this.forecast});

  Future<Forecast> getCurrentForecast() async {

    var location = new Location();

    var currentLocation;

    try {
        currentLocation = await location.getLocation();
      } catch (e) {
        currentLocation = null;
      }

    var darksky = new DarkSkyWeather("72087ea62bfe7c9b995f9086566c05f8",
        language: Language.English, units: Units.SI);
    var forecast = await darksky.getForecast(currentLocation.latitude, currentLocation.longitude);

    return forecast;
    
  }

}
