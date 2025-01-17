import 'package:flutter/material.dart';
import 'package:weathernow/widgets/settings.dart';
import 'widgets/google_search.dart';
import 'widgets/weather-view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:weathernow/widgets/reminder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';


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

          //i18n 
          supportedLocales: [
            Locale('en'),
            Locale('fr'),
          ],
          localizationsDelegates: [
            // load json
            FlutterI18nDelegate(
              useCountryCode: false,
              fallbackFile: 'en',
              path: 'lang',
            ),
            // basic text
            GlobalMaterialLocalizations.delegate,
            // direct text
            GlobalWidgetsLocalizations.delegate,
          ],                   
          // locale used by app
          localeResolutionCallback: (locale, supportedLocales) {
            // check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            // default to en if locale not avaiable
            return supportedLocales.first;
          },

          home: SplashScreen(
            'animation/splashscreen.flr',
            WeatherView(title: 'WeatherNow',),
            startAnimation: 'intro',
            endAnimation: 'loading_circle',
            backgroundColor: Colors.white,
          ),
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
            '/reminderPage': (BuildContext context){
              return ReminderPage();
            },
          },
          debugShowCheckedModeBanner: false,
          
        );
      },
    );
  }
}

