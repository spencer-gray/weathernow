/*
basic settings page where the user can customize the
app to their liking
*/
import 'package:dynamic_theme/dynamic_theme.dart';
import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  final bool notif;

  SettingsPage({this.notif, this.title});

  @override
  BuildSettingsPage createState() => BuildSettingsPage();
}

class BuildSettingsPage extends State<SettingsPage> {

  bool returnNotif;
  String _current;
  List<String> locales = ['en', 'fr'];

  @override
  Widget build(BuildContext context) {

    if(returnNotif == null){
      returnNotif = widget.notif;
      _current = Localizations.localeOf(context).languageCode;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop(returnNotif),
        ),
      ),
      body: Align(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15),),
                Icon(Icons.brightness_3),
                Padding(padding: EdgeInsets.only(left: 15),),
                Text(FlutterI18n.translate(context, 'settings.dark_mode')),
                Switch(
                  value: Theme.of(context).brightness == Brightness.light
                      ? false
                      : true,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        DynamicTheme.of(context).setBrightness(Brightness.dark);
                      } else {
                        DynamicTheme.of(context)
                            .setBrightness(Brightness.light);
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15),),
                Icon(Icons.chat_bubble),
                Padding(padding: EdgeInsets.only(left: 15),),
                Text(FlutterI18n.translate(context, 'settings.notifications')),
                Switch(
                  value: returnNotif,
                  onChanged: (value) {
                    setState(() {
                      print(value);
                      if(value){returnNotif = true;}
                      else {returnNotif = false;}
                      print(returnNotif);
                    });
                  }
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15),),
                Icon(Icons.loop),
                Padding(padding: EdgeInsets.only(left: 15),),
                Text(FlutterI18n.translate(context, 'settings.language')),
                Padding(padding: EdgeInsets.only(left: 15)),
                DropdownButton(
                  value: _current,
                  items: locales.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: ((String change) {
                    Locale locale = new Locale(change);
                    setState(() {
                      FlutterI18n.refresh(context, locale);
                      _current = change;
                    });
                  }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    size: 30.0,
                  ),
                  FlatButton(
                    child: Text(FlutterI18n.translate(context, 'settings.about_us')),
                    onPressed: _showAboutUs,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAboutUs() async {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "WeatherNow",
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
          content: Text(
            "A weather tracking app\n\n" +
                "CSCI 4100U Group Project\n\n" +
                "Group Members: \nSpencer Gray\nHassan Tariq\nJames LeBlanc\n\n" +
                "GitHub Source Code: \n" +
                "https://github.com/spencer-gray/weathernow",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
