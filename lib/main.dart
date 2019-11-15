import 'package:flutter/material.dart';
import 'package:weathernow/widgets/settings.dart';
import 'widgets/google_search.dart';
import 'widgets/weather-view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


void main() => runApp(WeatherNow());

class WeatherNow extends StatelessWidget {

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme){
        return new MaterialApp(
          title: 'WeatherNow',
          theme: theme,
          home: WeatherView(title: 'WeatherNow', ),
          routes: <String, WidgetBuilder>{
            '/searchPage': (BuildContext context) {
              return SearchPage();
            },
            '/settingsPage': (BuildContext context) {
              return SettingsPage(title: "Settings",);
            },
            '/mapPage': (BuildContext context){
              return SettingsPage();
            },
          },
          debugShowCheckedModeBanner: false
        );
      },
    );
  }
}

