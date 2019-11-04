import 'package:flutter/material.dart';
import 'weather-view.dart';

void main() => runApp(WeatherNow());

class WeatherNow extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherNow',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: WeatherView(title: 'WeatherNow'),
      debugShowCheckedModeBanner: false
    );
  }
}

