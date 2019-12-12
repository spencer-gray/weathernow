/*
basic settings page where the user can customize the
app to their liking
*/
import 'package:dynamic_theme/dynamic_theme.dart';
import "package:flutter/material.dart";

class SettingsPage extends StatefulWidget {
  final String title;

  SettingsPage({this.title});

  @override
  BuildSettingsPage createState() => BuildSettingsPage();
}

class BuildSettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
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
                Text("Dark Mode"),
              ],
            ),
            Row(
              children: <Widget>[
                Switch(
                    value: false,
                    onChanged: (value) {
                      setState(() {
                        //if(value) value = false;
                        //else value = true;
                      });
                    }),
                Text("Notifications"),
              ],
            ),
            Row(
              children: <Widget>[
                Switch(
                    value: false,
                    onChanged: (value) {
                      setState(() {
                        //if(value) value = false;
                        //else value = true;
                      });
                    }),
                Text("Display Fahrenheit"),
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
                    child: Text("About Us"),
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
            // style: TextStyle(fontStyle: FontStyle.italic),
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
