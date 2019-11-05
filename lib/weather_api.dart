import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherAPI {
  //api website
  static const apiURL = 'http://api.openweathermap.org';

  //setting up api with api key made on openweathermap.org
  static Future run() async {
    WeatherStation weatherStation = new WeatherStation("API_KEY_HERE");
    Weather weather = await weatherStation.currentWeather();

    print("Country: " + weather.country);
    print("Temp: " + (weather.temperature).toString());
   

  }
  

}