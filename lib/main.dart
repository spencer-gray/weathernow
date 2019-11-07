import 'package:flutter/material.dart';
import 'widgets/google_search.dart';
import 'widgets/weather-view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


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
      routes: <String, WidgetBuilder>{
        '/searchPage': (BuildContext context) {
          return SearchPage();
        },
      },
      debugShowCheckedModeBanner: false
    );
  }
}

